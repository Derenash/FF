# BattleState.gd
extends State

var current_state: State
var states = {
  "UnitSelection": preload("res://Scripts/States/BattleState/UnitSelectionState.gd"),
  "ActionSelection": preload("res://Scripts/States/BattleState/ActionSelectionState.gd"),
    "Movement": preload("res://Scripts/States/BattleState/MovementState.gd"),
    "Attack": preload("res://Scripts/States/BattleState/AttackState.gd"),
    "SkillSelection": preload("res://Scripts/States/BattleState/SkillSelectionState.gd"),
      "SkillUseState": preload("res://Scripts/States/BattleState/SkillUseState.gd"),
  
  "DirectionalState": preload("res://Scripts/States/BattleState/DirectionalState.gd"),
  "ConfirmationState": preload("res://Scripts/States/BattleState/ConfirmationState.gd"),
}

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
