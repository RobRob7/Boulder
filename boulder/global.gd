extends Node

# highscore of player
var highscore = 0

# filepath to highscore
var file = "res://highscore.txt"

# write to file the highscore
func write_to_file(file_path: String, text: String):
	# Open the file for writing
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(text)  # Write the text to the file
		file.close()  # Close the file
	else:
		print("Error: Could not open the file for writing.")


# read from file the highschore
func read_from_file(file_path: String) -> String:
	# Open the file for reading
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
	if file:
		var content = file.get_as_text()  # Read the entire file content as a string
		file.close()  # Close the file
		return content
	else:
		print("Error: Could not open the file for reading.")
		return ""

	
