extends CharacterBody2D

signal move_puppet

@export var colour : String
@onready var outline_appear = false

@onready var turn_rogue: Timer = $Turn_Rogue
@onready var turn_back: Timer = $Turn_back
@onready var action: Timer = $action
@onready var right: RayCast2D = $Right
@onready var left: RayCast2D = $Left
@onready var turn_corrupt: Timer = $Turn_corrupt
@onready var area_2d: Area2D = $Area2D

@export var in_action = true;
@export var is_rogue = true;
@export var rogue_forever = false;
@export var beside_rogue = true;
@export var in_npc_area = false;
@export var gain_control = false;
@export var should_move = false
@export var corrupting = false
@export var speed = 300;
@export var direction = 1;
@export var rogue_timer_start = 5.0
@export var turn_back_start = 5.0
@export var turn_corrupt_start = 5.0


func _ready() -> void:
	area_2d.connect("entered", Callable(self, "_on_area_2d_body_entered"))
	add_to_group("puppets")
	turn_rogue.connect("timeout", Callable(self, "_on_turn_rogue_timeout"))
	turn_back.connect("timeout", Callable(self, "_on_turn_back_timeout"))
	
func _physics_process(delta: float) -> void:
	if should_move:
		position.x += speed * delta * direction
		move()
	move_and_slide()

func _process(delta: float) -> void:
	if is_rogue:
		if rogue_forever:
			Rogue()
		else:
			if turn_back.time_left <= 0:
					turn_back.start(turn_back_start)
					print(turn_back.time_left)
			Rogue()
			if gain_control:
				is_rogue = false
				remove_from_group("rogue_puppets")
				add_to_group("puppets")
				
	else:
		if beside_rogue:
			if turn_rogue.time_left <= 0:
					turn_rogue.start(rogue_timer_start)
					print(turn_rogue.time_left)
		else:
			if in_action:
				action_system()
			else:
				if turn_rogue.time_left <= 0:
					turn_rogue.start(rogue_timer_start)
					print(turn_rogue.time_left)
	
func Rogue():
	if in_npc_area && corrupting:
		should_move = false
		
	else:
		should_move = true
	
func action_system():
	in_action = true
	#the action
	in_action = false
	
func _on_turn_rogue_timeout() -> void:
	print("now rogue")
	is_rogue = true
	remove_from_group("puppets")
	add_to_group("rogue_puppets")
	
func move():
	if right.is_colliding():
		print("colliding")
		direction = -1
	elif left.is_colliding():
		direction = 1
	
func corrupt(body: Node2D):
	if self.is_in_group("puppets") && body.is_in_group("rogue_puppets"):
		if self.turn_corrupt.time_left <= 0:
			corrupting = true
			self.turn_corrupt.start(turn_corrupt_start)
			print("get corrupted")
			
	elif self.is_in_group("rogue_puppets") && body.is_in_group("puppets"):
		if body.turn_corrupt.time_left <= 0:
			corrupting = true
			body.turn_corrupt.start(turn_corrupt_start)
			print("corrupt")


func _on_turn_back_timeout() -> void:
	print("now rogue forever")
	rogue_forever = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body")
	if (body == self):
		print ("self")
	else:
		in_npc_area = true
		corrupt(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body == self):
		print ("self")
	else:
		in_npc_area = false


func _on_turn_corrupt_timeout() -> void:
	print("now rogue")
	is_rogue = true
	corrupting = false
	remove_from_group("puppets")
	add_to_group("rogue_puppets")
