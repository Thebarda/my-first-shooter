extends Node2D

signal rotate_player

enum {LEFT, RIGHT}

var state

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var m = get_global_mouse_position()
	look_at(m)
	check_arm_orientation()
	
func check_arm_orientation():
	var rotation_degree = abs(fmod(rotation_degrees, 360))
	if rotation_degree < 90 or rotation_degree > 270:
		if state != RIGHT:
			emit_signal("rotate_player", "right")
			state = RIGHT
	elif rotation_degree > 90 or rotation_degree < 270:
		if state != LEFT:
			emit_signal("rotate_player", "left")
			state = LEFT