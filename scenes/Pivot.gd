extends Position2D

onready var player = $".."
onready var camera = $"./CameraOffset/Camera"

# Called when the node enters the scene tree for the first time.
func _ready():
	update_pivot_angle()
	
func _physics_process(delta):
	update_pivot_angle()

func update_pivot_angle():
	var look_direction = player.look_direction
	rotation = look_direction.angle()