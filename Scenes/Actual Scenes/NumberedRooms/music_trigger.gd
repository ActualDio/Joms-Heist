extends Area2D
const DefaultBusVolume = -8.0;
@export_enum("NULL","Bass","Hi-Hat","Vibes") var instrument = 2;
@export_enum("MUTE","PLAY") var trigger_type = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		trigger();

func trigger():
	AudioServer.set_bus_volume_db()
