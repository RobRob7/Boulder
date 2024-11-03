extends Node
var strength = 1000
var DECREMENT_VALUE = 1
var GameActive = false
var score = 0
var highscore = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScoreLabel.text = "Highscore: " + str(highscore) + "\n" + "Lastscore: " + str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TimerLabel.text = str(strength)
	if GameActive == true:
		strength = strength - DECREMENT_VALUE
		if strength == 0:
			end_game()
func _input(event):
	if GameActive == true:
		if event.is_action_pressed("Interact"):
			strength = strength + 1
			score = score + 1

func end_game():
	GameActive = false
	$GameTitle.show()
	$NewAttemptButton.show()
	$TimerLabel.hide()
	$GameStartingText.hide()
	$ScoreLabel.show()
	if score > highscore:
		highscore = score
	$ScoreLabel.text = "Highscore: " + str(highscore) + "\n" + "Lastscore: " + str(score)


func _on_button_pressed() -> void:
	$ScoreLabel.hide()
	$GameTitle.hide()
	$NewAttemptButton.hide()
	$GameStartingText.show()
	$GameStartingText.set_text("   Ready...")
	await get_tree().create_timer(1).timeout
	$GameStartingText.set_text("    Set...")
	await get_tree().create_timer(1).timeout
	$GameStartingText.set_text("Click Away!")
	$TimerLabel.show()
	score = 0
	strength = 1000
	GameActive = true
