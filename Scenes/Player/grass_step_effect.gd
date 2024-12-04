extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial frame
	frame = 0
	# Start the animation playback
	play("new")  # Replace "your_animation_name" with your actual animation name

# Called when an animation finishes.
func _on_animation_finished():
	# Free the node once the animation finishes
	queue_free()
