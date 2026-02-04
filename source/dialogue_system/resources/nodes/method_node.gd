class_name DialogueMethodNode
extends DialogueNode


@export var method_name: String
@export var arguments: PackedStringArray


func execute(_manager: DialogueManager) -> void:
    execute_method()
    finished.emit()


func execute_method() -> void:
    if not DialogueManager.registered_functions.has(method_name): return
    var method: Callable = DialogueManager.registered_functions[method_name]
    if method.is_valid():
        method.callv(arguments)