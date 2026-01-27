class_name DialogueBlock
extends Resource
## Base class for dialogue resources

signal finished


func execute(_dialogue_manager: DialogueManager) -> void:
    finished.emit()