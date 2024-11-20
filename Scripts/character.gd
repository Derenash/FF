extends CharacterBody3D
class_name Character

@export var starting_pos := Vector3(0.0, 1.0, 0.0)
var current_pos: Vector3

func _ready() -> void:
	current_pos = starting_pos
	set_position(Global.get_cell_position(starting_pos))

func _physics_process(_delta: float) -> void:
	pass
