extends Control

@onready var dialogue_label = $Dialouge/Label  # Reference to the Label node

var dialogues = [
	"Congrats on defeating the GOLDEN BIDOOF!",
	"Thank you for ending his tyranny in the town.",
	"We had lost many lives to that monster.",
	"But with you and your Digi-Pal you have saved us",
	"P.S. I am your father",
	"And maybe Digi-Pals was the friends we made along the way..."
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
			get_tree().quit()
	else:
		print("Error: dialogue_label not found")
