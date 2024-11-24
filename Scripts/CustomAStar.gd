extends Node2D
class_name CustomAStar

# Single AStar2D instance for the entire map
var astar = AStar2D.new()
var walkable_grid: Dictionary = {}

func _ready():
  # Setup grid with heights and connections
  pass

func init(gridMap: GridMap):
  setup_walkable_grid(gridMap)
  add_points()
  add_connections()
  print("point_count: ", astar.get_point_count())
  for i in range(100):
    var start = randi() % astar.get_point_count()
    var end = randi() % astar.get_point_count()
    var path = astar.get_id_path(start, end)
    if path.size() > 0:
      print(path)

func get_connected_points(point_id: int) -> PackedInt64Array:
  return astar.get_point_connections(point_id)

func get_point_from_position(tile_position_3d: Vector3) -> int:
  print("3d ", tile_position_3d)
  var tile_position = Vector2(tile_position_3d.x, tile_position_3d.z)
  print("2d: ", tile_position)
  for column in walkable_grid:
    if column == tile_position:
      print("column: ", column)
      for tile in walkable_grid[column]:
        print("tile: ", tile)
        print("height 3d: ", tile_position_3d.y)

        if tile["height"] == tile_position_3d.y - 1:
          return tile["id"]
  return -1

# Identifies walkable positions in a 3D grid.
# A position is walkable if it has at least 2 units of empty space above it.
func setup_walkable_grid(gridMap: GridMap) -> void:

  # Group tiles by their x,z coordinates
  var columns: Dictionary = _group_tiles_by_column(gridMap)


  # Find walkable heights in each column
  walkable_grid = _find_walkable_heights(columns)

func add_points() -> void:
  for column in walkable_grid:
    for tile in walkable_grid[column]:
      var tile_position = Vector2(column.x, column.y)
      astar.add_point(tile["id"], tile_position)
      show_id(Vector3(tile_position.x, tile["height"], tile_position.y), str(tile["id"]))

func add_connections() -> void:
  for column in walkable_grid:
    for tile in walkable_grid[column]:
      var tile_position = Vector2(column.x, column.y)
      var tile_id = tile["id"]
      for neighbor in _get_neighbors(tile_position):
        print("connecting: ", tile_id, " to: ", neighbor)
        astar.connect_points(tile_id, neighbor)

func _get_neighbors(tile_position: Vector2) -> Array[int]:
  var neighbors: Array[int] = []
  var directions: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
  for direction in directions:
    var neighbor_position = tile_position + direction
    if neighbor_position in walkable_grid:

      for neighbor_tile in walkable_grid[neighbor_position]:
        neighbors.append(neighbor_tile["id"])

  return neighbors
        

func _group_tiles_by_column(gridMap: GridMap) -> Dictionary:
  var columns: Dictionary = {}
  for tile in gridMap.get_used_cells():
    var column_pos = Vector2(tile.x, tile.z)
    Utils.append_to_dict_array(columns, column_pos, tile.y)

  for column_pos in columns:
    columns[column_pos].sort()

  return columns

func _find_walkable_heights(columns: Dictionary) -> Dictionary:
  var walkable_columns: Dictionary = {}
  var id_counter: int = 0

  for tile_pos in columns:
    var heights = columns[tile_pos]
    if heights.is_empty():
      continue

    var current_height = heights[0]

    for next_height in heights.slice(1):
      if next_height - current_height > Global.MINIMUM_SPACE_TO_WALK:
        var walkable_tile = {"height": current_height, "id": id_counter}
        Utils.append_to_dict_array(walkable_columns, tile_pos, walkable_tile)
        id_counter += 1
      current_height = next_height
      
    # Last height is always walkable (nothing above it)
    var topmost_tile = {"height": current_height, "id": id_counter}
    Utils.append_to_dict_array(walkable_columns, tile_pos, topmost_tile)
    id_counter += 1
      
  return walkable_columns


# Check if an edge is valid based on height constraints
func is_movement_valid(id1: int, id2: int, jump_strength: float):
  var height1 = astar.get_point_metadata(id1).height
  var height2 = astar.get_point_metadata(id2).height
  return abs(height1 - height2) <= jump_strength


func show_id(tile_position: Vector3, tile_id: String):
  var label = Label3D.new()
  label.text = tile_id
  label.billboard = BaseMaterial3D.BILLBOARD_DISABLED # Disable billboarding
  label.pixel_size = 0.03
  label.modulate = Color(1, 1, 0)
  label.outline_modulate = Color(0, 0, 0)
  label.outline_size = 2
  
  # Calculate the label position to be centered above the tile
  var label_position = tile_position * Vector3(Global.CELL_WIDTH, Global.CELL_HEIGHT, Global.CELL_DEPTH)
  label_position += Vector3(Global.CELL_WIDTH / 2, Global.CELL_HEIGHT + 0.1, Global.CELL_DEPTH / 2)
  label.global_position = label_position
  
  
  # Rotate the label to face upwards
  label.rotation_degrees = Vector3(-90, 0, 0)
  
  add_child(label)
  # add method to label to call 


  # Optional: Print the global position for debugging
  print("Label global position:", label.global_position)