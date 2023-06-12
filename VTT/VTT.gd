extends Node2D

func _ready():
	$UI/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.add_filter("*.png, *.jfif, *.jpeg, *.jpg","png, jfif, jpeg, jpg")
	$UI/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.connect("file_selected", on_file_selected)
	if multiplayer.is_server():
		$UI/HBoxContainer.show()


func _on_importmap_pressed():
	$UI/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.show()
	pass # Replace with function body.


func on_file_selected(path):
	var extension = path.get_extension()
	if ![".png",".jfif",".jpeg",".jpg"].has(extension):
		return
	var img_data = FileAccess.get_file_as_bytes(path)
	rpc("change_bg", img_data, extension)
	

@rpc("call_local")
func change_bg(byte_array, extension):
	var bg
	if extension != "jfif":
		if multiplayer.is_server():
			bg = FileAccess.open("user://game/" + Global.partie + "/bg." +  extension,FileAccess.WRITE)
		else:
			bg = FileAccess.open("user://actual_game/bg." + extension, FileAccess.WRITE)
	else:
		if multiplayer.is_server():
			bg = FileAccess.open("user://game/" + Global.partie + "/bg.jpeg",FileAccess.WRITE)
		else:
			bg = FileAccess.open("user://actual_game/bg.jpeg", FileAccess.WRITE)
		extension = "jpeg"
	bg.store_buffer(byte_array)
	bg.close()
	var img
	if multiplayer.is_server():
		img = Image.load_from_file("user://game/" + Global.partie + "/bg." +  extension)
	else:
		img = Image.load_from_file("user://actual_game/bg." + extension)
	var texture = ImageTexture.create_from_image(img)
	$MapLayer/map.set_texture(texture)

var is_hide = false

func _on_hide_ui_pressed():
	if !is_hide:
		$UI/HBoxContainer.position.x = - $UI/HBoxContainer/PanelContainer.size.x
		$"UI/HBoxContainer/Hide UI".text = " > "
		is_hide = true
	else:
		$UI/HBoxContainer.position.x = 0
		is_hide = false
		$"UI/HBoxContainer/Hide UI".text = " < "

