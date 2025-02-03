extends CharacterBody2D

signal move_puppet
signal EnterAction
signal ExitAction
signal ResetTimers

enum puppet_colors{
	Red,
	Blue,
	Yellow
}

enum animation_state{
	Idle,
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
@export var key: int

var colour = "red"
var current_animation_state: animation_state = animation_state.Idle

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D

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
func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		current_animation_state = animation_state.RunRight
	elif velocity.x < 0:
		current_animation_state = animation_state.RunLeft
	move_and_slide()
#
func _process(delta: float) -> void:
	self.visible = visibility
	animations()
	

func animations():
	match current_animation_state:
		animation_state.Idle:
			animatedSprite2D.play("idle")
		animation_state.Wave:
			animatedSprite2D.play("wave")
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
