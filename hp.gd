extends HBoxContainer

signal loaded
var _tools = Tools.new()

func _ready():
	var player =  _tools.get_player(self)
	player.change_hp(100)
	
func _on_HpGauge_value_changed(value):
	$HpGauge.value = value
	$Container/Background/HpValue.text = str(value)
	