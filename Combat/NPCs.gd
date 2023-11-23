extends Node
var enemy = preload("res://Combat/enemy.tscn")

@onready var threeDoors_array = [$ThreeDoors,$ThreeDoors2,$ThreeDoors3]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for door in threeDoors_array:
		if door.doors_open:
			var enemy_instance = enemy.instantiate()
			enemy_instance.friend = true
			enemy_instance.position = Vector2(door.create_position)
			$Enemies.add_child(enemy_instance)
			door.doors_open = false
		
