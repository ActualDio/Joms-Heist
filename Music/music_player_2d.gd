extends AudioStreamPlayer2D

func _ready() -> void:
	MusicSyncer.connect("begin",play);
