extends State
class_name MovingState

func enter(_data = null):
	print("Entering Moving State")
	# Initialize movement logic
	var player = StateMachine.get_node("Player")
	player.enable_movement() # Custom method to allow player movement

func _process(_delta: float):
	# Check if movement is complete
	var player = StateMachine.get_node("Player")
	if player.has_reached_destination():
		# Transition back to the Void State or next appropriate state
		StateMachine.change_state(VoidState.new())

func handle_input(event):
	# Handle movement input
	var player = StateMachine.get_node("Player")
	player.handle_movement_input(event)

func exit():
	print("Exiting Moving State")
	# Cleanup movement logic
	var player = StateMachine.get_node("Player")
	player.disable_movement()
