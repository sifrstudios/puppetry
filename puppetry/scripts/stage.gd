extends Node2D

@onready var outlines: Node2D = $Outlines
@onready var _2_1: AnimatedSprite2D = $"Outlines/2_1"
@onready var _2_2: AnimatedSprite2D = $"Outlines/2_2"

func _ready() -> void:
	Outline.outline_chosen.connect(outline_chosen)
	print(Puppet.outline_appear)
	outlines.visible = false

func _process(delta: float) -> void:
	if Puppet.outline_appear:
		outlines.visible = true

func outline_chosen():
	print("outline " + str(Outline.pos) + " chosen")
