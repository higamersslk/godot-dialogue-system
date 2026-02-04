class_name DialogueTextBox
extends Control


signal text_finished


@export var dialogue_label: RichTextLabel


var is_typing: bool
var _current_tween: Tween


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
