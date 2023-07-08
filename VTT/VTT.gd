extends Node2D

var dice = preload("res://Dice/Dice.tscn")

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




func _on_launch_dice_button_pressed():
	$UI/DiceLayer.show()



func _on_validate_dice_pressed():
	$UI/DiceLayer.hide()
	var NBDice = int($UI/DiceLayer/MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text)
	var MaxValue = int($UI/DiceLayer/MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text)
	$UI/PanelContainer/VBoxContainer/Button.show()
	rpc("launch_dice",NBDice,MaxValue)


@rpc("any_peer","call_local")
func launch_dice(nb:int,maxVal:int):
	if multiplayer.is_server():
		$UI/PanelContainer/VBoxContainer/Button.show()
	$UI/PanelContainer.show()
	for i in range(nb):
		$UI/PanelContainer/VBoxContainer/DiceBoxContainer.add_child(dice.instantiate())
	var val = 0
	for elem in $UI/PanelContainer/VBoxContainer/DiceBoxContainer.get_children():
		val += elem.launch_dice(maxVal)
	print(val)

func _on_button_pressed():
	rpc("closeDiceUI")

@rpc("any_peer","call_local")
func closeDiceUI():
	for elem in $UI/PanelContainer/VBoxContainer/DiceBoxContainer.get_children():
		elem.queue_free()
	$UI/PanelContainer/VBoxContainer/Button.hide()
	$UI/PanelContainer.hide()



