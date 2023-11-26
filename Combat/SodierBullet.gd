extends Sprite2D

var to_right = false
var friend = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if friend:
		$Area2D.set_collision_mask_value(3, true)
	else:
		$Area2D.set_collision_mask_value(2, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if to_right:
		position.x += 1000*delta
	else:
		position.x -= 1000*delta
