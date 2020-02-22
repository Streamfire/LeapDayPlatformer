extends KinematicBody2D

const GRAVITY = 600
const SPEED = 300
const JUMP_POWER = 450
const UP_VECTOR = Vector2(0,-1)

var moving_direction = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	moving_direction.x = 0
	if is_on_ceiling() or is_on_floor():
		moving_direction.y = 0
	moving_direction.y += GRAVITY * delta
	
	check_input()
	move_and_slide(moving_direction, UP_VECTOR)

func check_input():
	
	if Input.is_action_pressed("left"):
		moving_direction.x = -1 * SPEED
	
	if Input.is_action_pressed("right"):
		moving_direction.x = SPEED
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
			moving_direction.y = -JUMP_POWER
