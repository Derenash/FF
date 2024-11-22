extends Node

signal cell_clicked_by_mouse(cell: Vector3i)
signal unit_clicked_by_mouse(char: Character)
signal action_selected(action_type: Utils.ACTION_TYPE)
signal change_battle_state(state_name: String, data)
