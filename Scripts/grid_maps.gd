extends Node3D
@onready var main_grid: GridMap = $GridMap
@onready var highlight_grid: GridMap = $HighlightMap
var pathfinding: AStar2D = AStar2D.new()
var top_cells: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.cell_clicked_by_mouse.connect(_on_main_camera_cell_clicked)
	var filled_cells: Array[Vector3i] = main_grid.get_used_cells()
	for cell in filled_cells:
		var cell_vec2i = Vector2i(cell.x, cell.z)
		var max_height = top_cells.get(cell_vec2i)
		if max_height == null or cell.y > max_height:
			top_cells[cell_vec2i] = cell.y
			
# function to highlight X tiles from x distance to a position
func highlight_tiles(position_2d: Vector2i, distance: int) -> void:
	var cells_to_highlight: Array[Vector2i] = []
	for x in range(position_2d.x - distance, position_2d.x + distance + 1):
		for z in range(position_2d.y - distance, position_2d.y + distance + 1):
			var cell = Vector2i(x, z)
			if cell.distance_to(position_2d) <= distance and top_cells.has(cell):
				cells_to_highlight.append(cell)
		
	# Clear previous highlights
	highlight_grid.clear()

	# Set new highlights
	for cell in cells_to_highlight:
		var highlight_position = Vector3(cell.x, top_cells[cell] + 1, cell.y)
		highlight_grid.set_cell_item(highlight_position, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_main_camera_cell_clicked(cell: Vector3i) -> void:
	print("test", cell)
	highlight_tiles(Vector2i(cell.x, cell.z), 2)
	pass # Replace with function body.
