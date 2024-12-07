extends Camera2D
class_name CoolCamera

var prevTarget : Vector2 = position;
var target: Vector2 = position :
	set(value):
		prevTarget = target;
		target = value;

var prevTargetZoom : Vector2 = Vector2(2.0,2.0);
var targetZoom : Vector2 = Vector2(2.0,2.0) :
	set(value):
		prevTargetZoom = targetZoom;
		targetZoom = value;

var time = 0.0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position != target || zoom != targetZoom:
		time = clampf(time + delta * 2.0,0.0,1.0);
		position = prevTarget.lerp(target,time);
		zoom = prevTargetZoom.lerp(targetZoom,time);
	else:
		time = 0.0;
