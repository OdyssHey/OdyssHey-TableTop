extends Node2D

var dice = preload("res://Dice/Dice.tscn")

func _ready():
	$UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.add_filter("*.png, *.jfif, *.jpeg, *.jpg","png, jfif, jpeg, jpg")
	$UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.connect("file_selected", on_file_selected)
	if multiplayer.is_server():
		Global.MJ_rand.seed = int(Time.get_datetime_string_from_system(false,true))
		$UI/AdminBoxContainer.show()


func _on_importmap_pressed():
	$UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Importmap/NativeFileDialog.show()
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
		$UI/AdminBoxContainer.position.x = - $UI/AdminBoxContainer/PanelContainer.size.x
		$"UI/AdminBoxContainer/Hide UI".text = " > "
		is_hide = true
	else:
		$UI/AdminBoxContainer.position.x = 0
		is_hide = false
		$"UI/AdminBoxContainer/Hide UI".text = " < "




func _on_launch_dice_button_pressed():
	$UI/DiceLayer.show()
	$UI/MarginContainer/VBoxContainer/LaunchDiceButton.set_disabled(true)



func _on_validate_dice_pressed():
	$UI/DiceLayer.hide()
	var NBDice = int($UI/DiceLayer/MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text)
	var MaxValue = int($UI/DiceLayer/MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text)
	$UI/PanelContainer/VBoxContainer/Button.show()
	$UI/PanelContainer/VBoxContainer/Button.set_disabled(true)
	rpc("launch_dice",NBDice,MaxValue)
	await get_tree().create_timer(1.5).timeout
	$UI/PanelContainer/VBoxContainer/Button.set_disabled(false)


@rpc("any_peer","call_local")
func launch_dice(nb:int,maxVal:int):
	$UI/DiceLayer.hide()
	$UI/MarginContainer/VBoxContainer/LaunchDiceButton.set_disabled(true)
	$UI/PanelContainer.show()
	for i in range(nb):
		$UI/PanelContainer/VBoxContainer/DiceBoxContainer.add_child(dice.instantiate())
	var val = 0
	$UI/LogUI/PanelContainer/LogText.text += Global.get_user_from_ID(multiplayer.get_remote_sender_id()).getPseudo() + " a lancé(e) un/des dé(s) : "
	for elem in $UI/PanelContainer/VBoxContainer/DiceBoxContainer.get_children():
		$UI/LogUI/PanelContainer/LogText.text += str(elem.launch_dice(maxVal)) + ", "
		val += elem.launch_dice(maxVal)
	$UI/LogUI/PanelContainer/LogText.text += "pour un total de " + str(val) + "!\n"
	if multiplayer.is_server():
		$UI/PanelContainer/VBoxContainer/Button.show()
		$UI/PanelContainer/VBoxContainer/Button.set_disabled(true)
		await get_tree().create_timer(1.5).timeout
		$UI/PanelContainer/VBoxContainer/Button.set_disabled(false)

func _on_button_pressed():
	rpc("closeDiceUI")

@rpc("any_peer","call_local")
func closeDiceUI():
	for elem in $UI/PanelContainer/VBoxContainer/DiceBoxContainer.get_children():
		elem.queue_free()
	$UI/PanelContainer/VBoxContainer/Button.hide()
	$UI/PanelContainer.hide()
	$UI/MarginContainer/VBoxContainer/LaunchDiceButton.set_disabled(false)
	
	


func _on_admin_launch_dice_pressed():
	if $UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer.is_visible():
		$UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer.hide()
	else:
		$UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer.show()
		
func _process(_delta):
	if Input.is_action_just_released("escapeMenu") && $UI/DiceLayer.is_visible():
		$UI/DiceLayer.hide()
		$UI/MarginContainer/VBoxContainer/LaunchDiceButton.set_disabled(false)


func _on_admin_validate_dice_pressed():
	$UI/LogUI/PanelContainer/LogText.text += Global.pseudo + " a lancé(e) un/des dé(s) caché(s) : "
	var val = 0
	for i in range(int($UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text)):
		var elem:int = Global.MJ_rand.randi_range(1, $UI/AdminBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.get_text().to_int())
		$UI/LogUI/PanelContainer/LogText.text += str(elem) + ", "
		val += elem
	$UI/LogUI/PanelContainer/LogText.text += "pour un total de " + str(val) + "!\n"
	pass # Replace with function body.
