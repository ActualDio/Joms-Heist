extends Node2D
class_name Room;

@export var size : Vector2 = Vector2(576,324);
@export var cameraPos : Vector2 = Vector2(288,162);
@export_range(0.5,3.0) var cameraZoom : float = 2.0;

signal activated
signal disabled
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable();

func activate():
	process_mode = ProcessMode.PROCESS_MODE_PAUSABLE;
	
func disable():
	process_mode = ProcessMode.PROCESS_MODE_DISABLED;


func _on_room_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		activate();
		emit_signal("activated");


func _on_room_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		disable();
		emit_signal("disabled");
