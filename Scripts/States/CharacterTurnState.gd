extends State
class_name CharacterTurnState

func enter(_data = null):
  print("Entering Character Turn State")
  # Transition to SelectActionState
  StateMachine.change_state(SelectActionState.new())
