extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
	hide()

func set_value(value, rogue_start_time):
	texture_progress_bar.max_value = rogue_start_time
	texture_progress_bar.value = value
	if value < rogue_start_time:
		show()
	else	:
		hide()	
