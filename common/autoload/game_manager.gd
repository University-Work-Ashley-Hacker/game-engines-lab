extends Node

signal on_enemy_killed
signal round_complete
signal round_start
signal round_changed(round: int)
signal game_started

var current_round: int = 0:
	get:
		return current_round
	set(value):
		#if current_round != value:
		round_changed.emit(value)
		current_round = value
var money: float = 0
var kills: int = 0
var required_kills: int = 5

var enemy_round_spawntimes: Array[float] = [3, 2, 1.75, 1.5, 1.2, 1, .5, .1]

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	_start_game()

func _start_game() -> void:
	current_round = 0
	game_started.emit()

var entity_parent: Node2D:
	get:
		if entity_parent == null:
			print(get_tree().get_root())
			#entity_parent = get_tree().get_root()
		return entity_parent
	set(value):
		entity_parent = value

func enemy_killed() -> void:
	kills += 1
	on_enemy_killed.emit()
	
	if kills >= required_kills:
		round_complete_logic()


func round_complete_logic() -> void:
	round_complete.emit()
	current_round += 1
	kills = 0
	required_kills += 1
	await get_tree().create_timer(8).timeout
	round_start.emit()

func get_round_spawntime() -> float:
	return enemy_round_spawntimes[current_round]
