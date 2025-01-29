extends Node2D

var displayed_scene

@onready var scenes: Node2D = $Scenes

@onready var scene_1: Node2D = $Scenes/Scene1
@onready var scene_2: Node2D = $Scenes/Scene2
@onready var scene_3: Node2D = $Scenes/Scene3
@onready var scene_4: Node2D = $Scenes/Scene4
@onready var scene_5: Node2D = $Scenes/Scene5
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score: Label = $Score

func _ready() -> void:
	Scenes.display_scene.connect(_on_display_scene)

func _process(delta: float) -> void:
	if Scenes.correct:
		score.text = "+1 Scenes!"
	else:
		score.text = "Wrong Scene!"

func _on_display_scene():
	print(Globals.current_scene)
	match Globals.current_scene:
		1:
			displayed_scene = scene_1
			scene_1.visible = true
		2:
			displayed_scene = scene_2
			scene_2.visible = true
		3:
			displayed_scene = scene_3
			scene_3.visible = true
		4:
			displayed_scene = scene_4
			scene_4.visible = true
		5:
			displayed_scene = scene_5
			scene_5.visible = true
	print(displayed_scene)
	for scene in scenes.get_children():
		if scene != displayed_scene:
			scene.visible = false
			
	animation_player.play("scene_up")
	
