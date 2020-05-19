extends Position2D

onready var player = $".."
onready var previous_velocity = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_pivot_angle()
	
func _physics_process(delta):
	update_pivot_angle()

func update_pivot_angle():
	var look_direction = player.look_direction
	if player.velocity.y > 0:
		print("falling")
		look_direction.y = 1.6
	elif player.velocity.y < 0:
		print("climbing")
		look_direction.y = -0.6
	else:
		print("same")
		look_direction.y = -0.2
	rotation = look_direction.angle()
	
	previous_velocity = player.velocity.y
