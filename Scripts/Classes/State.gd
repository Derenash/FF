# State.gd
extends Node
class_name State

func enter_state():
	pass  # Called when the state becomes active

func exit_state():
	pass  # Called when the state is popped

func pause_state():
	pass  # Called when a new state is pushed on top

func resume_state():
	pass  # Called when returning to this state
