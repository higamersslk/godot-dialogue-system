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

var _current_text_index: int


func execute(manager: DialogueManager) -> void:
	_current_text_index = -1
	_cancelled = false

	if randomize_dialogue:
		_display_random_text(manager)
	else:
		_display_linear_text(manager)


func _on_text_finished(manager: DialogueManager) -> void:
	if _cancelled: return
	
	if randomize_dialogue:
		manager.continue_next.connect(finished.emit, CONNECT_ONE_SHOT)
	else:
		manager.continue_next.connect(_display_linear_text.bind(manager), CONNECT_ONE_SHOT)


func _display_linear_text(manager: DialogueManager) -> void:
	var dialogue_box: DialogueTextBox = manager.dialogue_box

	_current_text_index += 1
	if _current_text_index >= dialogues_text.size():
		dialogue_box.hide()
		finished.emit()
		return
	
	var text: String = dialogues_text[_current_text_index]

	dialogue_box.show()
	dialogue_box.display_text(text, text_speed)
	dialogue_box.text_finished.connect(_on_text_finished.bind(manager), CONNECT_ONE_SHOT)


func _display_random_text(manager: DialogueManager) -> void:
	var dialogue_box: DialogueTextBox = manager.dialogue_box
	var random_num: int = randi() % dialogues_text.size()
	var text: String = dialogues_text[random_num]

	dialogue_box.show()
	dialogue_box.display_text(text, text_speed)
	dialogue_box.text_finished.connect(_on_text_finished.bind(manager), CONNECT_ONE_SHOT)
