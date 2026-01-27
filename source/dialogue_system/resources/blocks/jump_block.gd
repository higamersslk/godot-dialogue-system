class_name DialogueJumpBlock 
extends DialogueBlock


@export var goto_label: StringName
# to do condition later.

func execute(manager: DialogueManager) -> void:
	if manager.dialogue_data.has(goto_label):
		manager.current_dialogue_label = goto_label
		manager.current_block_index = -1
		manager.current_blocks = manager.dialogue_data[goto_label]
	
	finished.emit()
