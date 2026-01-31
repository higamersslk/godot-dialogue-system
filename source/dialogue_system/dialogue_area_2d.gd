class_name DialogueArea2D 
extends Area2D


signal player_entered_dialogue_area
signal player_left_dialogue_area


@export var entry_label: StringName
@export var insta_dialogue: bool
@export var text_box: PackedScene
@export var dialogue_container: DialogueContainer

var _is_inside_area: bool
var _dialogue_manager: DialogueManager
var _player: Player


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("chat"): return
	if not _is_inside_area: return
	if _dialogue_manager: return

	_start_dialogue()


func _on_body_entered(body: Node) -> void:
	if body is not Player: return
	if not dialogue_container or not text_box: return
	if not dialogue_container.dialogues.has(entry_label): return

	_player = body
	player_entered_dialogue_area.emit()
	if insta_dialogue:
		_start_dialogue()
	else:
		_is_inside_area = true


func _on_body_exited(body: Node) -> void:
	if body is not Player: return
	
	_end_dialogue()
	player_left_dialogue_area.emit()
	
	_is_inside_area = false
	_player = null


func _start_dialogue() -> void:
	if _dialogue_manager: return

	_dialogue_manager = DialogueManager.new()
	_dialogue_manager.name = "DialogueManager"
	_dialogue_manager.context = {
		"player": _player,
		"text_box": text_box,
		"dialogue_area": self,
		"parent": get_parent()
	}

	_dialogue_manager.current_dialogue_label = entry_label

	_dialogue_manager.dialogue_ended.connect(_end_dialogue.call_deferred, CONNECT_ONE_SHOT)
	add_child(_dialogue_manager)
	_dialogue_manager.start_dialogue(dialogue_container)


func _end_dialogue() -> void:
	if _dialogue_manager:
		_dialogue_manager.end_dialogue()
		_dialogue_manager.queue_free()

	_dialogue_manager = null
	_player = null
