extends Node3D

@onready var raycast:RayCast3D = $RayCast3D

var snapped_to_floor:bool = false

func _physics_process(_delta: float) -> void:
	if snapped_to_floor:
		return
	
	if raycast.is_colliding():
		global_position = raycast.get_collision_point()
		snapped_to_floor = true
