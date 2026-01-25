class_name DialogueBlock
extends Resource
## Base class for dialogue resources

@warning_ignore("unused_signal")
signal finished


func start() -> void:
    finished.emit()
    pass