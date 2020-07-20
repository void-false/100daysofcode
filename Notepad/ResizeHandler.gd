extends ColorRect

var following: bool = false
var last_mouse_pos: Vector2
var is_bottom: bool = false
var is_right: bool = false
var is_up: bool = false
var is_left: bool = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if following:
		if is_bottom:
			OS.window_size.y = get_global_mouse_position().y + rect_size.y - last_mouse_pos.y
		elif is_right:
			OS.window_size.x = get_global_mouse_position().x + rect_size.x - last_mouse_pos.x
		elif is_up:
			OS.window_size.y -= (get_global_mouse_position().y - last_mouse_pos.y)
			OS.window_position.y += get_global_mouse_position().y - last_mouse_pos.y
		elif is_left:
			OS.window_size.x -= (get_global_mouse_position().x - last_mouse_pos.x)
			OS.window_position.x += get_global_mouse_position().x - last_mouse_pos.x


func _on_BorderBottom_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			following = !following
			is_bottom = !is_bottom
			last_mouse_pos = get_local_mouse_position()


func _on_BorderRight_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			following = !following
			is_right = !is_right
			last_mouse_pos = get_local_mouse_position()


func _on_BorderUp_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			following = !following
			is_up = !is_up
			last_mouse_pos = get_local_mouse_position()


func _on_BorderLeft_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			following = !following
			is_left = !is_left
			last_mouse_pos = get_local_mouse_position()
