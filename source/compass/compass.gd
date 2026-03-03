extends Node3D

@onready var model:Node3D = $Model

var portal:Node3D

func _physics_process(_delta: float) -> void:
	if !portal:
		var scene_manager:Node3D = get_node_or_null("/root/SceneManager")
		if scene_manager:
			portal = scene_manager.portal
		
		return
	
	model.look_at(portal.global_position)
