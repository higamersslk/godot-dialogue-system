class_name DialogueArea2D 
extends Area2D


signal player_entered_dialogue_area
signal player_left_dialogue_area


@export var entry_label: StringName
@export var insta_dialogue: bool
@export var text_box: PackedScene
@export var dialogue_container: DialogueContainer

var is_inside_area: bool
var dialogue_manager: DialogueManager
var player: Player


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("chat"): return
	if not is_inside_area: return
	if dialogue_manager: return

	_start_dialogue()


func _on_body_entered(body: Node) -> void:
	if body is not Player: return
	if not dialogue_container or not text_box: return
	if not dialogue_container.dialogues.has(entry_label): return

	player = body
	player_entered_dialogue_area.emit()
	if insta_dialogue:
		_start_dialogue()
	else:
		is_inside_area = true


func _on_body_exited(body: Node) -> void:
	if body is not Player: return
	
	_end_dialogue()
	player_left_dialogue_area.emit()
	
	is_inside_area = false
	player = null


func _start_dialogue() -> void:
	if dialogue_manager: return

	dialogue_manager = DialogueManager.new()
	dialogue_manager.name = "DialogueManager"
	dialogue_manager.context = {
		"player": player,
		"text_box": text_box,
		"dialogue_area": self,
		"parent": get_parent()
	}

	dialogue_manager.current_dialogue_label = entry_label

	dialogue_manager.dialogue_ended.connect(_end_dialogue.call_deferred, CONNECT_ONE_SHOT)
	add_child(dialogue_manager)
	dialogue_manager.start_dialogue(dialogue_container)


func _end_dialogue() -> void:
	if dialogue_manager:
		dialogue_manager.end_dialogue()
		dialogue_manager.queue_free()

	dialogue_manager = null
	player = null
