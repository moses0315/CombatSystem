extends CollisionShape2D

var is_enter = false
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_enter:
		if Input.is_action_just_pressed("door_open"):
			is_open = true



func _on_area_2d_area_entered(area):
	is_enter = true
	


func _on_area_2d_area_exited(area):
	is_enter = false
