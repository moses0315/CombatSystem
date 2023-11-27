extends CharacterBody2D

var bullet = preload("res://Combat/sodierBullet.tscn")

var friend = false
var SPEED = 70
var enemy_array = []

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var health = 100
var self_attack_power = 10
var is_hurt = false
var is_dead = false
var is_attacking = false
var attack_ready = false
var once_attack = false
var attack_target_array = []
var fixed_target = null
var target = null

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var healthbar = $Healthbar
@onready var attack_cooldown_timer = $AttackCooldownTimer

@export var facing_left_position : Vector2
@export var facing_right_position : Vector2

func _ready():
	if friend:
		set_collision_layer_value(2, true)
		$EnemyDetectionArea.set_collision_mask_value(3, true)
		$AttackDetectionArea.set_collision_mask_value(3, true)
		$AttackArea.set_collision_mask_value(3, true)
	else:
		set_collision_layer_value(3, true)
		$EnemyDetectionArea.set_collision_mask_value(2, true)
		$AttackDetectionArea.set_collision_mask_value(2, true)
		$AttackArea.set_collision_mask_value(2, true)
		
	$AttackArea/CollisionShape2D.disabled = true
	
func _physics_process(delta):
	if $AnimatedSprite2D.flip_h == true:
		$AttackArea/CollisionShape2D.position = facing_left_position
	else:
		$AttackArea/CollisionShape2D.position = facing_right_position
		
	#Health Bar
	healthbar.value = health
		
	#Move
	if not is_on_floor():
		velocity.y += gravity
		move_and_slide()
		return
	
	if fixed_target == null and attack_target_array != []:
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
	if attack_ready:
		is_attacking = true
		attack_cooldown_timer.start()
		anim.play("attack")

		var bullet_instance =  bullet.instantiate()
		if $AnimatedSprite2D.flip_h == true:#facing left
			bullet_instance.to_right = false
			bullet_instance.position = Vector2(-39, -18)
		else:
			bullet_instance.to_right = true
			bullet_instance.position = Vector2(39, -18)
		if friend:
			bullet_instance.friend = true
		else:
			bullet_instance.friend = false
		add_child(bullet_instance)	

			
func take_damage(attack_power):
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
	if not once_attack:
		once_attack = true
		var minimum = 100000000
		if enemy_array != []:
			for enemy in attack_target_array:
				if $AnimatedSprite2D.flip_h == false:#facing right
					if enemy.position.x-position.x < minimum:
						minimum = enemy.position.x-position.x
						target = enemy
				else:
					if (enemy.position.x-position.x)*-1 < minimum:
						minimum = (enemy.position.x-position.x)*-1
						target = enemy
			target.take_damage(self_attack_power)