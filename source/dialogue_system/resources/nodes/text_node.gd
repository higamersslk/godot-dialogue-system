class_name DialogueTextNode
extends DialogueNode

@export_group("Dialogue Text")
@export_multiline var dialogues_text: PackedStringArray
## Match the audio index with the corresponding dialogue text index.
@export var dialogues_audio: Array[AudioStream]
## Typewriting text effect speed. Sets to 0 for instant text display.
@export_range(0.0,20.0) var text_speed: float = 1.0

@export_group("")
## Randomize dialogue on every interaction. [br]
## Sets to false if want linear text displaying.
@export var randomize_dialogue: bool


func execute(manager: DialogueManager) -> void:
	#if dialogues_text.is_empty():
	finished.emit()
	#	return

	#manager.show_text_box()
	#var text_box: TextBox = manager.text_box
	#if randomize_dialogue:
	#	var total_dialogues: int = dialogues_text.size()
	#	var random_num: int = randi() % total_dialogues
	#	text_box.display_text(dialogues_text[random_num], text_speed)
	#	await text_box.text_finished
	#	await text_box.continue_next
	#else:
	#	for text: String in dialogues_text:
	#		text_box.display_text(text, text_speed)
	#		await text_box.text_finished
	#		await text_box.continue_next
	
	#manager.hide_text_box()
	#finished.emit()
