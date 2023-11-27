extends Node
var knight = preload("res://Combat/knight.tscn")
var soldier = preload("res://Combat/soldier.tscn")

@onready var threeDoors_array = [$ThreeDoors,$ThreeDoors2,$ThreeDoors3]

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if 	not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
		
	for doors in threeDoors_array:
		if doors.doors_open:	
			var instance1 = knight.instantiate()
			var instance2 = knight.instantiate()
			var instance3 = knight.instantiate()
			match doors.character_name1:
				"knight":
					instance1 = knight.instantiate()
				"soldier":
					instance1 = soldier.instantiate()
			match doors.character_name2:
				"knight":
					instance2 = knight.instantiate()
				"soldier":
					instance2 = soldier.instantiate()
			match doors.character_name3:
				"knight":
					instance3 = knight.instantiate()
				"soldier":
					instance3 = soldier.instantiate()
			
			instance1.position = Vector2(doors.create_position1)
			instance2.position = Vector2(doors.create_position2)
			instance3.position = Vector2(doors.create_position3)
			
			if doors.door_num == 1:
				instance1.friend = true
			elif doors.door_num == 2:
				instance2.friend = true
			elif doors.door_num == 3:
				instance3.friend = true	

			$NPC.add_child(instance1)	
			$NPC.add_child(instance2)
			$NPC.add_child(instance3)	
		
			doors.doors_open = false
		
