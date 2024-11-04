extends Node

var strength = 1000
var DECREMENT_VALUE = 1
var GameActive = true
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load highscore from file
	Global.highscore = int(Global.read_from_file(Global.file))
	
	# ambient sound
	if !Ambient.playing:
		Ambient.playing = true
	
	# set timer initial
	$TimerLabel.text = str(strength)
	
	# pause scene
	get_tree().paused = true
	
	# display starting text
	$GameStartingText.set_text("   Ready...")
	await get_tree().create_timer(1).timeout
	$GameStartingText.set_text("    Set...")
	await get_tree().create_timer(1).timeout
	$GameStartingText.set_text("Click Away!")
	
	# start timer
	$Timer.start()
	
	# continue scene
	get_tree().paused = false
	
	# play animations for sun
	$Sun.play("sunon")
	
	# set key presses score text
	$KeyPressesLabel.text = "Score: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# set score and timer labels
	$KeyPressesLabel.text = "Score: " + str(score)
	$TimerLabel.text = str(strength)
	
	# if game is active
	if GameActive == true:
		strength = strength - DECREMENT_VALUE
		if strength <= 0:
			end_game()
			
			
# handle key presses
func _input(event):
	# check if game is active
	if GameActive == true:
		# if button/key is pressed
		if event.is_action_pressed("Interact"):
			# start playing frame of animation
			$StickMcGee.play("onthemove")
			$StickMcGee/Boulder.play("bouldermove")
			
			# increment timer by 20
			strength = strength + 20
			
			# increment score by 1
			score = score + 1


# end of game function
func end_game():
	# set game to inactive
	GameActive = false
	
	# hide the timer label
	$TimerLabel.hide()
	
	# if score is better than previous high score
	if score > Global.highscore:
		# write to local file
		Global.write_to_file(Global.file, str(score))
		# set new high score
		Global.highscore = score
		
		
	# update highscore text
	$ScoreLabel.text = "Highscore: " + str(Global.highscore) + "\n" + "Lastscore: " + str(score)
	
	# show new attempt button
	$NewAttemptButton.show()
	
	# show quit to main button
	$QuitToMainButton.show()


# play again button pressed
func _on_new_attempt_button_pressed() -> void:
	ButtonSound.play()
	$NewAttemptButton.disabled = true
	$QuitToMainButton.disabled = true
	await ButtonSound.finished
	# reload game scene
	get_tree().reload_current_scene()
	

# quit to main button pressed
func _on_quit_to_main_button_pressed() -> void:
	ButtonSound.play()
	$QuitToMainButton.disabled = true
	$NewAttemptButton.disabled = true
	await ButtonSound.finished
	get_tree().change_scene_to_file("res://main_scene.tscn")


# on timer timeout
func _on_timer_timeout() -> void:
	$GameStartingText.hide()
