extends Control

@onready var fps_label:Label = $FPSLabel
@onready var draw_calls_label:Label = $DrawCallsLabel
@onready var primitives_label:Label = $PrimitivesLabel
@onready var vram_usage_label:Label = $VRAMUsageLabel
@onready var process_time_label:Label = $ProcessTimeLabel
@onready var label:Label = $Label


func _process(_delta: float) -> void:
	var fps_text:String = "FPS: " + str(int(Engine.get_frames_per_second()))
	fps_label.text = fps_text
	
	var draw_calls:float = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var draw_calls_text:String = "Draw calls: " + str(int(draw_calls))
	draw_calls_label.text = draw_calls_text
	
	var primitives:float = Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	var primitives_text:String = "Primitives: " + str(int(primitives))
	primitives_label.text = primitives_text
	
	var vram_usage:float = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	var vram_usage_text:String = "VRAM usage: ~" + str(int(vram_usage/1000000.0)) + "MB"
	vram_usage_label.text = vram_usage_text
	
	var process_time:float = Performance.get_monitor(Performance.TIME_PROCESS)
	var process_time_text:String = "Process time: " + str(process_time*1000.0) + "ms"
	process_time_label.text = process_time_text
	
	var text:String = ""
	text += fps_text + "\n"
	text += draw_calls_text + "\n"
	text += primitives_text + "\n"
	text += vram_usage_text + "\n"
	text += process_time_text + "\n"
	
	label.text = text
