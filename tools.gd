extends Node
class_name Tools

func find_node_by_name(root, name):
	if(root.get_name() == name): 
		return root
	
	for child in root.get_children():
		if(child.get_name() == name):
			return child

		var found = find_node_by_name(child, name)
		if(found): 
			return found

	return null

func get_root(node):
#	root można wywołać przez get_tree().get_root()
	return null
	
func get_player(node):
#	nazwa playera to "Player"
	return null
	
func load_scene(scene_name):
	var stringText = "res://" + scene_name + ".tscn"
	var found = load(stringText)
	return found
	
func viewport_size(node):
	return get_root(node).get_viewport().size