extends ItemList

var actions = [
	"idle",
	"raise_right",
	"raise_left",
	"crouch",
	"jump"
]

func _on_item_activated(index: int) -> void:
	Globals.action_selected = actions[index]
	print(Globals.action_selected)
	self.visible = false
	Puppet.emit_signal("move_puppet")
