extends Node2D

var _tools = Tools.new()

func _ready():
	print('user save is here: ' + str(OS.get_user_data_dir()))
	prepare_player()
	
func prepare_player():
	var found = _tools.load_scene("Player")
	var backgroundDuplicate = found.instance()
	var root = _tools.get_root(self)
	_tools.get_root(self).call_deferred("add_child", backgroundDuplicate)

		

	

