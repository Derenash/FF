extends Node3D
@onready var main_grid: GridMap = $GridMap
@onready var highlight_grid: GridMap = $HighlightMap
var pathfinding: CustomAStar = null
var top_cells: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(pathfinding)
	SignalBus.cell_clicked_by_mouse.connect(_on_main_camera_cell_clicked)

	# Clear previous highlights
	highlight_grid.clear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not pathfinding:
		pathfinding = CustomAStar.new()
		add_child(pathfinding)
		pathfinding.initialize(main_grid)
	pass


func _on_main_camera_cell_clicked(cell: Vector3i) -> void:
	# highlight_tiles(Vector2i(cell.x, cell.z), 2)
	var point = pathfinding.get_point_id_from_position(cell)
	print(point)
	var neighbors = pathfinding.get_connected_points(point)
	print(neighbors)
	pass # Replace with function body.
