extends CollisionShape2D


@export var facing_left_position : Vector2
@export var facing_right_position : Vector2

func _process(delta):
	#Flip attack area
	if $"../../AnimatedSprite2D".flip_h == true:
		position = facing_left_position
	else:
		position = facing_right_position
