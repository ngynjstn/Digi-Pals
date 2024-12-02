extends Node2D

@onready var scream_player = $AudioStreamPlayer2D
@onready var black_screen = $ColorRect
@onready var animplayer = $AnimationPlayer
@onready var boss = $Sprite2D
@onready var girlfriend = $Girlfriend

var transitioning = false
var fade_duration = 1.5  # Time in seconds for the fade transition
var fade_elapsed_time = 0.0
var fade_in = false
var interaction_occurred = false  # Flag to track if interaction has occurred

func _ready():
	# Ensure the black screen starts invisible and fully transparent
	black_screen.visible = false
	black_screen.modulate = Color(0, 0, 0, 0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not interaction_occurred:
		interact_with_boss()

func interact_with_boss():
	# Set the flag to true to prevent further interactions
	interaction_occurred = true
	# Play the scream audio and start fade-out transition
	scream_player.play()
	start_transition()

func _process(delta: float) -> void:
	if transitioning:
		fade_elapsed_time += delta
		var fade_t = fade_elapsed_time / fade_duration
		if fade_in:
			# Fade back in
			black_screen.modulate.a = lerp(1.0, 0.0, fade_t)
			if fade_elapsed_time >= fade_duration:
				_on_fade_in_complete()
		else:
			# Fade to black
			black_screen.modulate.a = lerp(0.0, 1.0, fade_t)
			if fade_elapsed_time >= fade_duration:
				_on_fade_out_complete()

func start_transition():
	# Begin the fade-out process
	transitioning = true
	fade_elapsed_time = 0.0
	black_screen.visible = true
	fade_in = false  # First fade out

func _on_fade_out_complete():
	# Handle the completion of the fade-out process
	transitioning = false
	fade_elapsed_time = 0.0
	black_screen.modulate.a = 1.0  # Ensure the screen is fully black
	# Wait for a moment before starting the fade-in
	await get_tree().create_timer(1.0).timeout
	# Make the boss disappear
	boss.visible = false
	girlfriend.visible = false
	start_fade_in()

func start_fade_in():
	# Begin the fade-in process
	transitioning = true
	fade_elapsed_time = 0.0
	fade_in = true

func _on_fade_in_complete():
	# Handle the completion of the fade-in process
	transitioning = false
	fade_elapsed_time = 0.0
	black_screen.visible = false
	black_screen.modulate = Color(0, 0, 0, 0)  # Reset transparency
