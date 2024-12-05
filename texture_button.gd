@tool
extends TextureButton

@export var text: String = "Text" # text to be displayed in the button

func _ready():
	setup_text()
	
	# This function is needed to grab the focus from the keyboard
	focus_mode = Control.FOCUS_ALL

func _process(delta: float) -> void:
	if has_focus():
			SignalManager.btn_pos.emit(global_position.x - 4, global_position.y + 6)

func setup_text() -> void:
	# Ensure the Label node exists and is properly referenced
	if $Label:
		$Label.text = text
	else:
		print("Label node not found!")

func show_text() -> String:
	if $Label:
		return $Label.text
	else:
		return "Label node not found!"
