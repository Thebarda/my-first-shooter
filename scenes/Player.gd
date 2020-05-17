extends KinematicBody2D

enum {IDLE, WALK}

const MAX_WALK_SPEED = 400.0
const GRAVITY = 40.0
const jump_force = 900.0

var look_direction = Vector2(1, 0)
var velocity = Vector2.ZERO
var state
var inertia = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(IDLE)
	
func change_state(new_state):
	if new_state == WALK:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")
	state = new_state

func start(start_position):
	position = 	start_position


func _physics_process(delta):
	get_input_direction()
	velocity.y += GRAVITY

	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y -= jump_force
		
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI / 4, false)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)


func get_input_direction():
	if Input.is_action_pressed("move_right"):
		look_direction.x = 1
		velocity.x = MAX_WALK_SPEED
		$AnimatedSprite.flip_h = false
		change_state(WALK)
	elif Input.is_action_pressed("move_left"):
		look_direction.x -= 1
		velocity.x = -MAX_WALK_SPEED
		$AnimatedSprite.flip_h = true
		change_state(WALK)
	else:
		velocity.x = 0
		$AnimatedSprite.flip_h = false
		change_state(IDLE)

