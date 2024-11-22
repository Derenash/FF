# UIManager.gd
extends Node

# Dictionary to store UI references
# Dictionary[String, Control]
var ui_layers: Dictionary = {}
var current_ui: Control = null

func show_ui(ui_name: String, data: Dictionary = {}) -> void:
	if current_ui:
		hide_ui()
	if ui_layers.has(ui_name):
		current_ui = ui_layers[ui_name]
		current_ui.visible = true
		current_ui.call("activate", data)
	else:
		print("UI not found: " + ui_name)

func hide_ui() -> void:
	if current_ui:
		current_ui.call("deactivate")
		current_ui.visible = false
		current_ui = null

func register_ui(ui_name: String, ui_node: Control) -> void:
	ui_layers[ui_name] = ui_node
	ui_node.visible = false
