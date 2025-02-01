extends Node

enum  ActionMenuItems{
	Idle,
	Dance1,
	Dance2,
	Dance3,
	Dance4,
	Wave
}
enum PossibleColors{
	Red,
	Blue,
	Yellow
}

@export_category("Action Menu")
@export var Item1: ActionMenuItems
@export var Item2: ActionMenuItems
@export var Item3: ActionMenuItems
@export var Item4: ActionMenuItems

@export_category("First Act")
@export var Outline_First: Texture2D
@export var color_First: PossibleColors

@export_category("Second Act")
@export var Outline_Second: Texture2D
@export var color_Second: PossibleColors

@export_category("Third Act")
@export var Outline_Third: Texture2D
@export var color_Third: PossibleColors
