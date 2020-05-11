extends Spatial


# Declare member variables here. Examples:
# var a = 2
var t = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	if t > 1:
		var b = $"../MineFactory/activebullets/MineBullet"
		$"../MineFactory/activebullets".remove_child(b)
		$"../MineFactory/pools/bullet".add_child(b)
		queue_free()
#	pass
