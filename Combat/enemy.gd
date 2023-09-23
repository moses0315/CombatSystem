extends CharacterBody2D

const SPEED = 100
var player_chase = false
var player = null

var health = 20
var attack_power = 10
var is_hurt = false
var is_attacking = false

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D

@onready var healthbar = $Healthbar

@onready var attack_cooldown_timer = $AttackCooldownTimer

func _physics_process(delta):
	#Health Bar
	healthbar.value = health
		
	#Move
	if player_chase and not is_hurt and not is_attacking:
		var direction = (player.position - position).normalized()
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		velocity.x = direction.x * SPEED
		attack()
	elif is_attacking or is_hurt:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_player_detection_area_body_entered(body):
	player = body
	player_chase = true

func attack():
	if Input.is_action_just_pressed("attack"):#-> 캐릭터가 어택디텍트 에어리아 들어오면 
		is_attacking = true
		attack_cooldown_timer.start()
		if sprite.flip_h == true:
			anim.play("attack1")
		else:
			anim.play("attack1")
			
func take_damage(attack_power):
	health -= attack_power
	is_hurt = true
	if health <= 0:
		anim.play("death")
		await anim.animation_finished
		self.queue_free()
	else:
		anim.play("hit")


func _on_animation_player_animation_finished(anim_name = "hit"):
	is_hurt = false
	anim.play("idle")
	
func _on_attack_detection_area_body_entered(body):
	body.take_damage(attack_power)


func _on_attack_cooldown_timer_timeout():
	is_attacking = false
