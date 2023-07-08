extends Camera2D

const ZOOM_MAX = Vector2(3,3)

const ZOOM_MIN = Vector2(1,1)

var is_dragging = false
var old_pos = null

func _ready():
	offset = get_viewport_rect().size /2

func _process(delta):
	if Input.is_action_just_released("ZoomInCam"):
		set_zoom(get_zoom() + Vector2(0.05, 0.05))
	if Input.is_action_just_released("ZoomOutCam"):
		set_zoom(get_zoom() - Vector2(0.05, 0.05))
	if is_dragging:
		if old_pos == null:
			old_pos = get_global_mouse_position()
		else:
			offset += old_pos - get_global_mouse_position()
			old_pos = get_global_mouse_position()
	
func _unhandled_input(event):
	if event.is_action_pressed("DragMap"):
		is_dragging = true
		return
	if event.is_action_released("DragMap"):
		is_dragging = false
		old_pos = null
		




func _on_reset_viewport_pressed():
	offset = get_viewport_rect().size / 2
	set_zoom(Vector2(1,1))
