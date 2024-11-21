extends State
class_name AttackState

func enter(_data = null):
	print("Entering Attack State")
	# Initialize attack logic
	var player = StateMachine.get_node("Player")
	player.prepare_attack()

func _process(_delta: float):
	# Monitor attack progress
	var player = StateMachine.get_node("Player")
	if player.attack_completed:
		# Transition back to the Void State or next appropriate state
		StateMachine.change_state(VoidState.new())

func handle_input(_event: InputEvent):
	# Handle input related to attacking
	pass

func exit():
	print("Exiting Attack State")
	# Cleanup attack logic
	var player = StateMachine.get_node("Player")
	player.finish_attack()
