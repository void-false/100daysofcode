extends ColorRect

var following: bool = false
var last_mouse_pos: Vector2

func _ready() -> void:
	pass


func _process(delta: float) -> void:

	if following:
		OS.window_size.y = get_global_mouse_position().y + rect_size.y - last_mouse_pos.y


func _on_BorderBottom_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			following = !following
			last_mouse_pos = get_local_mouse_position()
