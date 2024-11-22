# BattleState.gd
extends State


const BS = Utils.BATTLE_STATE

var states = {
	BS.UNIT_SELECTION: preload("res://Scripts/States/BattleState/UnitSelectionState.gd"),
	BS.ACTION_SELECTION: preload("res://Scripts/States/BattleState/ActionSelectionState.gd"),
	BS.MOVEMENT: preload("res://Scripts/States/BattleState/MovementState.gd"),
	BS.ATTACK: preload("res://Scripts/States/BattleState/AttackState.gd"),
	BS.SKILL_SELECTION: preload("res://Scripts/States/BattleState/SkillSelectionState.gd"),
	BS.SKILL_USE: preload("res://Scripts/States/BattleState/SkillUseState.gd"),
	BS.DIRECTIONAL: preload("res://Scripts/States/BattleState/DirectionalState.gd"),
	BS.CONFIRMATION: preload("res://Scripts/States/BattleState/ConfirmationState.gd"),
}

var current_state: State

func enter_state(data = null):
	# Initialize battle
	change_state("UnitSelection")

func change_state(state_name, data = null):
	if current_state:
		current_state.exit_state()
	current_state = states[state_name].new()
	add_child(current_state)
	current_state.enter_state(data)

func handle_input(event):
	if current_state:
		current_state.handle_input(event)

func update(delta):
	if current_state:
		current_state.update(delta)
