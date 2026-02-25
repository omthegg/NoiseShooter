extends Node3D

@onready var player:CharacterBody3D = $Player

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if get_window().mode == Window.Mode.MODE_FULLSCREEN:
			get_window().mode = Window.Mode.MODE_WINDOWED
		else:
			get_window().mode = Window.Mode.MODE_FULLSCREEN
