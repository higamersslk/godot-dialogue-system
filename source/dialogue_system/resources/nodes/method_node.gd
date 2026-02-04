class_name DialogueMethodNode
extends DialogueNode


@export var method_name: String
@export var arguments: PackedStringArray


func execute(manager: DialogueManager) -> void:
    manager.execute_method(method_name, arguments)
    finished.emit()