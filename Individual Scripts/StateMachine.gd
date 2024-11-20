var current_state: State

func _ready():
  change_state(VoidState.new())

func change_state(new_state: State):
  if current_state:
    current_state.exit()
  current_state = new_state
  current_state.state_machine = self # Allow state to change states
  current_state.enter()

func _process(delta):
  if current_state:
    current_state.update(delta)
