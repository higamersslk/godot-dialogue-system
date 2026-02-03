class_name DialogueTextBox
extends MarginContainer


signal text_finished


@export var dialogue_label: RichTextLabel
@export var info_container: MarginContainer
@export var info_label: RichTextLabel

var is_typing: bool
var _current_tween: Tween


func _ready() -> void:
	dialogue_label.meta_hover_started.connect(_on_meta_hovered)
	dialogue_label.meta_hover_ended.connect(_on_meta_hover_end)


func display_text(text: String, text_speed: float) -> void:
	dialogue_label.text = text
	dialogue_label.visible_characters = 0
	is_typing = true

	var total_characters: int = dialogue_label.get_total_character_count()
	
	_current_tween = create_tween()
	_current_tween.tween_property(dialogue_label, "visible_characters", total_characters, text_speed)
	_current_tween.finished.connect(_on_tween_end, CONNECT_ONE_SHOT)


func skip_typing() -> void:
	if not is_typing: return
	if _current_tween:
		_current_tween.kill()

	dialogue_label.visible_characters = dialogue_label.get_total_character_count()
	is_typing = false
	_current_tween = null
	text_finished.emit()


func _on_tween_end() -> void:
	is_typing = false
	text_finished.emit()


func _on_meta_hovered(meta: String) -> void:
	var info: Dictionary = _get_meta_info(meta)
	if info.is_empty(): return

	var text_color: Color = info["color"]
	var description: String = info["description"]

	info_container.visible = true
	info_container.global_position = get_global_mouse_position() + Vector2(0, -30)
	info_label.push_color(text_color)
	info_label.text = description


func _on_meta_hover_end(_meta: String) -> void:
	info_container.visible = false


func _get_meta_info(meta: String) -> Dictionary:
	## Hardcoded
	var items: Dictionary = {
		"sword": {"color": Color.BLUE, "description": "Sword forged by the gods of Olympus"},
		"cat": {"color": Color.ALICE_BLUE, "description": "cute kawaii cat."},
		"old_lady": {"color": Color.BEIGE, "description": "angry old lady, she lives in a weird town."}
	}

	return items.get(meta.to_lower(), {})