extends Node2D

@onready var scream_player = $AudioStreamPlayer2D
@onready var black_screen = $ColorRect
@onready var animplayer = $AnimationPlayer
@onready var boss = $Sprite2D
@onready var girlfriend = $Girlfriend
@onready var dialogue_label = $Dialouge/Label2  # Reference to the Label node for dialogue
@onready var dialogue = $Dialouge

var transitioning = false
var fade_duration = 1.5  # Time in seconds for the fade transition
var fade_elapsed_time = 0.0
var fade_in = false
var interaction_occurred = false  # Flag to track if interaction has occurred

var dialogues = [
	"Where did she go?",
	"Where did she go? I need to find her."
]
var current_dialogue_index = 0

func _ready():
	# Ensure the black screen starts invisible and fully transparent
	black_screen.visible = false
	black_screen.modulate = Color(0, 0, 0, 0)
	dialogue_label.visible = false  # Hide dialogue initially
	dialogue.visible = false

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
	start_inner_dialogue()

func start_inner_dialogue():
	dialogue.visible = true
	dialogue_label.visible = true
	show_next_dialogue()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		show_next_dialogue()
		
func show_next_dialogue():
	if current_dialogue_index < dialogues.size():
		dialogue_label.text = dialogues[current_dialogue_index]
		current_dialogue_index += 1
	else:
		dialogue_label.visible = false  # Hide dialogue after all lines are shown
		dialogue.visible = false
