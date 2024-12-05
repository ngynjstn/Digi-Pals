extends Node2D

#@onready var animation_player = $AnimationPlayer
@onready var attack_damage = 4
@onready var hp_bar = $EnemyHPBar
@export var max_hp = 100
var hp = 100
var is_alive = true


func _ready():
	SignalManager.connect("enemy_hp_changed", on_enemy_hp_changed)
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = max_hp

func get_hp():
	return hp

func _process(delta):
	if hp <= 0 and is_alive:
		SignalManager.emit_signal("enemy_dead")
		print("enemy is dead")
		is_alive = false

func on_enemy_hp_changed(new_hp):
	hp -= new_hp
	hp_bar.value = hp
	print(hp)
