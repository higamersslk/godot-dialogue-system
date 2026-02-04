class_name DialogueManager
extends Node2D


signal dialogue_started(topic_id: StringName)
signal dialogue_ended(topic_id: StringName)
signal continue_next

@export_group("Dialogue Settings")
@export var entry_topic: StringName
@export var one_time_dialogue: bool
@export var dialogue_box_position_offset: Vector2

@export_group("Resources")
@export var dialogue_container: DialogueContainer
@export var dialogue_box_scene: PackedScene
@export var trigger: DialogueArea2D

var player: Player
var dialogue_box: DialogueTextBox

var current_topic_id: StringName
var current_node_index: int = -1
var current_node: DialogueNode

var _topics_data: Dictionary[StringName, Array]
var _nodes: Array

var is_chatting: bool
var _dialogue_finished: bool

static var registered_functions: Array[Callable]


func _ready() -> void:
	if not dialogue_container:
		push_warning("Dialogue Manager: no valid dialogue container.")
		return
	if not dialogue_box_scene:
		push_warning("Dialogue manager: no valid dialogue box scene.")
		return
	if not _instantiate_dialogue_box():
		push_warning("DialogueManager: couldn't instance dialogue box.")
		return
	
	if trigger:
		trigger.player_trigged_dialogue.connect(_on_dialogue_trigged)
		trigger.player_left_dialogue_area.connect(force_end_dialogue)

	current_topic_id = entry_topic
	_topics_data = dialogue_container.topics


func _input(event: InputEvent) -> void:
	if _dialogue_finished: return
	if not is_chatting: return
	if not event.is_action_pressed("interact"): return

	if dialogue_box.is_typing:
		dialogue_box.skip_typing()
	else:
		continue_next.emit()


func _process_nodes() -> void:
	current_node_index += 1
	if current_node_index >= _nodes.size():
		end_dialogue()
		return

	is_chatting = true
	current_node = _nodes[current_node_index]
	current_node.finished.connect(_process_nodes, CONNECT_ONE_SHOT)
	current_node.execute(self)


func _on_dialogue_trigged(_player: Player) -> void:
	player = _player
	start_dialogue()


func _instantiate_dialogue_box() -> bool:
	var instanced_box: Node = dialogue_box_scene.instantiate()
	if instanced_box is not DialogueTextBox:
		var target_dialogue_boxes: Array[Node] = instanced_box.find_children("*", "DialogueTextBox")
		if target_dialogue_boxes.is_empty():
			return false
		dialogue_box = target_dialogue_boxes[0]
	elif instanced_box is DialogueTextBox:
		dialogue_box = instanced_box
	else:
		return false
	
	if dialogue_box:
		dialogue_box.hide()
		dialogue_box.global_position += dialogue_box_position_offset
		add_child(instanced_box)

	return true


func start_dialogue(topic_id: StringName = current_topic_id) -> void:
	if one_time_dialogue and _dialogue_finished: return
	_dialogue_finished = false
	switch_topic(topic_id)
	_process_nodes()
	dialogue_started.emit(topic_id)


func switch_topic(topic_id: StringName) -> void:
	if one_time_dialogue and _dialogue_finished: return
	if _topics_data.is_empty() or not _topics_data.has(topic_id):
		push_warning("Dialogue manager: no dialogue data found.")
		return

	current_node_index = -1
	current_topic_id = topic_id
	_nodes = _topics_data[topic_id]


func end_dialogue() -> void:
	_dialogue_finished = true
	is_chatting = false
	player = null
	current_node = null

	dialogue_box.hide()
	dialogue_ended.emit(current_topic_id)


func force_end_dialogue() -> void:
	if _dialogue_finished: return
	if current_node:
		if current_node.finished.is_connected(_process_nodes):
			current_node.finished.disconnect(_process_nodes)
		current_node.cancel(self)

	if dialogue_box.is_typing:
		dialogue_box.skip_typing()
	
	clean_up_signals()
	end_dialogue()


func clean_up_signals() -> void:
	var text_finished: Signal = dialogue_box.text_finished
	
	for connection: Dictionary in text_finished.get_connections():
		text_finished.disconnect(connection.callable)

	for connection: Dictionary in continue_next.get_connections():
		continue_next.disconnect(connection.callable)


static func subscribe(function: Callable) -> void:
	if registered_functions.has(function): return
	registered_functions.append(function)


static func unsubscribe(function: Callable) -> void:
	if not registered_functions.has(function): return
	registered_functions.erase(function)
