extends VBoxContainer


func _ready():
	position.y = -$PanelContainer/LogText.size.y


var is_hide = true

func _on_button_pressed():
	if !is_hide:
		position.y = -$PanelContainer/LogText.size.y
		$HideUI.text = "  ▼  "
		is_hide = true
	else:
		position.y = 0
		$HideUI.text = "  ▲  "
		is_hide = false
