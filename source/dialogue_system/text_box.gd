class_name TextBox
extends MarginContainer


signal continue_interact


@onready var label: RichTextLabel = $MarginContainer/Label
@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer


var label_text: String:
	set(value):
		label.text = value

var audio: AudioStream:
	set(value):
		audio_stream.stream = value


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		continue_interact.emit()
