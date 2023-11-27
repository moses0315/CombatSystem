extends Node2D

@export var character_name1 : String
@export var character_name2 : String
@export var character_name3 : String

@onready var doorarray = [$Door1/Area2D/CollisionShape2D,$Door2/Area2D/CollisionShape2D,$Door3/Area2D/CollisionShape2D]

@onready var create_position1 = self.position+$Door1.position
@onready var create_position2= self.position+$Door2.position
@onready var create_position3 = self.position+$Door3.position

var doors_open = false
var doors_once_open = false
var door_num
var num = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not doors_once_open:
		for door in doorarray:
			if door.is_open:
				door_num = num
				doors_open = true
				door.is_open = false
				doors_once_open = true
				$Door1.queue_free()
				$Door2.queue_free()
				$Door3.queue_free()
			num += 1
		num = 1
	
