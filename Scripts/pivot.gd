extends Marker3D

const ROTATION_DEGREES: float = 90.0
const ROTATION_FRAME_DURATION: float = 1 # Duration in seconds
const INITIAL_ROTATION := Vector3(60.0, 45.0, 0)

var rotating_direction: float = 0
var rotation_time_elapsed: float = 0

var start_rotation_y: float = 0
var target_rotation_y: float = 0

# Instance of the InputBuffer component
var input_buffer := InputBuffer.new()

func _ready() -> void:
	rotation_degrees = INITIAL_ROTATION

func _process(delta: float) -> void:
	rotate_input_handler()

	if is_rotating():
		rotate_pivot(delta)
	else:
		stop_rotating()

func rotate_input_handler() -> void:
	if not is_rotating():
		if Input.is_action_just_pressed("camera_translate_left"):
			start_rotation(-1.0)
		elif Input.is_action_just_pressed("camera_translate_right"):
			start_rotation(1.0)
	else:
		# Buffer input while rotating
		if Input.is_action_just_pressed("camera_translate_left"):
			input_buffer.buffer_input(-1.0)
		elif Input.is_action_just_pressed("camera_translate_right"):
			input_buffer.buffer_input(1.0)

func start_rotation(direction: float) -> void:
	rotating_direction = direction
	rotation_time_elapsed = 0

	# Store the starting rotation angle
	start_rotation_y = rotation_degrees.y
	# Calculate the target rotation angle
	target_rotation_y = start_rotation_y + direction * ROTATION_DEGREES

func is_rotating() -> bool:
	return rotating_direction != 0 and rotation_time_elapsed < ROTATION_FRAME_DURATION

func stop_rotating() -> void:
	rotating_direction = 0
	rotation_time_elapsed = 0

	# Process buffered input if available
	if input_buffer.has_buffered_input():
		var next_direction = input_buffer.get_buffered_input()
		start_rotation(next_direction)

func rotate_pivot(delta: float) -> void:
	rotation_time_elapsed += delta
	var t = rotation_time_elapsed / ROTATION_FRAME_DURATION
	t = clamp(t, 0, 1)

	# Apply the easing function
	var eased_t = ease_in_out_quad(t)
	# var eased_t = ease_in_out_cubic(t)

	# Interpolate between the start and target rotations
	var current_rotation_y = lerp(start_rotation_y, target_rotation_y, eased_t)
	rotation_degrees.y = current_rotation_y

# Easing Functions

func ease_in_out_quad(t: float) -> float:
	if t < 0.5:
		return 2 * t * t
	else:
		return -1 + (4 - 2 * t) * t

func ease_in_out_cubic(t: float) -> float:
	if t < 0.5:
		return 4 * t * t * t
	else:
		return (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
