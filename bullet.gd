class_name Bullet extends CharacterBody2D

@export var speed: float = 600

func _process(delta: float) -> void:
	translate(transform.basis_xform(Vector2.UP) * speed * delta)

func _ready() -> void:
	get_tree().create_timer(3).timeout.connect(queue_free)
