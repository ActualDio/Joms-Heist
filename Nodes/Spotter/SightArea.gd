extends Polygon2D

var spotter;
# Called when the node enters the scene tree for the first time.
func _ready():
	spotter = get_parent();
	set_color(Color(spotter.default_color, spotter.alpha));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	polygon = spotter.vertices;


func _on_spotter_player_entered():
	set_color(Color(spotter.caught_color, spotter.alpha));


func _on_spotter_player_exited():
	set_color(Color(spotter.default_color, spotter.alpha));
