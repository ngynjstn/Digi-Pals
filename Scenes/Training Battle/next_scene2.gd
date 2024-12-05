extends Node2D

@onready var fade_rect = $CanvasLayer/ColorRect  # Reference to the ColorRect

var has_player_entered_area = false
var player = null
var transitioning = false
var fade_duration = 1.5  # Time in seconds for the fade transition
var fade_elapsed_time = 0.0

func _ready():
	# Ensure the fade_rect is fully transparent initially
	fade_rect.visible = true
	fade_rect.modulate = Color(0, 0, 0, 0)  # Black color with 0 alpha (transparent)

func _process(delta):
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

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		if not has_player_entered_area:
			has_player_entered_area = true
			print("Player detected in scene: Starting fade transition")
			start_transition()
			
func cutscenetraining():
	print("Changing scene to Gfinalvalets.tscn")
	get_tree().change_scene_to_file("res://finalvalley.tscn")
	
func _on_fade_complete():
	cutscenetraining()

# Property to tween the fade alpha
var fade_alpha: float:
	get:
		return fade_rect.modulate.a
	set(value):
		var color = fade_rect.modulate
		color.a = value
		fade_rect.modulate = color
