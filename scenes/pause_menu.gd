extends Control


func _ready() -> void:
	hide()
	$Settings.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause", false, true):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused



func _on_pause_pressed() -> void:
	hide()
	$Settings.hide()
	get_tree().paused = false


func _on_settings_pressed() -> void:
	$Settings.show()


func _on_quit_pressed() -> void:
	get_tree().quit()
