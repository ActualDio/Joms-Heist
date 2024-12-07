extends Node2D

@export var player : Player;

@export var camera : CoolCamera;

var currentRoom : Room;
var previousCurrentRoom : Room;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for r in get_children():
		if r is Room:
			r.connect("activated",roomEntered.bind(r));
			r.connect("disabled",roomExited.bind(r));
			r.connect("cameraUpdate",setNewCameraTarget)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func roomEntered(room : Room):
	previousCurrentRoom = currentRoom;
	currentRoom = room;
	setNewCameraTarget();

func setNewCameraTarget():
	camera.target = currentRoom.cameraPos + currentRoom.position;
	camera.targetZoom = Vector2(currentRoom.cameraZoom,currentRoom.cameraZoom);

func roomExited(room : Room):
	if currentRoom == room:
		#If the player just exited the room without activating a new one
		#Contengency plan: This happens if the player just BARELY enters one room without fully leaving the other.
		currentRoom = previousCurrentRoom;
		previousCurrentRoom = room;
		if currentRoom: #if this is null, the player has just loaded into a room, and then closed the scene somehow.
			setNewCameraTarget();
