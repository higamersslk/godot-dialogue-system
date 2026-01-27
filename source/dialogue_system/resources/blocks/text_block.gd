class_name DialogueTextBlock
extends DialogueBlock

## Array with multiple dialogues text.
@export var dialogues_text: Array[String]
## Array with multiple audios. Match the audio index with the corresponding dialogue text index.
@export var dialogues_audio: Array[AudioEffect]
## Override the default text speed.[br] Sets back to 0 if doenst want to override the default text speed.
@export_range(0.0,20.0) var text_speed: float = 0.0
## If sets to true, will randomize the dialogue on every interaction.
@export var randomize_dialogue: bool


func execute(manager: DialogueManager) -> void:
    manager.show_text_box()
    for text: String in dialogues_text:
        manager.text_box.label_text = text
        await manager.text_box.continue_interact
    
    manager.hide_text_box()
    finished.emit()