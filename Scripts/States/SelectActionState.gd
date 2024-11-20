extends State
class_name SelectActionState

# Reference to the action UI
var action_ui

func enter(_data = null):
  print("Entering Select Action State")
  # Get the action UI node (adjust the path as necessary)
  action_ui = StateMachine.get_node("ActionUI")
  # Show the action UI
  action_ui.show_ui()
  # Connect to the action selected signal
  action_ui.connect("action_selected", self, "_on_action_selected")

func _on_action_selected(action_type):
  if action_type == "move":
    StateMachine.change_state(MovingState.new())
  elif action_type == "attack":
    StateMachine.change_state(AttackState.new())
  else:
    print("Unknown action selected:", action_type)

func _process(_delta: float):
  # Update logic if needed
  pass

func handle_input(_event: float):
  # Handle input if necessary
  pass

func exit():
  print("Exiting Select Action State")
  # Hide the action UI
  action_ui.hide_ui()
  # Disconnect the signal to prevent duplicates
  action_ui.disconnect("action_selected", self, "_on_action_selected")
