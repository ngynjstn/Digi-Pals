extends Control

@onready var enemy = $CanvasLayer/Enemy
@onready var attack1_btn = $CanvasLayer/UI/PlayerMenu/FightMenu/AttackBtn1
@onready var attack2_btn = $CanvasLayer/UI/PlayerMenu/FightMenu/AttackBtn2
@onready var enemy_hp_bar = $CanvasLayer/Enemy/EnemyHPBar
@onready var anim = $CanvasLayer/AnimationPlayer
@onready var text_timer = $CanvasLayer/UI/DialogBox/TextTimer
@onready var dialog = $CanvasLayer/UI/DialogBox/RichTextLabel
@onready var dialog_box = $CanvasLayer/UI/DialogBox
@onready var click_to_continue = $CanvasLayer/UI/DialogBox/ContinueArrow
@onready var menu = $CanvasLayer/UI/PlayerMenu
@onready var menu_arrow = $CanvasLayer/UI/PlayerMenu/FightMenu/MenuArrow
@onready var player = $CanvasLayer/Player
@onready var canvas = $CanvasLayer

@export var text_speed: float = 0.04
@export var world : PackedScene

var text_num: int = 0
var is_dialog_finished: bool = false
var is_menu_visible: bool = false
var begin_battle: bool = false
var player_turn: bool = true

#var thunder_scene = preload("res://Scenes/Battle/ThunderShock.tscn")

func _ready():
	SignalManager.connect("btn_pos", Callable(self, "move_menu_arrow"))
	SignalManager.connect("player_animation_finished", Callable(self, "on_player_animation_finished"))
	SignalManager.connect("enemy_animation_finished", Callable(self, "on_enemy_animation_finished"))
	SignalManager.connect("enemy_dead", Callable(self, "on_enemy_dead"))
	SignalManager.connect("player_dead", Callable(self, "on_player_dead"))
	anim.play("fade_in")
	dialog_box.visible = true
	dialog.visible = false
	$BattleMusic.play()
	begin_battle = true  # Ensure the battle starts immediately

func _process(_delta: float) -> void:
	click_to_continue.visible = is_dialog_finished
	
	if begin_battle:
		show_dialog("ENEMY HAS APPEARED!")
		begin_battle = false
		
	if Input.is_action_just_pressed("ui_accept") and not is_menu_visible and enemy.hp > 0:
		if is_dialog_finished:
			dialog.visible = false
			dialog_box.visible = false
			click_to_continue.visible = false
			anim.play("hide")
			menu.visible = true
			is_menu_visible = true
			attack1_btn.grab_focus()
		else:
			dialog.visible_characters = dialog.text.length()

func on_enemy_dead() -> void:
	# exit battle
	show_dialog("ENEMY fainted")
	click_to_continue.visible = false
	anim.play("fade_out")
	get_tree().change_scene_to_packed(world)

func on_player_dead() -> void:
	show_dialog("Player blacked out!")
	anim.play("hide")
	anim.play("fade_out")
	get_tree().change_scene_to_packed(world)
	
	
func move_menu_arrow(x: float, y: float) -> void:
	# position the arrow on the menu 
	menu_arrow.global_position.x = x
	menu_arrow.global_position.y = y

func show_dialog(custom_text: String) -> void:
	# show dialog box with custom text.
	GameManager.is_dialog = true
	dialog_box.visible = true
	menu.visible = false
	dialog.visible = true
	is_dialog_finished = false
	click_to_continue.visible = true
	text_timer.wait_time = text_speed
	dialog.text = custom_text  # Set the text before starting the animation
	next_text()
	
func next_text() -> void:
	# animate the dialog text
	if text_num >= dialog.text.length():
		dialog.text = ""
		return
	
	is_dialog_finished = false
	
	dialog.visible_characters = 0
		
	while dialog.visible_characters < dialog.text.length():
		dialog.visible_characters += 1
		
		text_timer.start()
		await text_timer.timeout
	
	is_dialog_finished = true
	text_num += 1
	
	return

func _on_attack_btn_1_pressed() -> void:
	is_menu_visible = false
	show_dialog("YOU used " + attack1_btn.text)
	#player.animation_player.play("tackle")
	await get_tree().create_timer(1.0).timeout 
	SignalManager.emit_signal("enemy_hp_changed", 5)
	on_enemy_turn()

func _on_attack_btn_2_pressed() -> void:
	is_menu_visible = false
	show_dialog("YOU used " + attack2_btn.text)
	#player.animation_player.play("thunder")
	#var thunder_instance = thunder_scene.instantiate()
	#canvas.add_child(thunder_instance)
	#thunder_instance.position = $CanvasLayer/FX_pos.position    
	await get_tree().create_timer(1.0).timeout 
	SignalManager.emit_signal("enemy_hp_changed", 10)
	on_enemy_turn()

func _on_run_btn_pressed() -> void:
	# exit battle
	show_dialog("Ran away safely")
	anim.play("fade_out")
	get_tree().change_scene_to_packed(world)
func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_out":
		GameManager.is_battle = false
		queue_free()
		
	if anim_name == "fade_in":
		begin_battle = true

func on_enemy_turn() -> void:
	if enemy.hp > 0:
		show_dialog("ENEMY used CLAW!")
		SignalManager.emit_signal("player_hp_changed", 10)
		await get_tree().create_timer(1.0).timeout
		#enemy.animation_player.play("attack")

func on_player_animation_finished() -> void:
	#enemy.animation_player.play("hit")
	await get_tree().create_timer(1.0).timeout 
	GameManager.turn = "enemy"
	on_enemy_turn()

func on_enemy_animation_finished() -> void:
	GameManager.turn = "player"
