# InputBuffer.gd
extends Resource
class_name InputBuffer

# Maximum number of buffered inputs
@export var max_buffer_size: int = 1

# Queue to store buffered inputs
var input_queue: Array = []

func buffer_input(input_data) -> void:
	# Only buffer if we haven't reached the maximum buffer size
	if input_queue.size() < max_buffer_size:
		input_queue.append(input_data)

func get_buffered_input():
	if input_queue.size() > 0:
		return input_queue.pop_front()
	return null

func has_buffered_input() -> bool:
	return input_queue.size() > 0

func clear_buffer() -> void:
	input_queue.clear()
