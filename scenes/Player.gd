extends KinematicBody2D

enum {IDLE, WALK}

const MAX_WALK_SPEED = 400.0
const GRAVITY = 40.0
const jump_force = 900.0

var look_direction = Vector2(1, 0)
var velocity = Vector2.ZERO
var state
var inertia = 100
var can_fire = true
var is_shooting = false
var shoot_timer
var rate_of_fire = 0.4
enum {LEFT, RIGHT}
onready var player_arm_orientation

var bullet = preload("res://Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(IDLE)
	
func change_state(new_state):
	if new_state == WALK:
		$"arm/Sprite".show()
		$"WeaponPivot/PositionWeapon/Weapon".show()
		$AnimatedSprite.play("walk")
		rotate_player()
	elif is_shooting:
		$"arm/Sprite".show()
		$"WeaponPivot/PositionWeapon/Weapon".show()
		$AnimatedSprite.play("shoot")
		rotate_player()
	else:
		$AnimatedSprite.play("idle")
		$"arm/Sprite".hide()
		$"WeaponPivot/PositionWeapon/Weapon".hide()
	state = new_state

func start(start_position):
	position = 	start_position

func rotate_player():
	print(player_arm_orientation)
	if player_arm_orientation == LEFT:
		$AnimatedSprite.flip_h = true
	elif player_arm_orientation == RIGHT:
		$AnimatedSprite.flip_h = false

func _physics_process(delta):
	get_input_direction()
	velocity.y += GRAVITY
	
	shoot()

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
		$AnimatedSprite.set_offset(Vector2(0, 0))
		change_state(WALK)
	elif Input.is_action_pressed("move_left"):
		look_direction.x -= 1
		velocity.x = -MAX_WALK_SPEED
		$AnimatedSprite.set_offset(Vector2(-2, 0))
		change_state(WALK)
	else:
		velocity.x = 0
		$AnimatedSprite.flip_h = false
		change_state(IDLE)

func _on_arm_rotate_player(arm_orientation):
	if arm_orientation == "left":
		player_arm_orientation = LEFT
		$AnimatedSprite.flip_h = true
	else:
		player_arm_orientation = RIGHT
		$AnimatedSprite.flip_h = false
		
func shoot():
	if Input.is_action_pressed("shoot"):
		if can_fire:
			is_shooting = true
			can_fire = false
			var bullet_instance = bullet.instance()
			bullet_instance.position = $"WeaponPivot/BulletOut".get_global_position()
			bullet_instance.rotation = get_angle_to(get_global_mouse_position())
			$"..".add_child(bullet_instance)
			shoot_timer = get_tree().create_timer(rate_of_fire)
			yield(shoot_timer, "timeout")
			can_fire = true
	else:
		if shoot_timer:
			shoot_timer.set_time_left(0)
		is_shooting = false
