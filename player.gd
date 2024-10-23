extends CharacterBody2D

signal player_moving_signal
signal player_stopped_signal
signal player_entering_door_signal
signal player_entered_door_signal

@export var walk_speed = 100.0
@export var jump_speed = 4.0
const TILE_SIZE = 16
const TURN_DURATION = 0.5  # Duration for the turn animation

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var initial_position = Vector2(0, 0)
var input_direction = Vector2.ZERO
var is_moving = false
var stop_input: bool = false
var percent_moved_to_next_tile = 0.0
var turn_time = 0.0  # Track time spent turning

func _ready():
	anim_tree.active = true
	initial_position = position

func _physics_process(delta):
	if stop_input:
		return
	
	if player_state == PlayerState.TURNING:
		turn_time += delta
		if turn_time >= TURN_DURATION:
			finished_turning()
		return
	
	if is_moving:
		if input_direction != Vector2.ZERO:
			anim_state.travel("Walk")
			move(delta)
		else:
			anim_state.travel("Idle")
			is_moving = false
	else:
		process_player_movement_input()

func process_player_movement_input():
	input_direction = Vector2.ZERO

	# Check horizontal input first to prevent diagonal movement
	if Input.is_action_pressed("ui_right"):
		input_direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		input_direction.x = -1

	# Only check vertical input if no horizontal movement is detected
	if input_direction.x == 0:
		if Input.is_action_pressed("ui_down"):
			input_direction.y = 1
		elif Input.is_action_pressed("ui_up"):
			input_direction.y = -1

	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)

		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
			turn_time = 0  # Reset the turn time
		else:
			initial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")

func need_to_turn() -> bool:
	var new_facing_direction = facing_direction

	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN

	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true

	facing_direction = new_facing_direction
	return false

func move(delta):
	# Calculate the step for this frame
	var step = input_direction * walk_speed * delta

	# Attempt to move using move_and_collide()
	var collision = move_and_collide(step)

	if collision:
		# If a collision occurs, stop movement and emit signal
		percent_moved_to_next_tile = 0.0
		is_moving = false
		emit_signal("player_stopped_signal")
	else:
		# Continue moving smoothly toward the next tile
		percent_moved_to_next_tile += step.length() / TILE_SIZE

		if percent_moved_to_next_tile >= 1.0:
			# Snap to the next tile when fully moved
			position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
		else:
			# Update position incrementally
			position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)

func finished_turning():
	player_state = PlayerState.IDLE
