# StateManager.gd
extends Node
class_name StateManager

var state_stack = []

func push_state(state):
	if state_stack.size() > 0:
		state_stack[-1].pause_state()
	state_stack.append(state)
	state.enter_state()

func pop_state():
	if state_stack.size() > 0:
		var state = state_stack.pop()
		state.exit_state()
		if state_stack.size() > 0:
			state_stack[-1].resume_state()

func get_current_state():
	if state_stack.size() > 0:
		return state_stack[-1]
	return null
