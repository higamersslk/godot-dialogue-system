## Base class for Dialogue Resources.
class_name DialogueNode
extends Resource


signal finished

var _cancelled: bool


func execute(_dialogue_manager: DialogueManager) -> void:
    finished.emit()


func cancel(_dialogue_manager: DialogueManager) -> void:
    _cancelled = true
    finished.emit()