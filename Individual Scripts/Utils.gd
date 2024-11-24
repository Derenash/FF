extends Node

enum ACTION_TYPE {
	MOVE,
	ATTACK
}

enum STATE {
	VOID,
	CHARACTER_TURN,
	SELECT_ACTION,
	MOVING,
	ATTACK
}

enum BATTLE_STATE {
	UNIT_SELECTION,
	ACTION_SELECTION,
	MOVEMENT,
	ATTACK,
	SKILL_SELECTION,
	SKILL_USE,
	DIRECTIONAL,
	CONFIRMATION
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func load_states(base_path: String, state_names: Array) -> Dictionary:
	var states = {}
	for state_name in state_names:
		states[state_name] = load(base_path + state_name + ".gd")
	return states

func append_to_dict_array(dict: Dictionary, key, value) -> void:
	if not dict.has(key):
		dict[key] = []
	dict[key].append(value)