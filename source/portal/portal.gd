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

var travellers:Dictionary = {}

var previous_dot_sign:int


# TODO: Make it so the player either gets sucked in or pushed away when too
# close to the surface of the portal, so it doesn't clip into the camera
func _physics_process(_delta: float) -> void:
	#var player:CharacterBody3D = Global.player
	
	if raycast.is_colliding():
		global_position = raycast.get_collision_point()
		snapped_to_floor = true
	
	for traveller in travellers:
		var normal:Vector3 = surface.global_basis.z
		var dot:float = normal.dot(traveller.global_position)
		if sign(dot) != travellers[traveller]:
			traveller.global_transform = other_portal.global_transform * global_transform.affine_inverse() * traveller.global_transform
			if traveller is CharacterBody3D:
				traveller.velocity = other_portal.global_transform * global_transform.affine_inverse() * traveller.velocity
			elif traveller is RigidBody3D:
				traveller.linear_velocity = other_portal.global_transform * global_transform.affine_inverse() * traveller.linear_velocity


func _process(_delta: float) -> void:
	# See Sebastian Lague's "Coding Adventure: Portals"
	var main_cam:Camera3D = Global.player_camera
	if other_portal and main_cam:
		other_portal.camera.global_transform = other_portal.global_transform * global_transform.affine_inverse() * main_cam.global_transform


func _on_area_3d_body_entered(body: Node3D) -> void:
	var normal:Vector3 = surface.global_basis.z
	var dot:float = normal.dot(Global.player.global_position)
	travellers[body] = sign(dot)


func _on_area_3d_body_exited(body: Node3D) -> void:
	travellers.erase(body)
