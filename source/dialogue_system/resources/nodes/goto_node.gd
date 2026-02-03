class_name DialogueGotoNode 
extends DialogueNode


@export var goto_id: StringName
@export var goto_index: int = 0


func execute(manager: DialogueManager) -> void:
	var topic_id: String = manager.current_topic_id if goto_id.is_empty() else goto_id
	manager.switch_topic(topic_id)
	manager.current_node_index = goto_index -1 if goto_index else manager.current_node_index
	finished.emit()