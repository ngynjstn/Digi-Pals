extends Control

func _process(delta):
	if Input.is_action_pressed("start"):
		load_game()

func load_game():
	get_tree().change_scene_to_file("res://start2.tscn")
