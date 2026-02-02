## Base class for Dialogue Resources.
class_name DialogueNode
extends Resource


signal finished


func execute(_dialogue_manager: DialogueManager) -> void:
    finished.emit()