extends Position2D

onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	update_pivot_angle()
	
func _physics_process(delta):
	update_pivot_angle()

func update_pivot_angle():
	rotation = player.look_direction.angle()
