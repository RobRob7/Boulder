extends Node

var strength = 1000
var DECREMENT_VALUE = 1
var GameActive = true
var score = 0
var random_chars = []

# Constants for the characters we can use
const ALPHABETS = "abcdefghijklmnopqrstuvwxyz"
const NUMERALS = "0123456789"
const SPACE = " "
const CHAR_SET = ALPHABETS + NUMERALS + SPACE
const RANDOM_ARRAY_NUM = 1000

func generate_random_character_array(size: int) -> Array:
	var result = []
	var rng = RandomNumberGenerator.new()
	rng.randomize()  # Seed the random number generator

	for i in range(size):
		var random_index = rng.randf_range(0, CHAR_SET.length())
		result.append(CHAR_SET[random_index])
		
	return result

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load highscore from file
	Global.highscore = int(Global.read_from_file(Global.file))
	random_chars = generate_random_character_array(RANDOM_ARRAY_NUM)
	
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
	
	# Display the random Character
	if Global.gamemode == "randomized":
		if random_chars[0] == " ":
			$DisplayCharacter.text = "SPACE"
		else:
			$DisplayCharacter.text = random_chars[0]
		if random_chars.size() > 0:
			random_chars.remove_at(0)
	else:
		$DisplayCharacter.text = " Press SPACE"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# set score, timer and character labels
	$KeyPressesLabel.text = "Score: " + str(score)
	$TimerLabel.text = str(strength)
	if Global.gamemode == "randomized":
		if random_chars[0] == " ":
			$DisplayCharacter.text = "     SPACE"
		else:
			$DisplayCharacter.text = "         " + random_chars[0]
	
	if random_chars.size() < 50:
		random_chars.append_array(generate_random_character_array(RANDOM_ARRAY_NUM))
	
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
		if (event.is_action_pressed($DisplayCharacter.text.capitalize()) and Global.gamemode == "randomized") or ($DisplayCharacter.text=="     SPACE" and (event.is_action_pressed("Interact") and Global.gamemode == "randomized")) or (Global.gamemode == "normal" and event.is_action_pressed("Interact")):
			# start playing frame of animation
			$StickMcGee.play("onthemove")
			$StickMcGee/Boulder.play("bouldermove")
			
			# increment timer by 15
			if Global.gamemode == "normal":
				strength = strength + 15
			else:
				strength = strength + 100
			
			# increment score by 1
			score = score + 1
			
			# remove first character from character array
			if random_chars.size() > 0:
				random_chars.remove_at(0)
			
			


# end of game function
func end_game():
	# set game to inactive
	GameActive = false
	
	# hide the timer label
	$TimerLabel.hide()
	$DisplayCharacter.hide()
	
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
	#await ButtonSound.finished
	# reload game scene
	get_tree().reload_current_scene()
	

# quit to main button pressed
func _on_quit_to_main_button_pressed() -> void:
	ButtonSound.play()
	$QuitToMainButton.disabled = true
	$NewAttemptButton.disabled = true
	#await ButtonSound.finished
	get_tree().change_scene_to_file("res://main_scene.tscn")


# on timer timeout
func _on_timer_timeout() -> void:
	$GameStartingText.hide()
