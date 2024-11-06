extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load highscore from file
	Global.highscore = int(Global.read_from_file(Global.file))
	$ScoreLabel.text = "Highscore: " + str(Global.highscore)
	if Global.gamemode == "normal":
		$GamemodeButton.text = "Gamemode: Normal"
	elif Global.gamemode == "randomized":
		$GamemodeButton.text = "Gamemode: Randomized"

# new attempt button pressed
func _on_button_pressed() -> void:
	ButtonSound.play()
	$NewAttemptButton.disabled = true
	#await ButtonSound.finished
	get_tree().change_scene_to_file("res://game.tscn")


func _on_gamemode_button_pressed() -> void:
	if Global.gamemode == "normal":
		Global.gamemode = "randomized"
		$GamemodeButton.text = "Gamemode: Randomized"
	elif Global.gamemode == "randomized":
		Global.gamemode = "normal"
		$GamemodeButton.text = "Gamemode: Normal"
