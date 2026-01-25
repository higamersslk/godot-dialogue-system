class_name DialogueJumpBlock 
extends DialogueBlock


@export var goto_label: StringName
# to do condition later.

func start() -> void:
    DialogueSystem.current_dialogue_label = goto_label
    DialogueSystem.current_block_index = -1
    finished.emit()