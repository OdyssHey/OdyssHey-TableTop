extends CanvasLayer



func _on_minus_nb_pressed():
	if int($MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) > 1 :
		$MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text = str(int($MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) - 1)
	pass # Replace with function body.


func _on_plus_nb_pressed():
	if int($MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) < 9999 :
		$MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text = str(int($MainMenu/MarginContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) + 1)
	pass # Replace with function body.


func _on_minus_val_pressed():
	if int($MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) > 1 :
		$MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text = str(int($MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) - 1)
	pass # Replace with function body.


func _on_plus_val_pressed():
	if int($MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) < 9999 :
		$MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text = str(int($MainMenu/MarginContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) + 1)
	pass # Replace with function body.
