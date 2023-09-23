extends Node2D

func _on_combat_pressed():
	get_tree().change_scene_to_file("res://Combat/combat.tscn")


func _on_quit_pressed():
	get_tree().quit()
