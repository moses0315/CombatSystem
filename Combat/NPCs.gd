extends Node
var knight = preload("res://Combat/knight.tscn")

@onready var threeDoors_array = [$ThreeDoors,$ThreeDoors2,$ThreeDoors3]

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if 	not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	for doors in threeDoors_array:
		if doors.doors_open:
			var knight_instance1 = knight.instantiate()
			var knight_instance2 = knight.instantiate()		
			var knight_instance3 = knight.instantiate()
			knight_instance1.position = Vector2(doors.create_position1)
			knight_instance2.position = Vector2(doors.create_position2)
			knight_instance3.position = Vector2(doors.create_position3)
			
			if doors.door_num == 1:
				knight_instance1.friend = true
			elif doors.door_num == 2:
				knight_instance2.friend = true
			elif doors.door_num == 3:
				knight_instance3.friend = true	

			$NPC.add_child(knight_instance1)	
			$NPC.add_child(knight_instance2)
			$NPC.add_child(knight_instance3)	
		
			doors.doors_open = false
		
