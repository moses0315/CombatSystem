extends Node2D

@onready var door1 = $Door1/Area2D/CollisionShape2D
@onready var door2 = $Door2/Area2D/CollisionShape2D
@onready var door3 = $Door3/Area2D/CollisionShape2D
var create_position
var doors_open = false
var doors_once_open = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not doors_once_open:
		if door1.is_open:
			create_position = self.position+$Door1.position
			doors_open = true
			door1.is_open = false
			doors_once_open = true
			$Door1.queue_free()
			$Door2.queue_free()
			$Door3.queue_free()
		elif door2.is_open:
			create_position = self.position+$Door2.position
			doors_open = true
			door2.is_open = false
			doors_once_open = true
			$Door1.queue_free()
			$Door2.queue_free()
			$Door3.queue_free()
		elif door3.is_open:
			create_position =self.position+ $Door3.position
			doors_open = true
			door3.is_open = false
			doors_once_open = true
			$Door1.queue_free()
			$Door2.queue_free()
			$Door3.queue_free()
	
