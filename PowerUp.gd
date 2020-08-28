extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var type = "points"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide():
	$CollisionShape.disabled = true
	global_transform.origin = Vector3(0,-.2,0)
	

func setPUtype(_type):
	type = _type
	if type == "points":
		$Sphere_003.mesh.surface_get_material(0).set_shader_param("glow_color",Vector3(0,0,1))
	elif type == "upgrade":
		$Sphere_003.mesh.surface_get_material(0).set_shader_param("glow_color",Vector3(0,1,0))
	$CollisionShape.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
