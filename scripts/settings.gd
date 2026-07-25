extends Control


signal closed


func _on_steering_controls_box_toggled(toggled_on: bool) -> void:
	Controls.UseSteering = toggled_on


func _on_close_button_pressed() -> void:
	visible = false
	emit_signal("closed")
