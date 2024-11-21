extends Node2D

@onready var player = $Sprite2D  # Reference to the Player node
@onready var fade_rect = $CanvasLayer/ColorRect  # Reference to the ColorRect

var start_position = Vector2(-720, 0)
var end_position = Vector2(224, 0)
var duration = 10.0  # Time in seconds to complete the movement
var elapsed_time = 0.0
var transitioning = false
var fade_duration = 1.5  # Time in seconds for the fade transition
var fade_elapsed_time = 0.0

func _ready():
	# Set the player's initial position
	player.position = start_position
	# Ensure the fade_rect is fully transparent initially
	fade_rect.visible = true
	fade_rect.modulate = Color(0, 0, 0, 0)  # Black color with 0 alpha (transparent)

func _process(delta):
	if elapsed_time < duration:
		elapsed_time += delta
		var t = elapsed_time / duration
		player.position = start_position.lerp(end_position, t)
	else:
		player.position = end_position
		if not transitioning:
			start_transition()
	
	if transitioning:
		fade_elapsed_time += delta
		var fade_t = fade_elapsed_time / fade_duration
		fade_alpha = lerp(0, 1, fade_t)
		if fade_elapsed_time >= fade_duration:
			_on_fade_complete()

func start_transition():
	# Trigger the fade-to-black transition
	transitioning = true
	fade_elapsed_time = 0.0

func _on_fade_complete():
	# Load the next scene after the fade-out is complete
	get_tree().change_scene_to_file("res://forest2.tscn")

# Property to tween the fade alpha
var fade_alpha: float:
	get:
		return fade_rect.modulate.a
	set(value):
		var color = fade_rect.modulate
		color.a = value
		fade_rect.modulate = color
