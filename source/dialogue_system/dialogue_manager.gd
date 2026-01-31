class_name DialogueManager
extends Node2D


signal dialogue_started
signal dialogue_ended


var text_box: TextBox

var context: Dictionary
var dialogue_data: Dictionary[StringName, Array]
var current_blocks: Array

var current_block_index: int = -1
var current_dialogue_label: StringName

static var registered_functions: Dictionary[String, Callable]


func start_dialogue(dialogue_container: DialogueContainer) -> void:
	dialogue_data = dialogue_container.dialogues
	current_blocks = dialogue_data[current_dialogue_label] as Array[DialogueBlock]

	if current_blocks.is_empty():
		end_dialogue()
		return
	
	dialogue_started.emit()
	_instantiate_text_box()
	_next_block()


func end_dialogue() -> void:
	text_box.queue_free()
	dialogue_ended.emit()


func show_text_box() -> void:
	if not text_box:
		_instantiate_text_box()
	text_box.visible = true
	

func hide_text_box() -> void:
	if not text_box: return
	text_box.visible = false


func _next_block() -> void:
	current_block_index += 1
	if current_block_index >= current_blocks.size():
		end_dialogue()
		return
	
	var block: DialogueBlock = current_blocks[current_block_index]
	block.finished.connect(_next_block, CONNECT_ONE_SHOT)
	block.execute(self)


func _instantiate_text_box() -> void:
	if text_box: return

	text_box = context["text_box"].instantiate() as TextBox
	text_box.visible = false

	var dialogue_area: DialogueArea2D = context["dialogue_area"]
	text_box.position = to_local(dialogue_area.global_position + Vector2(0, -50))
	dialogue_area.add_child(text_box)
