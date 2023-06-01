extends PanelContainer

signal kick

func _on_user_kick_pressed():
	emit_signal("kick",get("metadata/peer_id"))
	pass # Replace with function body.
