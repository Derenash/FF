extends Node3D
class_name CustomAStar

# ======================================
# Variables
# ======================================

var astar = AStar2D.new()
var grid_map: GridMap
var walkable_positions: Dictionary = {}
var tile_positions_by_id: Dictionary = {}
var debug_mode: bool = false

# ======================================
# Main Functions
# ======================================

func _ready():
  pass

func initialize(new_grid_map: GridMap):
  grid_map = new_grid_map
  identify_walkable_positions()
  add_points_to_astar()
  connect_astar_points()

func get_connected_points(point_id: int) -> PackedInt64Array:
  return astar.get_point_connections(point_id)

func get_point_id_from_position(position_3d: Vector3) -> int:
  var column = walkable_positions.get(Vector2(position_3d.x, position_3d.z))
  if not column:
    return -1

  for tile in column:
    if tile["position"].y == position_3d.y - 1:
      return tile["id"]

  return -1

# func find_path(start_position: Vector3, end_position: Vector3) -> Array:
#   var open_set = {}
#   var closed_set = {}
#   var came_from = {}
#   var g_score = {}
#   var f_score = {}

#   var start_id = get_point_id_from_position(start_position)
#   var end_id = get_point_id_from_position(end_position)

#   if start_id == -1 or end_id == -1:
#     print("Invalid start or end position")
#     return []

#   open_set[start_id] = true
#   g_score[start_id] = 0
#   f_score[start_id] = heuristic_cost_estimate(start_id, end_id)

#   while open_set.size() > 0:
#     var current = get_lowest_f_score(open_set, f_score)
#     if current == end_id:
#       return reconstruct_path(came_from, current)

#     open_set.erase(current)
#     closed_set[current] = true

#     for neighbor in astar.get_point_connections(current):
#       if neighbor in closed_set:
#         continue

#       var tentative_g_score = g_score[current] + distance_between(current, neighbor)

#       if neighbor not in open_set or tentative_g_score < g_score.get(neighbor, INF):
#         came_from[neighbor] = current
#         g_score[neighbor] = tentative_g_score
#         f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, end_id)
#         open_set[neighbor] = true

#   print("No path found")
#   return []

# func get_lowest_f_score(open_set, f_score) -> int:
#   var lowest = null
#   for node in open_set.keys():
#     if lowest == null or f_score[node] < f_score[lowest]:
#       lowest = node
#   return lowest

# func heuristic_cost_estimate(start_id: int, end_id: int) -> float:
#   var start_pos = tile_positions_by_id[start_id]
#   var end_pos = tile_positions_by_id[end_id]
#   return start_pos.distance_to(end_pos)

# func distance_between(from_id: int, to_id: int) -> float:
#   var from_pos = tile_positions_by_id[from_id]
#   var to_pos = tile_positions_by_id[to_id]
#   # Customize this function to add movement costs, penalties, etc.
#   return from_pos.distance_to(to_pos)

# func reconstruct_path(came_from, current) -> Array:
#   var total_path = [current]
#   while current in came_from:
#     current = came_from[current]
#     total_path.insert(0, current)
#   var path_positions = []
#   for point_id in total_path:
#     path_positions.append(tile_positions_by_id[point_id])
#   return path_positions


# ======================================
# Setup Functions
# ======================================

# Identifies walkable positions in a 3D grid.
# A position is walkable if it has at least 2 units of empty space above it.
func identify_walkable_positions() -> void:
  var tiles_grouped_by_column = group_tiles_by_column()
  find_walkable_heights_in_columns(tiles_grouped_by_column)

func add_points_to_astar() -> void:
  for column in walkable_positions:
    for tile in walkable_positions[column]:
      var tile_position_2d = Vector2(column.x, column.y)
      astar.add_point(tile["id"], tile_position_2d)
      if debug_mode:
        display_tile_id(tile["position"], str(tile["id"]))

func connect_astar_points() -> void:
  for column in walkable_positions:
    for tile in walkable_positions[column]:
      var tile_id = tile["id"]
      var neighbor_ids = get_neighbor_ids_for_position(tile["position"])
      for neighbor_id in neighbor_ids:
        astar.connect_points(tile_id, neighbor_id)

# ======================================
# Pathfinding Functions
# ======================================

func get_neighbor_ids_for_position(tile_position: Vector3) -> Array[int]:
  var position_2d = Vector2(tile_position.x, tile_position.z)
  var neighbor_ids: Array[int] = []
  var directions: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
  for direction in directions:
    var neighbor_column = position_2d + direction
    if neighbor_column in walkable_positions:
      for neighbor_tile in walkable_positions[neighbor_column]:
        print("Neighbor Tile: ", neighbor_tile)
        print("Column: ", neighbor_column)
        if is_path_clear_between_positions(tile_position, neighbor_tile["position"]):
          neighbor_ids.append(neighbor_tile["id"])

  return neighbor_ids

