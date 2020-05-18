extends Position2D

enum {LEFT, RIGHT}

var state

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var m = get_global_mouse_position()
	look_at(m)
	check_weapon_orientation()
	
func check_weapon_orientation():
	var rotation_degree = abs(fmod(rotation_degrees, 360))
	if rotation_degree < 90 or rotation_degree > 270:
		if state != RIGHT:
			$"PositionWeapon/Weapon".flip_v = false
			state = RIGHT
	elif rotation_degree > 90 or rotation_degree < 270:
		if state != LEFT:
			$"PositionWeapon/Weapon".flip_v = true
			state = LEFT