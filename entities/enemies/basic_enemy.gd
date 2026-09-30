class_name BasicEnemy extends Area2D

var lerp_time: float = 0.0
var lerp_duration: float = 3.0
var start_value: Vector2 = Vector2(500, 500)
var end_value: Vector2 = Vector2.ZERO
var current_value: Vector2

@export var health_component: HealthComponent

func _ready() -> void:
	start_value = position
	health_component.health_depleted.connect(_on_health_depleted)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	transform = TransformUtils.rotated_around(transform, Vector2.ZERO, deg_to_rad(45) * delta);
	position = position.lerp(Vector2.ZERO, .2 * delta)


func _on_health_depleted() -> void:
	GameManager.enemy_killed()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		_on_health_depleted() # Temp logic
