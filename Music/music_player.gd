extends AudioStreamPlayer

@export var maxVol = -16.0;

@export var startMuted = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if startMuted:
		volume_db = -80.0;
	else:
		volume_db = maxVol;
	MusicSyncer.connect("begin",play);
	MusicSyncer.connect("end",stop);

func fadeIn():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"volume_db",maxVol,1.0);

func fadeOut():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"volume_db",maxVol,-80.0);
