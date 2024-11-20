extends Node

const CELL_WIDTH: float = 2
const CELL_DEPTH: float = 2
const CELL_HEIGHT: float = 2

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_cell_position(cell: Vector3) -> Vector3:
	return Vector3(cell.x * CELL_WIDTH, cell.y * CELL_HEIGHT, cell.z * CELL_DEPTH)