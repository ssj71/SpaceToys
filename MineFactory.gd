extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = true
var level = 0
#TODO: gotta get these numbers AFTER they choose mode

const nuklevel = 8
var rng #this is shared with the gamemode
var prox = preload("res://proximitymine.tscn")
var plas = preload("res://plasmamine.tscn")
var lasr = preload("res://lasermine.tscn")
var nuke = preload("res://nuclearmine.tscn")
var bullet = preload("res://bullet.tscn")
var bulletmaterial
var dir = Vector3(0,0,0)
const bspeed = .17
#these must be set by the gamemode
var ship = null


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var a
	#$activemines.get_child(0).pool = $pools/prox #this is just when you have a test mine at init
	
	#populate pools
	for i in range(10):
		a = prox.instance()
		$pools/prox.add_child(a)
		a = plas.instance()
		$pools/plas.add_child(a)
		a = lasr.instance()
		$pools/lasr.add_child(a)
	for i in range(3):
		a = nuke.instance()
		$pools/nuke.add_child(a)
	for i in range(64):
		a = bullet.instance()
		$pools/bullet.add_child(a)
	#the factory does the glow animation on the bullets
	#so we grab the material here
	bulletmaterial = a.find_node("CSGSphere").material
	#fire bullet to make it compile that material
	$pools/bullet.remove_child(a)
	a.dir = Vector3(0,0,-.5)
	a.global_transform.origin = Vector3(0,1.5,.5)
	a.get_node("CollisionShape").disabled = false
	$activebullets.add_child(a)

func _process(delta):
	bulletglow(delta)
	
	for b in $activebullets.get_children():
		var c = b.move_and_collide(bspeed*delta*b.dir)
		if c:
			var name = c.collider.get_name()
			if name == "walls":
				$activebullets.remove_child(b)
				b.get_node("CollisionShape").disabled = true
				b.global_transform.origin = Vector3(0,-.25,0)
				$pools/bullet.add_child(b)
			elif name.match("*ship*"):
				c.collider.boom()

	if $activemines.get_child_count():
		for m in $activemines.get_children():
			m.process(delta)
	elif ship != null:
		nextlevel()

#this is no longer being used
func preview():
	#the first time a mine blows it takes a while to load the particles
	#so we force an explosion on startup
	var a = prox.instance()
	a.translation = Vector3(0,3,0)
	$activemines.add_child(a)
	a.pool = $pools/prox
	a.boom()
	
	a = plas.instance()
	a.t = a.period #make it shoot
	$activemines.add_child(a)
	a.pool = $pools/plas
	a.boom()
	
	a = lasr.instance()
	a.translate(Vector3(0,1,0))
	$activemines.add_child(a)
	a.pool = $pools/lasr
	a.boom()
	
	a = nuke.instance()
	a.translate(Vector3(0,1,-4))
	$activemines.add_child(a)
	a.pool = $pools/nuke
	a.boom()
	

func fire(from):
	var b
	if $pools/bullet.get_child_count():
		b = $pools/bullet.get_child(0)
		$pools/bullet.remove_child(b)
	else:
		b = bullet.instance()
	b.global_transform.origin = from
	b.get_node("CollisionShape").disabled = false
	if ship:
		b.dir = (ship.global_transform.origin - from).normalized()
		$activebullets.add_child(b)
		

func clearall():
	for m in $activemines.get_children():
		m.annihilate()
	level = 0

func nextlevel():
	level += 1
	if(level == 2):
		$"..".tut(3)
	$"../gamemode".newlevel(level)
	produce(level)

func saw(x, mn, mx, period):
	var rnge = mx - mn
	return fmod(x,period)/period*rnge + mn
	
func tri(x, mn, mx, period):
	var rnge = mx - mn
	var half = period/2.0
	return abs(fmod(x,period)-half)/half*rnge + mn

var t = 0.0
const glowdecimate = 10 #number of frames to skip
var gc = 0
func bulletglow(delta):
	t += delta
	gc += 1
	if gc >= glowdecimate:
		var v = tri(t,.5,4,2.0)
		bulletmaterial.emission_energy = v
		gc = 0

func twist(mine):
	var xr = rng.randi_range(-1,2)
	var yr = rng.randi_range(-1,2)
	var ninety = PI/2.0
	mine.rotate_x(ninety*xr)
	mine.rotate_y(ninety*yr)

func addmines(preld, pool, n, twist = false):
	var m
	for i in range(n):
		if pool.get_child_count():
			m = pool.get_child(0)
			pool.remove_child(m)
		else:
			m = preld.instance()
		m.t = rng.randf_range(0,m.period)
		if twist:
			twist(m)
		$"../gamemode".place(m, ship.global_transform.origin)
		m.get_node("CollisionShape").disabled = false
		$activemines.add_child(m)
		m.pool = pool

func produce(n):
	var nprox = rng.randi_range(1,n)
	if n == nuklevel:
		nprox = 0
	#nprox = 0 #uncomment to disable proximity mines
	addmines(prox, $pools/prox, nprox)
	
	var nplas = rng.randi_range(1,n)
	if n < 2 or n == nuklevel:
		nplas = 0
	#nplas = 0 #uncomment to disable plasma mines
	addmines(plas, $pools/plas, nplas)
	
	var nlasr = rng.randi_range(1,n)
	if n < 4 or n == nuklevel:
		nlasr = 0
	addmines(lasr, $pools/lasr, nlasr, true) #lasers get twisted
	
	var nnuk = rng.randi_range(0,3)
	if n <= nuklevel:
		nnuk = 0
		if n == nuklevel:
			nnuk = 1
			nprox = nuklevel #fake like the level is full
	addmines(nuke, $pools/nuke, nnuk)
			
	#fill the rest in with plasmamines if needed
	addmines(plas, $pools/plas, n-nplas-nprox-nlasr)
