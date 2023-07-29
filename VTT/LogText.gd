extends RichTextLabel

func _on_gui_input(event):
	if event.is_action_released("ZoomInCam"):
		get_viewport().set_input_as_handled()
	if event.is_action_released("ZoomOutCam"):
		get_viewport().set_input_as_handled()
