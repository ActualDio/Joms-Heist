extends Polygon2D


@export_color_no_alpha var caught_color : Color = Color("CRIMSON", 0.5);
@export_color_no_alpha var default_color : Color = Color("CHARTREUSE", 0.5);

var spotter;
# Called when the node enters the scene tree for the first time.
func _ready():
	spotter = get_parent();
	set_color(default_color);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_polygon(spotter.vertices);


func _on_spotter_player_entered():
	set_color(caught_color);


func _on_spotter_player_exited():
	set_color(default_color);
