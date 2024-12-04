extends Control

@onready var dialogue_label = $Dialouge/Label  # Reference to the Label node

var dialogues = [
	"Greetings! I am Joe, the renowned Digi-Pal Professor!",
	"In this vast world, amazing creatures known as Digi-Pals roam freely.",
	"For some, Digi-Pals are cherished companions. 
	 For others, they become powerful allies in battles.",
	"As for me... I dedicate my life to studying these extraordinary beings, 
	 unlocking the mysteries of their world.",
	"Anyways! Welcome to an incredible journey, where adventure and 
	 mystery await!",
	"It seems you and your beloved are venturing deep 
	 into the heart of an ancient forest, seeking wild Digi-Pals.",
	"What secrets will unfold?"
]

var current_dialogue_index = 0

func _ready():
	$Music.play()
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
