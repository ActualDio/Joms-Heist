extends Camera2D
class_name CoolCamera

var target: Vector2 = position :
	set(value):
		target = value;
		targetChanged()

var targetZoom : Vector2 = Vector2(2.0,2.0) :
	set(value):
		targetZoom = value;
		zoomChanged();

@export var transitionSpeed = 0.4;


func targetChanged():
	var tween = get_tree().create_tween();
	tween.set_trans(tween.TRANS_QUAD);
	tween.set_ease(Tween.EASE_OUT);
	tween.tween_property(self,"position",target,transitionSpeed);

func zoomChanged():
	var tween = get_tree().create_tween();
	tween.set_trans(tween.TRANS_SINE);
	tween.set_ease(Tween.EASE_OUT);
	tween.tween_property(self,"zoom",targetZoom,transitionSpeed);
