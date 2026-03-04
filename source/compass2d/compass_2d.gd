extends Node2D

@onready var base:Sprite2D = $Base
@onready var arrow:Sprite2D = $Arrow

var portal:Node3D

func _physics_process(_delta: float) -> void:
	if !portal:
		var scene_manager:Node3D = get_node_or_null("/root/SceneManager")
		if scene_manager:
			portal = scene_manager.portal
		
		return
	
	var player:CharacterBody3D = Global.player
	
	var portal_pos_flat:Vector2 = Vector2(portal.global_position.x, portal.global_position.z)
	var player_pos_flat:Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var difference:Vector2 = portal_pos_flat - player_pos_flat
	var player_forward:Vector3 = -player.global_basis.z
	var player_forward_flat:Vector2 = Vector2(player_forward.x, player_forward.z)
	var angle:float = player_forward_flat.angle_to(difference)
	arrow.rotation = angle
