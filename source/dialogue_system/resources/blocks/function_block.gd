class_name DialogueFunctionBlock
extends DialogueBlock


enum MethodType {
	NODE,
	STATIC
}

## The type used to call the method.
@export var method_type: MethodType
@export_group("Method")
## The [Node] to call the method.
@export var node_path: NodePath
## The [Script] to call the method. Methods most be static functions to be called.
@export var static_method: Script
## The [Node] or [Script] method name.
@export var method_name: String
## The method parameters.
@export var args: Array


## TO DO