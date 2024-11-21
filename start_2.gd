extends Control

@onready var dialogue_label = $Dialouge/Label  # Reference to the Label node

var dialogues = [
	"Hello there! Welcome to the world of Digi-Pals!",
	"My name is Joe! People call me the Digi-Pals Prof!",
	"This world is inhabited by creatures called Digi-Pals!",
	"For some people, Digi-Pals are pets. Others use them for battles.",
	"As for myself... I study Digi-Pals as a profession."
]

var current_dialogue_index = 0

func _ready():
	# Ensure the dialogue_label is properly referenced
	if dialogue_label:
		# Set the text color to black
		dialogue_label.add_theme_color_override("font_color", Color(0, 0, 0))
		show_next_dialogue()
	else:
		print("Error: dialogue_label not found")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		show_next_dialogue()

func show_next_dialogue():
	if dialogue_label:
		if current_dialogue_index < dialogues.size():
			dialogue_label.text = dialogues[current_dialogue_index]
			current_dialogue_index += 1
		else:
			# Transition to the next scene or end the dialogue
			get_tree().change_scene_to_file("res://introscene.tscn")
	else:
		print("Error: dialogue_label not found")
