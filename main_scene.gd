extends Node2D

var _tools = Tools.new()

func _ready():
	print('user save is here: ' + str(OS.get_user_data_dir()))
	prepare_player()
#	save_game()
#	load_game()
	
func prepare_player():
	var found = _tools.load_scene("Player")
	var backgroundDuplicate = found.instance()
	var root = _tools.get_root(self)
	_tools.get_root(self).call_deferred("add_child", backgroundDuplicate)


func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        save_game()
        get_tree().quit()
		
		
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var root_children = _tools.get_root(self).get_children()
	for child in root_children:
		var save_nodes = child.get_tree().get_nodes_in_group("Persist")
		for i in save_nodes:
			var dataToSave = i.get_save()
			save_game.store_line(to_json(dataToSave))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

    # We need to revert the game state so we're not cloning objects
    # during loading. This will vary wildly depending on the needs of a
    # project, so take care with this step.
    # For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

    # Load the file line by line and process that dictionary to restore
    # the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line == null:
			continue 
        # Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(current_line["filename"]).instance()
		get_node(current_line["parent"]).call_deferred("add_child",new_object) 
#		get_node(current_line["parent"]).add_child(new_object)
        #new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
        # Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, current_line[i])
	save_game.close()
