extends AudioStreamPlayer2D

func _ready() -> void:
	MusicSyncer.connect("begin",play);
	MusicSyncer.connect("end",stop);
