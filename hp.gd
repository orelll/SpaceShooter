extends HBoxContainer

var _tools = Tools.new()

func _ready():
	var hpGauge = _tools.find_node_by_name(self, "HpGauge")
	var hpValueText = _tools.find_node_by_name(self, "HpValue")
	hpValueText.text = str(hpGauge.value)
	
func _on_HpGauge_value_changed(value):
	var hpValueText = _tools.find_node_by_name(self, "HpValue")
	hpValueText.text = str(value)
