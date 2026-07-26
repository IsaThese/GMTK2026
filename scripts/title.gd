extends Control


@onready var bike_enabled = Controls.TotalFails >= Controls.BikeUnlock


func _ready() -> void:
	$Settings.hide()
	$CreditsLabel.hide()
	
	$BikeLock.visible = !bike_enabled
	$BikeButton.visible = bike_enabled


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_settings_button_pressed() -> void:
	$Settings.show()


func _on_credits_button_pressed() -> void:
	$CreditsLabel.visible = !$CreditsLabel.visible


func _on_car_button_pressed() -> void:
	Controls.BikeCity = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_bike_button_pressed() -> void:
	Controls.BikeCity = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")
