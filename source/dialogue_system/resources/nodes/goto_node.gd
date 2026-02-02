class_name DialogueGotoNode 
extends DialogueNode


@export var goto_id: StringName


func execute(manager: DialogueManager) -> void:
	finished.emit()
