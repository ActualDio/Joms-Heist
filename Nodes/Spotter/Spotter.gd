@tool
extends Node2D

signal player_entered

signal player_exited
#Distance: The "Length" of the vision cone.

@export_range(0.,1.) var alpha : float = 0.5;
@export_color_no_alpha var caught_color : Color = Color("CRIMSON");
@export_color_no_alpha var default_color : Color = Color("CHARTREUSE");

@export_range(100,1000) var distance : float = 250.0 :
	set(value):
		for r in get_children():
			if r is RayCast2D:
				r.target_position = r.target_position.normalized()*value;
		distance = value;#if you don't know what this does, don't mess with this.

var vertices : PackedVector2Array;

#number of rays: The "Resolution" of the vision cone.
@export_range(3,105) var number_of_rays : int = 3 :
	set(value):
		var angleRad = deg_to_rad(angle)
		var halfAngleRad = angleRad / 2.0;
		vertices.clear();
		#Delete all raycasts
		for r in get_children():
			if r is RayCast2D:
				r.queue_free();
		#Create new raycasts and connect their signals and add them as children
		vertices.append(position);
		
		for i in value:
			var newRay = RayCast2D.new();
			add_child(newRay);
			newRay.target_position = Vector2.RIGHT.rotated(
				halfAngleRad - (angleRad/float(value - 1)) * i #if you don't understand this math, it SHOULD be making the angles of the new vectors fan out evenly.
			) * distance; #multiply by distance because it's length one, so it's already normalized.
			
			vertices.append(newRay.target_position);
		
		number_of_rays = value;
#Angle: Angle of vision cone.
@export_range(15.0,175.0) var angle = 45.0:
	set(value):
		angle = value;

var playerInCollider = false;
var sightArea : Polygon2D;
# Called when the node enters the scene tree for the first time.
func _ready():
	distance = distance; #just in case the numbers don't line up for some reason. If you're trying to mess with the vectors and things "snap back" to normal, this is why. Just use the export variables.
	sightArea = find_child("SightArea");
	sightArea.set_color(Color(default_color, alpha));
	
func _physics_process(_delta):
	var prevState = playerInCollider;
	
	playerInCollider = false;
	
	#initiates the visual detection area
	vertices.clear();
	vertices.append(position);
	
	for r in get_children():
		if r is RayCast2D:
			if r.is_colliding():
				if r.get_collider() is Player:
					playerInCollider = true;
				vertices.append(r.get_collision_normal());
			else:
				vertices.append(r.target_position);
	if playerInCollider != prevState:
		if playerInCollider:
			emit_signal("player_entered");
		else:
			emit_signal("player_exited");
	sightArea.set_polygon(vertices);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_entered() -> void:
	sightArea.set_color(Color(caught_color, alpha));


func _on_player_exited() -> void:
	sightArea.set_color(Color(default_color, alpha));
