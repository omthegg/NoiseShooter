extends Node3D

@export var noise_texture:NoiseTexture2D

const chunk_dimension:int = 20

var chunk_packed_scene:PackedScene = preload("res://source/chunk/chunk.tscn")

var loaded_chunks:PackedVector3Array = []
var chunks_to_load:PackedVector3Array = []
var chunks_to_unload:PackedVector3Array = []

var chunk_check_thread:Thread = Thread.new()

var render_distance:int = 20


func _physics_process(_delta: float) -> void:
	var player:CharacterBody3D = get_parent().get_node("Player")
	
	var grid_player_position:Vector3 = player.global_position.snapped(Vector3(20.0, 20.0, 20.0))
	if !(grid_player_position in loaded_chunks):
		player.velocity = Vector3.ZERO
	
	if !chunk_check_thread.is_alive():
		if chunk_check_thread.is_started():
			chunk_check_thread.wait_to_finish()
		
		chunk_check_thread.start(Callable(self, "update_lists").bind(player.global_position))
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
	var grid_player_position:Vector3 = player_position.snapped(Vector3(20.0, 20.0, 20.0))
	
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
	chunk.global_position = Vector3(x, 0.0, z)
	chunk.name = str(chunk.global_position)
	chunk.generate(noise_texture.noise)
	
	chunks_to_load.erase(Vector3(x, 0.0, z))
	loaded_chunks.append(Vector3(x, 0.0, z))
