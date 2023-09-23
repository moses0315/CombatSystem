extends CharacterBody2D


const MOVE_SPEED = 300
const BACKSTEP_SPEED = 300

var is_backsteping = false
var is_backstep_cooldown = false
@onready var anim = $AnimationPlayer
@onready var backstep_timer = $BackstepTimer
@onready var backstep_cooldown_timer = $BackstepCooldownTimer

func _physics_process(delta):
	#Player Move
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false	
	if not is_backsteping:
		if direction:
			velocity.x = direction * MOVE_SPEED
			anim.play("run")
		elif Input.is_action_pressed("ui_down") and not is_backstep_cooldown:#Back step
			is_backstep_cooldown = true
			is_backsteping = true
			backstep_cooldown_timer.start()
			backstep_timer.start()
			anim.play("idle")
			if $AnimatedSprite2D.flip_h == true:
				velocity.x = BACKSTEP_SPEED
			elif $AnimatedSprite2D.flip_h == false:
				velocity.x = -BACKSTEP_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
			anim.play("idle")
			
	move_and_slide()

func _on_backstep_cooldown_timer_timeout():
	is_backstep_cooldown = false
				
func _on_backstep_timer_timeout():
	is_backsteping = false

