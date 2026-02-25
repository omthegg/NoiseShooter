extends Control

@onready var fps_label:Label = $FPSLabel
@onready var draw_calls_label:Label = $DrawCallsLabel
@onready var primitives_label:Label = $PrimitivesLabel
@onready var vram_usage_label:Label = $VRAMUsageLabel
@onready var process_time_label:Label = $ProcessTimeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	fps_label.text = "FPS: " + str(int(Engine.get_frames_per_second()))
	var draw_calls:float = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	draw_calls_label.text = "Draw calls: " + str(int(draw_calls))
	var primitives:float = Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	primitives_label.text = "Primitives: " + str(int(primitives))
	var vram_usage:float = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	vram_usage_label.text = "VRAM usage: ~" + str(int(vram_usage/1000000.0)) + "MB"
	var process_time:float = Performance.get_monitor(Performance.TIME_PROCESS)
	process_time_label.text = "Process time: " + str(process_time*1000.0) + "ms"
