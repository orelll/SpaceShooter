extends HBoxContainer

signal loaded
var _tools = Tools.new()

func _ready():
	var player =  _tools.get_player(self)
	player.change_energy(100)
	
func _on_EnergyGauge_value_changed(value):
	$EnergyGauge.value = value
	$Container/Background/EnergyValue.text = str(value)
	
