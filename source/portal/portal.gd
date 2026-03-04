extends Node3D

@export var other_portal:Node3D:
	set(value):
		other_portal = value
		surface.material_override.albedo_texture.viewport_path = other_portal.sub_viewport.get_path()

@onready var raycast:RayCast3D = $RayCast3D
@onready var camera:Camera3D = $SubViewport/Camera3D
@onready var surface:MeshInstance3D = $Surface
@onready var sub_viewport:SubViewport = $SubViewport

var snapped_to_floor:bool = false

func _physics_process(_delta: float) -> void:
	#var player:CharacterBody3D = Global.player
	
	if raycast.is_colliding():
		global_position = raycast.get_collision_point()
		snapped_to_floor = true
	
	# See Sebastian Lague's "Coding Adventure: Portals"
	var main_cam:Camera3D = Global.player_camera
	if other_portal and main_cam:
		#var dif:Vector3 = global_position - main_cam.global_position
		#other_portal.camera.position = to_local(main_cam.global_position)
		#other_portal.camera.global_position += other_portal.global_position
		other_portal.camera.transform = other_portal.global_transform * global_transform.affine_inverse() * main_cam.global_transform
		#other_portal.camera.position.x = dif.x * cos(other_portal.rotation.x)
		#other_portal.camera.position.z = dif.z * sin(other_portal.rotation.z)
	#camera.global_position = global_position + Vector3(0.0, 1.7/2, 0.0)
	#camera.global_rotation = get_tree().root.get_camera_3d().global_rotation
	#camera.rotation_degrees.x -= 90.0
