extends Node3D

@export var player:CharacterBody3D
@export var character_controller:Node3D

@onready var camera:Camera3D = character_controller.get_node("Head/Camera3D")

var ball_packed_scene:PackedScene = preload("res://source/ball/ball.tscn")


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()


func shoot() -> void:
	var world:Node3D = get_tree().root.get_node("SceneManager/World")
	var ball_instance:RigidBody3D = ball_packed_scene.instantiate()
	
	var pos:Vector3 = camera.global_position + camera.global_basis * Vector3(0, 0, -3)
	var impulse:Vector3 = camera.global_basis * Vector3(0, 0, -10) + player.velocity
	
	world.add_child(ball_instance, true)
	ball_instance.global_position = pos
	ball_instance.apply_central_impulse(impulse)
