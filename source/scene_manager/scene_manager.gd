extends Node3D

@onready var player:CharacterBody3D = $Player
@onready var player_camera:Camera3D = $Player/CharacterController/Head/Camera3D
@onready var compass:Node3D = $UI/SubViewportContainer/SubViewport/Compass
@onready var compass2d:Node2D = $UI/Compass2D

var portal:Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.player = player
	Global.player_camera = player.get_node("CharacterController/Head/Camera3D")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if get_window().mode == Window.Mode.MODE_FULLSCREEN:
			get_window().mode = Window.Mode.MODE_WINDOWED
		else:
			get_window().mode = Window.Mode.MODE_FULLSCREEN
	
	if event.is_action_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(_delta: float) -> void:
	compass.global_transform = player_camera.global_transform
	compass.global_position.y -= 20.0
