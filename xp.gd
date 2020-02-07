extends HBoxContainer

var _tools = Tools.new()

func _ready():
	var player =  _tools.get_player(self)
	player.change_xp(0)

func _on_XPGauge_value_changed(value):
	$XPGauge.value = value
	$Container/Background/XPValue.text = str(value)
