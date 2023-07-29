extends HBoxContainer



func _on_minus_nb_pressed():
	if int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) > 1 :
		$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text = str(int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) - 1)
pass # Replace with function body.

func _on_plus_nb_pressed():
	if int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) < 9999 :
		$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text = str(int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxNB/NBDice/NBLine.text) + 1)
	pass # Replace with function body.

func _on_minus_val_pressed():
	if int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) > 1 :
		$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text = str(int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) - 1)
	pass # Replace with function body.


func _on_plus_val_pressed():
	if int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) < 9999 :
		$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text = str(int($PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxVal/MaxValDice/ValLine.text) + 1)
	pass # Replace with function body.
