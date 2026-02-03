class_name DialogueArea2D 
extends Area2D


signal player_trigged_dialogue(player: Player)
signal player_left_dialogue_area


@export var interaction_hint: PackedScene
@export var hint_position_offset: Vector2
@export var instant_trigger: bool

var player_is_inside_area: bool

var _interaction_hint_ref: TouchScreenButton
var _player_ref: Player


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if not player_is_inside_area: return
	if not event.is_action_pressed("chat"): return
	player_is_inside_area = false
	player_trigged_dialogue.emit(_player_ref)
	hide_interaction_hint()


func _on_body_entered(body: Node) -> void:
	if body is not Player: return
	if instant_trigger:
		player_trigged_dialogue.emit(body)
	else:
		player_is_inside_area = true
		_player_ref = body
		show_interaction_hint()


func _on_body_exited(body: Node) -> void:
	if body is not Player: return
	_player_ref = null
	player_is_inside_area = false
	player_left_dialogue_area.emit()
	hide_interaction_hint()


func show_interaction_hint() -> void:
	if not interaction_hint: return
	if not _interaction_hint_ref:
		_interaction_hint_ref = interaction_hint.instantiate()
		_interaction_hint_ref.global_position = self.position + hint_position_offset
		add_child(_interaction_hint_ref)
	
	_interaction_hint_ref.visible = true


func hide_interaction_hint() -> void:
	if not _interaction_hint_ref: return
	_interaction_hint_ref.visible = false