extends CharacterBody2D

signal move_puppet

enum puppet_colors{
	Red,
	Blue,
	Yellow
}

enum animation_state{
	Idle,
	Run,
	RunRight,
	RunLeft,
	Wave,
	Falling,
	Getting_Up,
	Stairs,
	Dance1,
	Dance2,
	Dance3,
	Dance4
}

@export var Puppet_Color: puppet_colors

var colour = "red"
@export var key: int

var current_animation_state: animation_state = animation_state.Idle

#var turn_rogue: Timer = null
#var turn_back: Timer = null
#var action: Timer = null
#var right: RayCast2D = null
#var left: RayCast2D = null
#var turn_corrupt: Timer = null
#var area_2d: Area2D = null
#var button: TextureButton = null
#var animatedSprite2D: AnimatedSprite2D = null

@onready var turn_rogue: Timer = $Turn_Rogue
@onready var turn_back: Timer = $Turn_back
@onready var action: Timer = $action
@onready var right: RayCast2D = $Right
@onready var left: RayCast2D = $Left
@onready var turn_corrupt: Timer = $Turn_corrupt
@onready var area_2d: Area2D = $Area2D
@onready var button: TextureButton = $button
@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var rogue_timer: Control = $RogueTimer

var in_action = false;
var is_rogue = false;
var rogue_forever = false;
var beside_rogue = false;
var in_npc_area = false;
var gain_control = false;
var should_move = false
var corrupting = false
var speed = 300;
var direction = 1;
@export var rogue_timer_start = 5.0
@export var turn_back_start = 5.0
@export var turn_corrupt_start = 5.0
@export var visibility: bool = false

func set_color():
	match Puppet_Color:
		puppet_colors.Red:
			colour = "red"
			modulate.r = 255
			modulate.b = 0
			modulate.g = 0
		puppet_colors.Blue:
			colour = "blue"
			modulate.b = 255
		puppet_colors.Yellow:
			colour = "yellow"
			modulate.r = 200
			modulate.g = 200

func _ready() -> void:
	self.visible = false
	set_color()
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
	self.visible = visibility
	if Globals.puppet_key == key:
		if Globals.previous_action == "idle":
			current_animation_state = animation_state.Idle
		elif Globals.previous_action == "raise_right":
			current_animation_state = animation_state.Wave
		elif Globals.previous_action == "raise_left":
			current_animation_state = animation_state.Dance4
		elif Globals.previous_action == "cross":
			current_animation_state = animation_state.Dance3
	animations()
	rogue_timer.set_value(turn_rogue.time_left, rogue_timer_start)
	if is_rogue:
		if rogue_forever:
			Rogue()
		else:
			if turn_back.time_left <= 0:
					turn_back.start(turn_back_start)

			Rogue()
			if gain_control:
				is_rogue = false
				remove_from_group("rogue_puppets")
				add_to_group("puppets")
				
	else:
		if beside_rogue:
			if turn_rogue.time_left <= 0:
					turn_rogue.start(rogue_timer_start)

		else:
			if Globals.in_action:
				action_system()
			else:
				if turn_rogue.time_left <= 0:
					turn_rogue.start(rogue_timer_start)

	
func Rogue():
	if in_npc_area && corrupting:
		should_move = false
		
	else:
		should_move = true
	
func action_system():
	pass
	
func _on_turn_rogue_timeout() -> void:
	is_rogue = true
	remove_from_group("puppets")
	add_to_group("rogue_puppets")
	
func move():
	if !beside_rogue and in_npc_area:	
		current_animation_state = animation_state.Idle
	else:
		current_animation_state = animation_state.Run
	if right.is_colliding():
		direction = -1
	elif left.is_colliding():
		direction = 1
	
func corrupt(body: Node2D):
	if self.is_in_group("puppets") && body.is_in_group("rogue_puppets"):
		if self.turn_corrupt.time_left <= 0:
			corrupting = true
			self.turn_corrupt.start(turn_corrupt_start)
			
	elif self.is_in_group("rogue_puppets") && body.is_in_group("puppets"):
		if body.turn_corrupt.time_left <= 0:
			corrupting = true
			body.turn_corrupt.start(turn_corrupt_start)


func _on_turn_back_timeout() -> void:
	rogue_forever = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body == self):
		pass
	else:
		in_npc_area = true
		corrupt(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body == self):
		pass
	else:
		in_npc_area = false


func _on_turn_corrupt_timeout() -> void:
	is_rogue = true
	corrupting = false
	remove_from_group("puppets")
	add_to_group("rogue_puppets")


func _on_button_pressed() -> void:
	print("CLICK")
	

func animations():
	match current_animation_state:
		animation_state.Idle:
			animatedSprite2D.play("idle")
		animation_state.Wave:
			animatedSprite2D.play("wave")
		animation_state.Run:
			if direction == 1:
				animatedSprite2D.flip_h = false
				animatedSprite2D.play("run")
			elif direction == -1:
				animatedSprite2D.flip_h = true
				animatedSprite2D.play("run")
		animation_state.RunRight:
			animatedSprite2D.flip_h = false
			animatedSprite2D.play("run")
		animation_state.RunLeft:
			animatedSprite2D.flip_h = true
			animatedSprite2D.play("run")
		animation_state.Stairs:
			animatedSprite2D.play("stairs_side")
		animation_state.Getting_Up:
			animatedSprite2D.play("getting_up")
		animation_state.Falling:
			animatedSprite2D.play("falling")
		animation_state.Dance1:
			animatedSprite2D.play("dance1")
		animation_state.Dance2:
			animatedSprite2D.play("dance2")
		animation_state.Dance3:
			animatedSprite2D.play("dance3")
		animation_state.Dance4:
			animatedSprite2D.play("dance4")
