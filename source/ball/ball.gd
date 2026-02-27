extends RigidBody3D


func _ready() -> void:
	$MeshInstance3D.material_override.albedo_color = Color8(randi_range(0, 255),
	randi_range(0, 255), randi_range(0, 255))
