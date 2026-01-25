## class DialogueSystem 
## Autoload
extends Node


signal dialogue_requested(area: DialogueArea2D, player: Player)

const DEFAULT_TEXT_BOX: PackedScene = preload("res://source/dialogue_system/text_box.tscn")

var text_box: TextBox
var current_dialogue_data: Dictionary[StringName, Array]

var current_block_index: int = -1
var current_dialogue_label: StringName

var player_ref: Player


func _ready() -> void:
	dialogue_requested.connect(_on_dialogue_requested)


func _on_dialogue_requested(area: DialogueArea2D, player: Player) -> void:
	current_dialogue_data = area.dialogue_container.dialogues
	current_dialogue_label = &"start"
	player_ref = player

	var dialogue_blocks: Array = current_dialogue_data[current_dialogue_label]
	if dialogue_blocks.is_empty():
		current_dialogue_data = {&"start": []}
		return

	area.player_left_dialogue_area.connect(_end_dialogue, CONNECT_ONE_SHOT)
	process_blocks(dialogue_blocks)


func _on_block_finished() -> void:
	print(current_dialogue_label)
	process_blocks.call_deferred(current_dialogue_data[current_dialogue_label])


func process_blocks(dialogue_blocks: Array) -> void:
	current_block_index += 1
	if current_block_index == dialogue_blocks.size():
		_end_dialogue()
		return
	
	var block: DialogueBlock = dialogue_blocks[current_block_index]
	show_text_box()

	block.finished.connect(_on_block_finished, CONNECT_ONE_SHOT)
	block.start()


func show_text_box() -> void:
	if not text_box:
		text_box = DEFAULT_TEXT_BOX.instantiate() as TextBox
	
	text_box.visible = true
	text_box.position = Vector2(450, 130) #to do: proper position above DialogueArea2D

	if not text_box.is_inside_tree():
		get_parent().add_child(text_box)


func hide_text_box() -> void:
	if not text_box: return
	text_box.visible = false

	if text_box.is_inside_tree():
		get_parent().call_deferred("remove_child", text_box)


func _end_dialogue() -> void:
	var dialogue_blocks: Array = current_dialogue_data.get(current_dialogue_label, [])
	var block = dialogue_blocks.get(current_block_index)

	# fix later: warning errors with out of bounds array.
	if block and block.finished.is_connected(_on_block_finished):
		block.finished.disconnect(_on_block_finished)

	current_block_index = -1
	hide_text_box()
