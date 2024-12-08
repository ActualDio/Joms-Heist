extends Control

signal game_start;

func _ready() -> void:
	show();

func gameStart():
	for i in get_children():
		if i.name != "SpeedrunTimer":
			i.hide();
	emit_signal("game_start");
