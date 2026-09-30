class_name TransformUtils extends Node

## Returns a copy of [param xform] rotated by [param angle] (radians) around [param pivot].
static func rotated_around(xform: Transform2D, pivot: Vector2, angle: float) -> Transform2D:
	var rot: Transform2D = Transform2D(angle, Vector2.ZERO)
	var result: Transform2D = rot * xform  # rotates the basis
	result.origin = pivot + rot.basis_xform(xform.origin - pivot)  # orbits the position
	return result
