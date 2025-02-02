extends State
class_name Rogue

@export var puppet: CharacterBody2D
@export var right: RayCast2D
@export var left: RayCast2D
var direction: int
var speed: int

func randomize_speed():
	return randi_range(250,300)

func chose_random():
	var direction = 1
	if randf() < 0.5:
		direction = -1
	return direction

func Enter():
	puppet.add_to_group("rogue_puppets")
	direction = chose_random()
	speed = randomize_speed()
	print("rogue")
	
func Physics_Update(delta: float):
	puppet.velocity.x = speed * delta * direction
	puppet.position.x += puppet.velocity.x
	if right.is_colliding():
		direction = -1
	elif left.is_colliding():
		direction = 1
