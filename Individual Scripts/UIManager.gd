# UIManager.gd
extends Node

# A dictionary to hold references to UI nodes
var ui_dict: Dictionary = {}

# Generalized method to invoke a method on a UI node
func run_ui_method(ui_name: String, method_name: String) -> void:
	var ui_node = ui_dict.get(ui_name)
	if ui_node:
		if ui_node.has_method(method_name):
			ui_node.call(method_name)
		else:
			print("UI node does not have method: " + method_name)
		
	else:
		print("UI not found: " + ui_name)

# Register a UI node with a unique name
func register_ui(ui_name: String, ui_node: BaseUI, start_hidden: bool = true) -> void:
	ui_dict[ui_name] = ui_node
	ui_node.visible = !start_hidden

# Show a specific UI by calling its 'activate' method
func show_ui(ui_name: String) -> void:
	run_ui_method(ui_name, "activate")

# Hide a specific UI
func hide_ui(ui_name: String) -> void:
	run_ui_method(ui_name, "deactivate")

# Hide all UIs
func hide_all() -> void:
	for ui_name in ui_dict.keys():
		hide_ui(ui_name)

# Show multiple UIs
func show_multiple(ui_names: Array) -> void:
	for ui_name in ui_names:
		show_ui(ui_name)

# Hide multiple UIs
func hide_multiple(ui_names: Array) -> void:
	for ui_name in ui_names:
		hide_ui(ui_name)
