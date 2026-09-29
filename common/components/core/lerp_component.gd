extends Node
class_name LerpComponent

@export var active: bool = true

@export var display: Node3D
@export var move_to: Node3D
@export var lerp_speed: float = 20

@export var position: bool = true
@export var rotation: bool = false

func _ready() -> void:
	display.top_level = true
	if position: display.global_position = move_to.global_position

func _process(delta: float) -> void:
	if not active: return
	var weight: float = 1.0 - exp(-lerp_speed * delta)
	
	if position: 
		display.global_position = display.global_position.lerp(move_to.global_position, weight)
	if rotation:
		var from_basis: Basis = display.global_transform.basis.orthonormalized()
		var to_basis: Basis = move_to.global_transform.basis.orthonormalized()

		var from_quat: Quaternion = from_basis.get_rotation_quaternion()
		var to_quat: Quaternion = to_basis.get_rotation_quaternion()
		var new_quat: Quaternion = from_quat.slerp(to_quat, weight)

		var new_transform: Transform3D = display.global_transform
		new_transform.basis = Basis(new_quat)
		display.global_transform = new_transform
