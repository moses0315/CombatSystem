extends CharacterBody2D

var bullet = preload("res://Combat/sodierBullet.tscn")

var friend = false
var SPEED = 70
var enemy_array = []

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var max_health = 100
var health = max_health
var self_attack_power = 10
var is_hurt = false
var is_dead = false

var is_attacking = false
var attack_ready = false
var once_attack = false
var attack_target_array = []
var attack_stat = 0
var fixed_target = null

var healthbar

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var attack_cooldown_timer = $AttackCooldownTimer

@export var create_bullet = false

@export var facing_left_position : Vector2
@export var facing_right_position : Vector2

func _ready():
	if friend:
		set_collision_layer_value(2, true)
		$EnemyDetectionArea.set_collision_mask_value(3, true)
		$AttackDetectionArea.set_collision_mask_value(3, true)
		$AttackArea.set_collision_mask_value(3, true)
		healthbar = $FriendHealthbar
		$EnemyHealthbar.queue_free()
	else:
		set_collision_layer_value(3, true)
		$EnemyDetectionArea.set_collision_mask_value(2, true)
		$AttackDetectionArea.set_collision_mask_value(2, true)
		$AttackArea.set_collision_mask_value(2, true)
		healthbar = $EnemyHealthbar
		$FriendHealthbar.queue_free()
	healthbar.max_value = max_health
	$AttackArea/CollisionShape2D.disabled = true
	
func _physics_process(delta):
	if $AnimatedSprite2D.flip_h == true:
		$AttackArea/CollisionShape2D.position = facing_left_position
	else:
		$AttackArea/CollisionShape2D.position = facing_right_position
		
	#Health Bar
	healthbar.value = health
	
	if create_bullet:
		var bullet_instance =  bullet.instantiate()
		if $AnimatedSprite2D.flip_h == true:#facing left
			bullet_instance.to_right = false
			if attack_stat%2 != 0:
				bullet_instance.position = Vector2(-22.308, 1.538)
			else:
				bullet_instance.position = Vector2(-33.077, -18.462)
		else:
			bullet_instance.to_right = true
			if attack_stat%2 == 1:#changed
				bullet_instance.position = Vector2(22.308, 1.538)
			else:
				bullet_instance.position = Vector2(33.077, -18.462)
		if friend:
			bullet_instance.friend = true
		else:
			bullet_instance.friend = false
		add_child(bullet_instance)	
		create_bullet = false
		
	#Move
	if not is_on_floor():
		velocity.y += gravity
		move_and_slide()
		return
	
	if attack_target_array != []:
		var minimum = 100000000
		for enemy in attack_target_array:
			if enemy.position.x-position.x >= 0:
				if enemy.position.x-position.x < minimum:
					minimum = enemy.position.x-position.x
					fixed_target = enemy
			elif enemy.position.x-position.x <= 0:
				if (enemy.position.x-position.x)*-1 < minimum:
					minimum = (enemy.position.x-position.x)*-1
					fixed_target = enemy
					
	if !is_hurt and !is_attacking:
		if enemy_array == []:
			velocity.x = move_toward(velocity.x, 0, SPEED)#change code to chase player
			anim.play("idle")
		elif fixed_target != null:
			var direction = (fixed_target.position-position).normalized()
			if direction.x > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true	
			velocity.x = move_toward(velocity.x, 0, SPEED)
			attack()
			
		else:
			var minimum = 100000000
			var direction
			for enemy in enemy_array:
				if enemy.position.x-position.x >= 0:
					if enemy.position.x-position.x < minimum:
						minimum = enemy.position.x-position.x
						direction = (enemy.position-position).normalized()
				elif enemy.position.x-position.x <= 0:
					if (enemy.position.x-position.x)*-1 < minimum:
						minimum = (enemy.position.x-position.x)*-1
						direction = (enemy.position-position).normalized()
			if direction.x > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			if attack_ready:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			else:
				velocity.x = direction.x * SPEED
				anim.play("run")

	elif is_hurt or is_attacking or attack_ready:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()



func attack():
	if attack_ready and !is_attacking:
		is_attacking = true
		attack_cooldown_timer.start()
		if attack_stat%2 == 0:
			anim.play("attack1")
		else:
			anim.play("attack2")
		attack_stat += 1


func take_damage(attack_power):
	$AttackArea/CollisionShape2D.disabled = true
	health -= attack_power
	is_hurt = true
	if health <= 0:
		anim.play("death")
		is_dead = true
		await anim.animation_finished
		self.queue_free()
	else:
		anim.play("hit")


func _on_enemy_detection_area_body_entered(body):
	enemy_array.append(body)
	
func _on_enemy_detection_area_body_exited(body):
	enemy_array.erase(body)
	
func _on_animation_soldier_animation_finished(anim_name = "hit"):
	is_hurt = false
	anim.play("idle")
	
func _on_attack_detection_area_body_entered(body):
	attack_ready = true
	attack_target_array.append(body)

func _on_attack_detection_area_body_exited(body):
	if body == fixed_target:
		fixed_target = null
	attack_target_array.erase(body)
	if attack_target_array == []:
		attack_ready = false
	

func _on_attack_cooldown_timer_timeout():
	is_attacking = false
	once_attack = false

func _on_attack_area_body_entered(body):
	if not once_attack and fixed_target != null:
		fixed_target.take_damage(self_attack_power)
		once_attack = true
