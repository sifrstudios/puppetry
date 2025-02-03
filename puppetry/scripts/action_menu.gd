extends ItemList

var actions = [
	"idle",
	"kungfu",
	"wave_arms",
	"cross_wave",
	"shuffle"
]

func _on_item_activated(index: int) -> void:
	Globals.action_selected = actions[index]
	print(Globals.action_selected)
	self.visible = false
	Puppet.emit_signal("move_puppet")
