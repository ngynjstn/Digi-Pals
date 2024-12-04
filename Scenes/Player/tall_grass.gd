extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var player = get_tree().current_scene.get_node("Player")
const grass_overlay_texture = preload("res://Assets/Grass/stepped_tall_grass.png")
const GrassStepEffect = preload("grass_step_effect.tscn")
var grass_overlay: TextureRect = null

var player_inside: bool = false
var player_stopped: bool = false  # Flag to track if player has stopped
var was_player_inside: bool = false  # Flag to track the previous state

# Called when the node enters the scene tree for the first time.
func _ready():
	if player:
		# Correctly connect the player signals to methods in this script
		player.connect("player_moving_signal", Callable(self, "player_in_grass"))
		player.connect("player_stopped_signal", Callable(self, "player_exiting_grass"))
	else:
		print("Player node not found!")

# This method is called when a body enters the Area2D.
var grass_step_effect: Node = null  # Declare outside so it's not instantiated every time

func player_in_grass():
	if player_inside == true:
		if not grass_step_effect:
			grass_step_effect = GrassStepEffect.instantiate()
			get_tree().current_scene.add_child(grass_step_effect)
		grass_step_effect.position = position
		grass_step_effect.visible = true

		if not grass_overlay:
			grass_overlay = TextureRect.new()
			grass_overlay.texture = grass_overlay_texture
			get_tree().current_scene.add_child(grass_overlay)
		grass_overlay.position = position


func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()
		
func _on_area_2d_body_entered(body: Node2D):

	player_inside = true

	anim_player.play("stepped")

	if body.name == "Player":
		player_inside = true
		
		anim_player.play("stepped")

# Method to handle when the player stops
func player_stopped_signal():
	player_stopped = true  # Set the stopped flag to true when the player stops
