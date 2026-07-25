extends Control

func _ready() -> void:
	$Settings.hide()
	$CreditsLabel.hide()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_settings_button_pressed() -> void:
	$Settings.show()


func _on_credits_button_pressed() -> void:
	$CreditsLabel.visible = !$CreditsLabel.visible
