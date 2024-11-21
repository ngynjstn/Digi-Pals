extends Node2D

@onready var anim_player = $AnimationPlayer
const grass_overlay_texture = preload("res://Assets/Grass/stepped_tall_grass.png")
const GrassStepEffect = preload("grass_step_effect.tscn")
var grass_overlay: TextureRect = null

var player_inside: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Replace this path with the actual path to your player node
	var player = get_tree().current_scene.get_node("Player")
	
	if player:
		# Correctly connect the player signals to methods in this script
		player.connect("player_moving_signal", Callable(self, "_on_player_moving"))
		player.connect("player_stopped_signal", Callable(self, "_on_player_stopped"))
	else:
		print("Player node not found!")

# This method is called when a body enters the Area2D.

func player_in_grass():
	if player_inside == true:
		var grass_step_effect = GrassStepEffect.instantiate()
		if grass_step_effect != null:
			print("Grass step effect instantiated successfully.")
			get_tree().current_scene.add_child(grass_step_effect)
			print("Grass step effect added to the scene.")
		else:
			print("Failed to instantiate GrassStepEffect.")
		print("Grass step effect instance created:", grass_step_effect)

		grass_step_effect.position = position
		get_tree().current_scene.add_child(grass_step_effect)
		
		
		grass_overlay = TextureRect.new()
		grass_overlay.texture = grass_overlay_texture
		grass_overlay.rect_position = position
		get_tree().current_scene.add_child(grass_overlay)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
		player_inside = true
		anim_player.play("Stepped")
		
func player_exiting_grass():
	print("Player exited the grass area.")
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()
