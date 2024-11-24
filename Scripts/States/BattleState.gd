# BattleState.gd
extends State


const BS = Utils.BATTLE_STATE

var states = {
}

var current_state: State

func enter_state():
	# Initialize battle
	change_state("UnitSelection")

func change_state(state_name):
	if current_state:
		current_state.exit_state()
	current_state = states[state_name].new()
	add_child(current_state)
	current_state.enter_state()

func handle_input(event):
	if current_state:
		current_state.handle_input(event)

func update(delta):
	if current_state:
		current_state.update(delta)
