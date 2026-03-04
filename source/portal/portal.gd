extends Node3D

@export var other_portal:Node3D:
	set(value):
		other_portal = value
		surface.material_override.get_shader_parameter("texture_albedo").viewport_path = other_portal.sub_viewport.get_path()

@onready var raycast:RayCast3D = $RayCast3D
@onready var camera:Camera3D = $SubViewport/Camera3D
@onready var surface:MeshInstance3D = $Surface
@onready var sub_viewport:SubViewport = $SubViewport

var snapped_to_floor:bool = false

var touching_player:bool = false
var previous_dot_sign:int

func _physics_process(_delta: float) -> void:
	#var player:CharacterBody3D = Global.player
	
	if raycast.is_colliding():
		global_position = raycast.get_collision_point()
		snapped_to_floor = true
	
	# See Sebastian Lague's "Coding Adventure: Portals"
	var main_cam:Camera3D = Global.player_camera
	if other_portal and main_cam:
		other_portal.camera.global_transform = other_portal.global_transform * global_transform.affine_inverse() * main_cam.global_transform
	
	if touching_player:
		var normal:Vector3 = surface.global_basis.z
		var dot:float = normal.dot(Global.player.global_position)
		if sign(dot) != previous_dot_sign:
			Global.player.global_transform = other_portal.global_transform * global_transform.affine_inverse() * Global.player.global_transform
		
		previous_dot_sign = sign(dot)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		touching_player = true
		var normal:Vector3 = surface.global_basis.z
		var dot:float = normal.dot(Global.player.global_position)
		previous_dot_sign = sign(dot)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		touching_player = false
