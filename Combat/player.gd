extends CharacterBody2D

const MOVE_SPEED = 200

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_attacking = false
var is_hurt = false
var is_dead = false

var max_health = 1000
var health = max_health
var player_attack_power = 10

var attack_stat = 0

@export var facing_left_position : Vector2
@export var facing_right_position : Vector2

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var attack_cooldown_timer = $AttackCooldownTimer
@onready var healthbar = $Healthbar

func _ready():
	$AttackArea/CollisionShape2D.disabled = true
	healthbar.max_value = max_health
	
func _physics_process(delta):
	if $AnimatedSprite2D.flip_h == true:
		$AttackArea/CollisionShape2D.position = facing_left_position
	else:
		$AttackArea/CollisionShape2D.position = facing_right_position
		
	healthbar.value = health
	
	if is_dead:
		return
		
	#Player Move
	
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("left", "right")
	if !is_attacking:
		if direction == -1:
			sprite.flip_h = true
		elif direction == 1:
			sprite.flip_h = false	
		
	if is_attacking or is_hurt:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
	elif direction:
		velocity.x = direction * MOVE_SPEED
		anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
		anim.play("idle")
	
	if !is_attacking:
		attack()	
		
	move_and_slide()
	
func attack():
	if Input.is_action_pressed("attack"):
		is_attacking = true
		attack_cooldown_timer.start()
		if attack_stat%2 == 0:
			anim.play("attack1")
		else:
			anim.play("attack2")
		attack_stat += 1

func take_damage(attack_power):
	if !is_dead:
		health -= attack_power
		is_hurt = true
		if health <= 0:
			is_dead = true
			anim.play("death")
			await anim.animation_finished
		else:
			anim.play("hit")

func _on_attack_cooldown_timer_timeout():
	is_attacking = false

func _on_attack_area_body_entered(body):
	body.take_damage(player_attack_power)

func _on_animation_player_animation_finished(anim_name = "hit"):
	if not is_dead:
		is_hurt = false
		anim.play("idle")




