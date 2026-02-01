class_name DialogueTextBlock
extends DialogueBlock

## Array with multiple dialogues text.
@export var dialogues_text: Array[String]
## Array with multiple audios. Match the audio index with the corresponding dialogue text index.
@export var dialogues_audio: Array[AudioStream]
## Override the default text speed.[br] Sets back to 0 if doenst want to override the default text speed.
@export_range(0.0,20.0) var text_speed: float = 0.0
## If sets to true, will randomize the dialogue on every interaction.
@export var randomize_dialogue: bool


func execute(manager: DialogueManager) -> void:
	if dialogues_text.is_empty():
		finished.emit()
		return

	manager.show_text_box()
	var text_box: TextBox = manager.text_box
	if randomize_dialogue:
		var total_dialogues: int = dialogues_text.size()
		var random_num: int = randi() % total_dialogues
		print(random_num)
		text_box.display_text(dialogues_text[random_num], text_speed)
		await text_box.text_finished
		await text_box.continue_next
	else:
		for text: String in dialogues_text:
			text_box.display_text(text, text_speed)
			await text_box.text_finished
			await text_box.continue_next
	
	manager.hide_text_box()
	finished.emit()
