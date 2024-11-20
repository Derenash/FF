extends Control

# Signal to notify the main game logic
@onready var move_button = $VBoxContainer/MoveButton
@onready var attack_button = $VBoxContainer/AttackButton

func _ready():
	# Initially hide the UI
	visible = false
	# Connect button signals
	move_button.connect("pressed", _on_MoveButton_pressed)
	attack_button.connect("pressed", _on_AttackButton_pressed)

func show_ui():
	visible = true

func hide_ui():
	visible = false

func _on_MoveButton_pressed():
	# hide_ui()
	emit_signal("action_selected", "move")

func _on_AttackButton_pressed():
	# hide_ui()
	emit_signal("action_selected", "attack")
