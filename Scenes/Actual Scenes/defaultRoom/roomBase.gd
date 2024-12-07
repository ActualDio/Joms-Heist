@tool
extends Node2D
class_name Room;

@export var size : Vector2 = Vector2(576,320) :
	set(value):
		size = value;
		if Engine.is_editor_hint():
			queue_redraw();
			updateDetectorSize()
@export var cameraPos : Vector2 = Vector2(288,162):
	set(value):
		cameraPos = value;
		if Engine.is_editor_hint():
			queue_redraw();
@export_range(0.5,3.0) var cameraZoom : float = 2.0:
	set(value):
		cameraZoom = value;
		if Engine.is_editor_hint():
			queue_redraw();

@onready var cameraPosPerma = cameraPos;
@onready var cameraZoomPerma = cameraZoom;

signal activated
signal disabled
signal cameraUpdate
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		disable();

func activate():
	process_mode = ProcessMode.PROCESS_MODE_INHERIT;
	
func disable():
	process_mode = ProcessMode.PROCESS_MODE_DISABLED;

func updateDetectorSize():
	var shape = $RoomDetector/CollisionShape2D
	shape.shape.size = size;
	shape.position = size/2.0;

func _on_room_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		activate();
		emit_signal("activated");


func _on_room_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		disable();
		emit_signal("disabled");
		
func _draw() -> void:
	var windowSize = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"));
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO,size),Color.CORAL,false,3.0,false);
		draw_circle(cameraPos,25.0,Color.LIGHT_PINK,false,3.0,true);
		draw_rect(Rect2(cameraPos - Vector2((windowSize.x/cameraZoom)/2,(windowSize.y/cameraZoom)/2),windowSize/cameraZoom),Color.LIGHT_PINK,false,3.0,false);



func _on_radio_interacted(radioPos) -> void: #Connect this to ur radios
	cameraZoom = 3.0;
	cameraPos = radioPos;
	emit_signal("cameraUpdate");
	


func _on_text_event_finished() -> void: #Connect this to ur text events
	cameraZoom = cameraZoomPerma;
	cameraPos = cameraPosPerma;
	emit_signal("cameraUpdate");
