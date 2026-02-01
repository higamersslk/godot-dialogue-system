class_name TextBox
extends MarginContainer


signal text_finished
signal continue_next

@export var dialogue_label: RichTextLabel

var _current_tween: Tween
var _is_typing: bool

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if _is_typing:
			skip_typing()
		else:
			continue_next.emit()


func display_text(text: String, text_speed: float) -> void:
	if _current_tween:
		_current_tween.kill()
	
	dialogue_label.text = text
	dialogue_label.visible_characters = 0

	var total_characters: int = dialogue_label.get_total_character_count()
	_is_typing = true
	
	_current_tween = create_tween()
	_current_tween.tween_property(dialogue_label, "visible_characters", total_characters, text_speed)
	_current_tween.finished.connect(_on_tween_end, CONNECT_ONE_SHOT)


func skip_typing() -> void:
	if not _is_typing: return
	if _current_tween and _current_tween.is_running():
		_current_tween.kill()
		_current_tween.finished.disconnect(_on_tween_end)
		dialogue_label.visible_characters = dialogue_label.get_total_character_count()
	
	_is_typing = false
	text_finished.emit()


func _on_tween_end() -> void:
	_is_typing = false
	text_finished.emit()