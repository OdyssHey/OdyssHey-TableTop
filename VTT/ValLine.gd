extends LineEdit
	
var oldText = "1"

func _on_text_changed(new_text: String):
	var oldCaretPos = caret_column
	if new_text.is_empty():
		oldText = new_text
		return
	if !new_text.is_valid_int():
		text = oldText
		caret_column = oldCaretPos - 1
	else:
		oldText = new_text


func _on_focus_exited():
	if text.is_empty():
		text = "1"
	pass # Replace with function body.