func is_path_clear_between_positions(current_pos: Vector3, neighbor_pos: Vector3) -> bool:
  var sorted_positions = sort_positions_by_descending_y(current_pos, neighbor_pos)
  var higher_pos = sorted_positions[0]
  var lower_pos = sorted_positions[1]

  if not are_cell_positions_valid([higher_pos, lower_pos]):
    return false

  var higher_world_pos = grid_map.map_to_local(higher_pos)
  var lower_world_pos = grid_map.map_to_local(lower_pos)
  var space_state = get_parent().get_world_3d().direct_space_state

  return are_rays_clear_between_positions(space_state, higher_world_pos, lower_world_pos)

func are_rays_clear_between_positions(space_state, start_pos: Vector3, end_pos: Vector3) -> bool:
  var horizontal_ray = create_ray_query_parameters(start_pos, end_pos, true)
  var vertical_ray = create_ray_query_parameters(start_pos, end_pos, false)

  return space_state.intersect_ray(horizontal_ray).is_empty() and space_state.intersect_ray(vertical_ray).is_empty()

# ======================================
# Utility Functions
# ======================================

func create_ray_query_parameters(higher_pos: Vector3, lower_pos: Vector3, is_horizontal: bool) -> PhysicsRayQueryParameters3D:
  var start_point: Vector3
  var end_point: Vector3
  if is_horizontal:
    start_point = Vector3(higher_pos.x, higher_pos.y + 3, higher_pos.z)
    end_point = Vector3(lower_pos.x, higher_pos.y + 3, lower_pos.z)
  else:
    start_point = Vector3(lower_pos.x, higher_pos.y + 3, lower_pos.z)
    end_point = Vector3(lower_pos.x, lower_pos.y + 3, lower_pos.z)
  var ray = PhysicsRayQueryParameters3D.create(start_point, end_point)

  if debug_mode:
    draw_debug_ray(start_point, end_point, is_horizontal)

  return ray

func sort_positions_by_descending_y(position_a: Vector3, position_b: Vector3) -> Array:
  if position_a.y >= position_b.y:
    return [position_a, position_b]
  else:
    return [position_b, position_a]

func are_cell_positions_valid(positions: Array[Vector3]) -> bool:
  for pos in positions:
    if grid_map.get_cell_item(pos) == GridMap.INVALID_CELL_ITEM:
      print(pos, " is not a valid cell")
      return false
  return true

func group_tiles_by_column() -> Dictionary:
  var tiles_by_column: Dictionary = {}
  for tile in grid_map.get_used_cells():
    var column_pos = Vector2(tile.x, tile.z)
    Utils.append_to_dict_array(tiles_by_column, column_pos, tile.y)

  for column_pos in tiles_by_column:
    tiles_by_column[column_pos].sort()

  return tiles_by_column

func find_walkable_heights_in_columns(tiles_by_column: Dictionary) -> void:
  var tile_id: int = 0

  for column_pos in tiles_by_column:
    var add_tile_to_walkable_positions = func(y):
      var pos = Vector3(column_pos.x, y, column_pos.y)
      Utils.append_to_dict_array(walkable_positions, column_pos, {"position": pos, "id": tile_id})
      tile_positions_by_id[tile_id] = pos

    var heights = tiles_by_column[column_pos]
    if heights.is_empty():
      continue

    var current_height = heights[0]

    for next_height in heights.slice(1):
      if has_minimum_space_to_walk(current_height, next_height):
        add_tile_to_walkable_positions.call(current_height)
        tile_id += 1
      current_height = next_height

    # Last height is always walkable (nothing above it)
    add_tile_to_walkable_positions.call(current_height)
    tile_id += 1

func has_minimum_space_to_walk(lower_height: float, higher_height: float) -> bool:
  return higher_height - lower_height > Global.MINIMUM_SPACE_TO_WALK

func is_movement_valid_between_points(id1: int, id2: int, jump_strength: float):
  return abs(tile_positions_by_id[id1] - tile_positions_by_id[id2]) <= jump_strength

# ======================================
# Debug Functions
# ======================================

func draw_debug_ray(start_point: Vector3, end_point: Vector3, is_horizontal: bool):
  var mesh = ImmediateMesh.new()
  var material = StandardMaterial3D.new()
  material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

  # Set color based on ray type
  if is_horizontal:
    material.albedo_color = Color(1, 0, 0) # Red for horizontal rays
  else:
    material.albedo_color = Color(0, 0, 1) # Blue for vertical rays

  # Begin drawing lines
  mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
  mesh.surface_add_vertex(start_point)
  mesh.surface_add_vertex(end_point)
  mesh.surface_end()

  # Create a MeshInstance3D to display the mesh
  var mesh_instance = MeshInstance3D.new()
  mesh_instance.mesh = mesh
  add_child(mesh_instance)

func display_tile_id(tile_position: Vector3, tile_id: String):
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
  label.position = label_position

  # Rotate the label to face upwards
  label.rotation_degrees = Vector3(-90, 0, 0)

  add_child(label)
