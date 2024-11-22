extends Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * 1000

		var space_state = get_world_3d().direct_space_state
		var params = PhysicsRayQueryParameters3D.new()
		params.from = from
		params.to = to
		params.collide_with_areas = true
		params.collide_with_bodies = true
		var result = space_state.intersect_ray(params)

		if result and result.collider is GridMap:
			var gridmap = result.collider as GridMap
			var collision_point = result.position
			var local_position = gridmap.to_local(collision_point)
			var cell = gridmap.local_to_map(local_position)

			# Get the existing cell item index
			var item_index = gridmap.get_cell_item(cell)
			SignalBus.cell_clicked_by_mouse.emit(cell)
			print("Clicked cell coordinates: ", cell)
			if item_index != -1:
				# runs signal telling the cell was clicked
				pass # Implement color change logic here

		if result and result.collider is Character:
			var character = result.collider as Character
			var cell = character.current_pos
			SignalBus.unit_clicked_by_mouse.emit(cell)
			print("Clicked Character coordinates: ", cell)
