extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
	self.hide()

func set_value(timer: Timer, rogue_start_time):
	texture_progress_bar.max_value = rogue_start_time
	texture_progress_bar.value = timer.time_left
	if !timer.is_stopped():
		self.show()
	elif timer.is_stopped() or timer.timeout:
		self.hide()
	
