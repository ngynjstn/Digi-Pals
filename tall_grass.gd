extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var player = $Player  # Reference to the player node
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
	if player_inside:
		if not was_player_inside:
			print("Player is in the grass.")  # Debug print for player inside grass
			was_player_inside = true

		# Check if grass_step_effect is already instantiated
		if grass_step_effect == null:
			# Create and instantiate the grass step effect only once
			grass_step_effect = GrassStepEffect.instantiate()

		# Check if it already has a parent, and remove it if necessary
		if grass_step_effect.get_parent():
			grass_step_effect.get_parent().remove_child(grass_step_effect)
			print("Removed GrassStepEffect from its previous parent.")

		# Add the grass step effect to the correct parent
		get_parent().add_child(grass_step_effect)
		print("Grass step effect added to the scene.")

		if player:
			grass_step_effect.position = player.global_position

		# Create and add the grass overlay texture
		if grass_overlay == null:
			grass_overlay = TextureRect.new()
			grass_overlay.texture = grass_overlay_texture
			grass_overlay.rect_min_size = Vector2(64, 64)  # Set the size of the texture rect
			if player:
				grass_overlay.rect_global_position = player.global_position  # Set position relative to the player
			get_tree().current_scene.add_child(grass_overlay)
		else:
			if player:
				grass_overlay.rect_global_position = player.global_position  # Update the position if already exists

	else:
		if was_player_inside:
			print("Player is not inside the grass.")  # Debug print when player is not inside grass
			was_player_inside = false

func player_exiting_grass():
	player_inside = false
	if was_player_inside:
		print("Player is not in the grass.")  # Debug print for player exiting grass
		was_player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()
		print("Grass overlay removed.")  # Debug print for removing the grass overlay

	# Reset the stopped flag when the player exits the grass
	player_stopped = false  # Reset stopped flag

func _on_area_2d_body_entered(body: Node2D):
	if body.name == "Player":
		player_inside = true
		print("Player entered the grass area.")  # Debug print for entering the grass area
		anim_player.play("stepped")

# Method to handle when the player stops
func player_stopped_signal():
	player_stopped = true  # Set the stopped flag to true when the player stops
	print("Player has stopped signal received.")

func _process(delta):
	# Update the position of the grass overlay to follow the player
	if grass_overlay and player:
		grass_overlay.rect_global_position = player.global_position

	# Continuously check if the player is inside the grass
	if player_inside:
		player_in_grass()
	else:
		player_exiting_grass()
