extends Node2D
@onready var stage: Node2D = $"."

var rng = RandomNumberGenerator.new()
var previous_scene
var scenes_arr = [1,2,3,4,5]
var numbers = [1,2,3,4,5]
var scenes_number = 5

func _ready() -> void:
	scene_gen()

func _process(delta: float) -> void:
	scene_manager()

func scene_gen():
	for n in range(0,scenes_number-1):
		var temp = numbers.pick_random()-1
		scenes_arr[n] = numbers[numbers.find(temp+1,0)]
		if(numbers.pick_random()==null):
			break;
		numbers.pop_at(numbers.find(temp+1,0))
	
func scene_manager():
	if(scenes_arr[Globals.scene_key]==0):
		Scenes.current_scene = 1
		
	if(scenes_arr[Globals.scene_key]==1):

		Scenes.current_scene = 2
		
	if(scenes_arr[Globals.scene_key]==2):
		Scenes.current_scene = 3
		
	if(scenes_arr[Globals.scene_key]==3):
		Scenes.current_scene = 4
		
	if(scenes_arr[Globals.scene_key]==4):
		Scenes.current_scene = 5
		
	if(Globals.scene_key>scenes_number-1):
		Globals.scene_key=0
