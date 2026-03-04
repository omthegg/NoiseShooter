extends Node3D

@export var noise_texture:NoiseTexture2D

const chunk_dimension:int = 40

var chunk_packed_scene:PackedScene = preload("res://source/chunk/chunk.tscn")
var default_ground_material:StandardMaterial3D = preload("res://source/world/default_ground_material.tres")

var loaded_chunks:PackedVector3Array = []
var chunks_to_load:PackedVector3Array = []
var chunks_to_unload:PackedVector3Array = []

var chunk_check_thread:Thread = Thread.new()

var render_distance:int = 5

var ground_material:StandardMaterial3D

var portal_packed_scene:PackedScene = preload("res://source/portal/portal.tscn")

func _ready() -> void:
	noise_texture.noise.seed = randi()
	
	ground_material = default_ground_material.duplicate(true)
	var ground_color:Color = Color.LAWN_GREEN
	ground_color = Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255))
	ground_material.albedo_color = ground_color
	
	$WorldEnvironment.environment.background_color = Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255))
	
	var portal:Node3D = portal_packed_scene.instantiate()
	add_child(portal)
	portal.position = Vector3(-2.0, 40.5, 0.0)
	#portal.position = Vector3(randi_range(-40, 40), 
	#200.0, randi_range(-40, 40))
	
	var portal2:Node3D = portal_packed_scene.instantiate()
	add_child(portal2)
	portal2.position = portal.position + Vector3(4.0, 0.0, 0.0)
	portal2.rotation_degrees.y += 180
	
	await get_tree().process_frame
	get_node("/root/SceneManager").portal = portal
	portal.other_portal = portal2
	portal2.other_portal = portal


func _physics_process(_delta: float) -> void:
	var player:CharacterBody3D = get_parent().get_node("Player")
	
	#var grid_player_position:Vector3 = player.global_position.snapped(
	#Vector3.ONE * chunk_dimension)
	#if !(grid_player_position in loaded_chunks):
	#	player.velocity = Vector3.ZERO
	
	if !chunk_check_thread.is_alive():
		if chunk_check_thread.is_started():
			chunk_check_thread.wait_to_finish()
		
		chunk_check_thread.start(Callable(self, "update_lists").bind(
		player.global_position))
	#update_lists(player.global_position)
	
	#for chunk in chunks_to_load:
	#	generate_chunk(chunk.x, chunk.z)
	if chunks_to_load.size() > 0:
		generate_chunk(chunks_to_load[0].x, chunks_to_load[0].z)
	
	for chunk in chunks_to_unload:
		chunks_to_unload.erase(chunk)
		var chunk_node:Node3D = get_node_or_null(str(chunk).replace(".", "_"))
		if !chunk_node:
			continue
		
		remove_child(chunk_node)
		chunk_node.queue_free()


func update_lists(player_position:Vector3) -> void:
	var grid_player_position:Vector3 = player_position.snapped(
	Vector3.ONE * chunk_dimension)
	
	var r:int = render_distance * chunk_dimension
	var chunks_range_x:Array = range(grid_player_position.x-r, 
	grid_player_position.x+r, chunk_dimension)
	
	var chunks_range_z:Array = range(grid_player_position.z-r, 
	grid_player_position.z+r, chunk_dimension)
	
	var chunks_to_keep:PackedVector3Array = []
	
	for x in chunks_range_x:
		for z in chunks_range_z:
			var origin:Vector3 = Vector3(x, 0, z)
			if origin in loaded_chunks:
				chunks_to_keep.append(origin)
				continue
			
			if origin in chunks_to_load:
				continue
			
			if origin in chunks_to_unload:
				continue
			
			chunks_to_load.append(origin)
	
	for chunk in loaded_chunks:
		if chunk in chunks_to_keep:
			continue
		if chunk in chunks_to_unload:
			continue
		
		chunks_to_unload.append(chunk)
		loaded_chunks.erase(chunk)


func generate_chunk(x:float, z:float) -> void:
	var chunk:Node3D = chunk_packed_scene.instantiate()
	add_child(chunk)
	chunk.position = Vector3(x, 0.0, z)
	chunk.name = str(chunk.global_position)
	chunk.dimension = chunk_dimension
	chunk.mesh_instance.material_override = ground_material
	chunk.generate(noise_texture.noise)
	
	chunks_to_load.erase(Vector3(x, 0.0, z))
	loaded_chunks.append(Vector3(x, 0.0, z))
