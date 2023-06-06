extends Node2D



func _on_importmap_pressed():
	$VTTLayer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.add_filter("*.png, *.jfif, *.jpeg, *.jpg, *.gif","png, jfif, jpeg, jpg, gif")
	$VTTLayer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.show()
	$VTTLayer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.connect("file_selected", on_file_selected)
	pass # Replace with function body.


func on_file_selected(path):
	var file = FileAccess.open(path,FileAccess.READ)
	var extension = path.get_extension()
	var img_data = file.get_file_as_bytes(path)
	file.close()
	rpc("change_bg", img_data, extension)
	

@rpc("call_local")
func change_bg(byte_array, extension):
	var bg
	if multiplayer.is_server():
		bg = FileAccess.open("user://game/" + Global.partie + "/bg." +  extension,FileAccess.WRITE)
	else:
		bg = FileAccess.open("user://actual_game/bg." + extension, FileAccess.WRITE)
	bg.store_buffer(byte_array)
	bg.close()
	var img
	if multiplayer.is_server():
		img = load("user://game/" + Global.partie + "/bg." +  extension)
	else:
		img = load("user://actual_game/bg." + extension)
	$VTTLayer/map.set_texture(img)
		
