extends RigidBody2D

var projectile_speed = 1500
var life_time = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bullet")
	set_bounce(0.1)
	set_friction(0.9)
	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	self_destruct()
	
func self_destruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_Bullet_body_entered(body):
	self.hide()
