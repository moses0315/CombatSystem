extends CharacterBody2D

const SPEED = 100
var player_chase = false
var player = null

@onready var anim = $AnimationPlayer

func _physics_process(delta):
	if player_chase:
		var direction = (player.position - position).normalized()
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		velocity.x = direction.x * SPEED
	move_and_slide()

func _on_player_detection_area_body_entered(body):
	player = body
	player_chase = true

