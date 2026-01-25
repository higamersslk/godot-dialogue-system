class_name DialogueArea2D 
extends Area2D


signal player_entered_dialogue_area()
signal player_left_dialogue_area()


@export var dialogue_container: DialogueContainer

var is_inside_area: bool
var insta_interact: bool
var player: Player


func _ready() -> void:
    self.body_entered.connect(_on_body_entered)
    self.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
    if not is_inside_area: return
    if Input.is_action_just_pressed("chat") or insta_interact:
        is_inside_area = false # prevent signal spam.
        DialogueSystem.dialogue_requested.emit(self, player)


func _on_body_entered(body: Node) -> void:
    if body is not Player: return
    if not dialogue_container: return

    player = body
    is_inside_area = true
    insta_interact = dialogue_container.insta_dialogue

    player_entered_dialogue_area.emit()


func _on_body_exited(body: Node) -> void:
    if body is not Player: return

    player = null
    is_inside_area = false

    player_left_dialogue_area.emit()