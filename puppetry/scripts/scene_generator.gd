extends Node2D

@onready var scenes: Node2D = $"../Scenes"

var rng = RandomNumberGenerator.new()
var previous_scene
var scenes_arr = [1,2,3,4,5]
var numbers= [1,2,3,4,5]
var scenes_number=5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_gen()
	print(scenes_arr)
	pass # Replace with function body.
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scene_manager()
	pass

func scene_gen():
	
	
	for n in range(0,scenes_number-1):
		var temp = numbers.pick_random()-1
		scenes_arr[n] = numbers[numbers.find(temp+1,0)]
		print(scenes_arr)
		print(numbers)
		if(numbers.pick_random()==null):
			break;
		print(numbers.find(temp+1,0))	
		numbers.pop_at(numbers.find(temp+1,0))
		print(scenes_arr)
		print(numbers)
	
func scene_manager():
	if(scenes_arr[Global.scene_key]==0):
		scenes.scene1()
	if(scenes_arr[Global.scene_key]==1):
		scenes.scene2()
	if(scenes_arr[Global.scene_key]==2):
		scenes.scene3()
	if(scenes_arr[Global.scene_key]==3):
		scenes.scene4()
	if(scenes_arr[Global.scene_key]==4):
		scenes.scene5()
	if(Global.scene_key>scenes_number-1):
		Global.scene_key=0
	pass
