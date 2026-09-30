class_name EnemySpawner extends Node2D

@export var enemy: PackedScene
@export var timer: Timer
@export var entity_parent: Node2D

func _ready() -> void:
	print()
	
	GameManager.game_started.connect(func(): timer.start())
	GameManager.round_complete.connect(_change_spawn_timer_state.bind(false))
	GameManager.round_start.connect(_change_spawn_timer_state.bind(true))
	timer.timeout.connect(_spawn_enemy)

func _change_spawn_timer_state(state: bool) -> void:
	if state:
		timer.start(GameManager.get_round_spawntime())

func _spawn_enemy() -> void:
	var instance: Node2D = enemy.instantiate()
	instance.global_position = Vector2(randi_range(-2000, 2000), randi_range(-1200, 1200))
	entity_parent.add_child.call_deferred(instance)
