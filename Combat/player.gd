extends CharacterBody2D

const MOVE_SPEED = 300
const BACKSTEP_SPEED = 300

var is_backsteping = false
var is_backstep_cooldown = false

var is_attacking = false
var is_hurt = false

var health = 100
var attack_power = 10

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D

@onready var backstep_timer = $BackstepTimer
@onready var backstep_cooldown_timer = $BackstepCooldownTimer
@onready var attack_cooldown_timer = $AttackCooldownTimer

@onready var healthbar = $Healthbar

func _ready():
	$AttackArea/CollisionShape2D.disabled = true
	
func _physics_process(delta):
	#Health Bar
	healthbar.value = health
	
	#Player Move
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		sprite.flip_h = true
	elif direction == 1:
		sprite.flip_h = false	

	if not is_backsteping and not is_attacking and not is_hurt:
		if direction:
			velocity.x = direction * MOVE_SPEED
			anim.play("run")
		#Back Step
		elif Input.is_action_pressed("ui_down") and not is_backstep_cooldown:
			is_backstep_cooldown = true
			is_backsteping = true
			backstep_cooldown_timer.start()
			backstep_timer.start()
			anim.play("idle")
			if sprite.flip_h == true:
				velocity.x = BACKSTEP_SPEED
			elif sprite.flip_h == false:
				velocity.x = -BACKSTEP_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
			anim.play("idle")
		attack()	
	elif is_attacking or is_hurt:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
		
	move_and_slide()
	
func attack():
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		attack_cooldown_timer.start()
		if sprite.flip_h == true:
			anim.play("attack1")
		else:
			anim.play("attack2")

func take_damage(attack_power):
	health -= attack_power
	is_hurt = true
	if health <= 0:
		anim.play("death")
		await anim.animation_finished
	else:
		anim.play("hit")
		
		
func _on_backstep_cooldown_timer_timeout():
	is_backstep_cooldown = false
				
func _on_backstep_timer_timeout():
	is_backsteping = false

func _on_attack_cooldown_timer_timeout():
	is_attacking = false

func _on_attack_area_body_entered(body):
	body.take_damage(attack_power)

func _on_animation_player_animation_finished(anim_name = "hit"):
	is_hurt = false
	anim.play("idle")
