class_name Player extends Character

const SPEED: int = 100

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _process(_delta: float) -> void:
    var input_direction = Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * SPEED

    process_animation(input_direction)
    move_and_slide()


func process_animation(input_direction: Vector2) -> void:
    sprite.flip_h = velocity.x < 0

    if input_direction:
        sprite.play("walk_side")
    else:
        sprite.play("idle")
    