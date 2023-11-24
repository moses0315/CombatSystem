extends Node
var enemy = preload("res://Combat/enemy.tscn")

@onready var threeDoors_array = [$ThreeDoors,$ThreeDoors2,$ThreeDoors3]

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	for doors in threeDoors_array:
		if doors.doors_open:
			var enemy_instance1 = enemy.instantiate()
			var enemy_instance2 = enemy.instantiate()		
			var enemy_instance3 = enemy.instantiate()
			enemy_instance1.position = Vector2(doors.create_position1)
			enemy_instance2.position = Vector2(doors.create_position2)
			enemy_instance3.position = Vector2(doors.create_position3)
			
			if doors.door_num == 1:
				enemy_instance1.friend = true
			elif doors.door_num == 2:
				enemy_instance2.friend = true
			elif doors.door_num == 3:
				enemy_instance3.friend = true	

			$Enemies.add_child(enemy_instance1)	
			$Enemies.add_child(enemy_instance2)
			$Enemies.add_child(enemy_instance3)	
		
			doors.doors_open = false
		
