extends HBoxContainer

var _tools = Tools.new()

func _ready():
	var xpGauge = _tools.find_node_by_name(self, "XPGauge")
	var xpValueText = _tools.find_node_by_name(self, "XPValue")
	xpValueText.text = str(xpGauge.value)
