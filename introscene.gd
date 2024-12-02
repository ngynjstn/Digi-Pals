extends Node2D

@onready var player = $Sprite2D  # Reference to the Player node
@onready var girlfriend = $Sprite2D2  # Reference to the Girlfriend node
@onready var fade_rect = $CanvasLayer/ColorRect  # Reference to the ColorRect
@onready var conversation_timer = $ConversationTimer  # Reference to the Timer node
@onready var player_anim = $Sprite2D/AnimationPlayer  # Reference to the Player's AnimationPlayer
@onready var girlfriend_anim = $Sprite2D2/AnimationPlayer  # Reference to the Girlfriend's AnimationPlayer

var player_start_position = Vector2(-720, 0)
var player_end_position = Vector2(224, 0)
var girlfriend_start_position = Vector2(-704, -48)  # Adjust as needed
var girlfriend_end_position = Vector2(224, -48)  # Adjust as needed
var duration = 10.0  # Time in seconds to complete the movement
var elapsed_time = 0.0
var transitioning = false
var fade_duration = 1.5  # Time in seconds for the fade transition
var fade_elapsed_time = 0.0
var conversation_duration = 5.0  # Time in seconds for the conversation

func _ready():
	$AudioStreamPlayer2D.play()
	# Ensure the Timer node is not null
	if conversation_timer == null:
		print("Error: ConversationTimer node is not found.")
		return
	
	# Set the initial positions
	player.position = player_start_position
	girlfriend.position = girlfriend_start_position
	# Ensure the fade_rect is fully transparent initially
	fade_rect.visible = true
	fade_rect.modulate = Color(0, 0, 0, 0)  # Black color with 0 alpha (transparent)
	# Start the conversation timer
	conversation_timer.start(conversation_duration)

func _process(delta):
	if conversation_timer != null and conversation_timer.time_left == 0:
		if elapsed_time < duration:
			elapsed_time += delta
			var t = elapsed_time / duration
			player.position = player_start_position.lerp(player_end_position, t)
			girlfriend.position = girlfriend_start_position.lerp(girlfriend_end_position, t)
			# Play walking animations
			if not player_anim.is_playing():
				player_anim.play("movingmain")
			if not girlfriend_anim.is_playing():
				girlfriend_anim.play("moving")
		else:
			player.position = player_end_position
			girlfriend.position = girlfriend_end_position
			# Stop walking animations
			player_anim.stop()
			girlfriend_anim.stop()
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
