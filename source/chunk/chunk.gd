extends Node3D

@onready var mesh_instance:MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

var default_plane:PlaneMesh = preload("res://source/chunk/default_plane.tres")
var mdt := MeshDataTool.new()

func generate(noise:FastNoiseLite) -> void:
	var array_mesh:ArrayMesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, 
	default_plane.surface_get_arrays(0))
	
	mdt.create_from_surface(array_mesh, 0)
	
	var heightmap_shape:HeightMapShape3D = HeightMapShape3D.new()
	heightmap_shape.map_width = 21
	heightmap_shape.map_depth = 21
	
	for i in range(mdt.get_vertex_count()):
		var vertex := mdt.get_vertex(i)
		vertex.y = noise.get_noise_2d(vertex.x + global_position.x, 
		vertex.z + global_position.z) * 5.0
		
		mdt.set_vertex(i, vertex)
		var heightmap_array_index := get_heightmap_array_index(int(vertex.x), 
		int(vertex.z), 21)
		
		heightmap_shape.map_data[heightmap_array_index] = vertex.y
	
	array_mesh.clear_surfaces()
	mdt.commit_to_surface(array_mesh)
	
	mesh_instance.mesh = array_mesh
	collision_shape.shape = heightmap_shape


func get_heightmap_array_index(x:int, y:int, dimension:int) -> int:
	return ((x+(dimension-1)/2) + dimension * (y+(dimension-1)/2))
