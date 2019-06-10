// You'll need to check that this dynamic scope system can be
// statically verified with fixed types

// You should write out your vector code too, no handwaving

// What of methods on objects and private methods, what do?

// Also all the < <: << <<: <= <=: syntax, and the case of
// loading constants. What do that's friendly and not a pain?
// Also = for constants. What of string constants or larger
// structure "constants" we might like to init in prelude???

// Also, *translating* code is very important for you now.
// Do as much of this as you can

// Then alternate with deeper theoretical thinking and ensuring
// you have firm the exact semantics of the code all the time.
// Then it will just be bitch work once you've boiled the ocean.

// Think deeper about Lisp style thinking. Where exactly is it
// performance bane? How realistic is it that sufficiently
// smart anything could fix the problem? (Perf here of course
// also means memory consumption). Where are the copies?
// Specifically, ya you must figure out how lisp code would
// work in your machine semantics.
// You like data tree, why no code tree?


type point
	x float
	y float

type color
	r byte
	g byte
	b byte

type ball
	pos   point
	vel   point
	rad   float
	color color


--update--
if on
	-move-straight-
if curve-behavior
	-curve-
if color-shift-behavior
	-color-shift-
if collide-behavior
	-collide-wrap-
--


--collide-wrap--
for bb in balls
	if bb !== b // identity, not equality. lol
		-collide-
--

--get-distance--
dist,, distance(b, bb)
--

--get-reduced-mass--
	b-mass <: pow(b.rad, 2)
	bb-mass <: pow(bb.rad, 2)
	^red-mass <: (b-mass * bb-mass) / (b-mass + bb-mass)
--


dot(p1: point, p2: point) -> (prod: float)
	prod < p1.x * p2.x + p1.y * p2.y


--get-collision-time--

	delta-vel <: point {
		x: bb.vel.x - b.vel.x
		y: bb.vel.y - b.vel.y
	}

	delta-pos <: point {
		x: bb.pos.x - b.pos.x
		y: bb.pos.y - b.pos.y
	}

	R <: b.rad + bb.rad

	Q <: pow(dot(delta-vel, delta-pos), 2) -
		  dot(delta-vel, delta-pos) *
		  (dot(delta-vel, delta-pos) - pow(R, 2))

	^tstar <: - (dot(dvel, dpos) + sqrt(Q)) /
		dot(dvel, dvel)

--


get-mass(b: ball) -> (m: float)
	m < pow(b.rad, 2)


get-impulse(b: ball, bb: ball)
	-get-distance-
	nx <: (b.pos.x - bb.pos.x) / dist
	ny <: (b.pos.y - bb.pos.y) / dist

	dvn <: nx * (bb.vel.x - bb.vel.x) +
		   ny * (bb.vel.y - bb.vel.x)
	-get-reduced-mass-
	^impulse <: point {
		x: 2 * red-mass * dvn * nx,
		y: 2 * red-mass * dvn * ny,
	}


nudge = 1.1


--collide--

	b-mass,, get-mass(b)
	b-new-vel <: point {
		x: b.vel.x + get-impulse(b, bb).x / b-mass
		y: b.vel.y + get-impulse(b, bb).y / b-mass
	}

	bb-mass,, get-mass(bb)
	bb-new-vel <: point {
		x: bb.vel.x + get-impulse(bb, b).x / bb-mass
		y: bb.vel.y + get-impulse(bb, b).y / bb-mass

	}

	-get-collision-time-

	b-new-pos <: point {
		x: b.pos.x + tstar * (b.vel.x - nudge * b-new-vel.x)
		y: b.pos.y + tstar * (b.vel.y - nudge * b-new-vel.y)
	}

	bb-new-pos <: point {
		x: bb.pos.x + tstar * (bb.vel.x - nudge * bb-new-vel.x)
		y: bb.pos.y + tstar * (bb.vel.y - nudge * bb-new-vel.y)
	}

	b.vel < b-new-vel
	bb.vel < bb-new-vel
	b.pos < b-new-pos
	bb.pos < bb-new-pos



--move-straight--
b.pos.x += b.vel.x
b.pos.y += b.vel.y
--

--curve--
	pi = 3.1415926
	theta = pi / 16

	a_ = b.vel.x * cos(theta)
	b_ = b.vel.y * sin(theta)
	c_ = b.vel.y * cos(theta)
	d_ = b.vel.x * sin(theta)

	b.vel.x < a_ - b_
	b.vel.y < c_ - d_
--


// A HAHAHA from Lena, on the hard force of leet functions
// name aliasing. Now how much can things "leak" with a bunch
// of crafty code?

// Pure function with rng() woohoo

rand-color() -> (c: color)
	c.r < rngi(256) - 1
	c.g < rngi(256) - 1
	c.b < rngi(256) - 1


--color-shift--

if time-counter == 0
	b.color,, rand-color()

// damn that line is hot I burned my hand

--








--prelude--

time-flowing? <: on
const time-period <: 3 // for cycling color shifts
time-counter <: 0

const default-radius = 30

curve-behavior <: off
color-shift-behavior <: off
collide-behavior <: off

// define initial balls

	ball1 <: ball {
		pos: point {
			x: 80, y: 80
		}
		vel: point {
			x: 8.0, y: 3.7
		}
		rad: default-radius
		color: color {
			r: 255, g: 0, b: 0
		}
	}

	ball2 <: ball {
		pos: point {
			x: 120, y: 70
		}
		vel: point {
			x: 7.0, y: 4.7
		}
		rad: default-radius
		color: color {
			r: 0, g: 0, b: 255
		}
	}

	ball3 <: ball {
		pos: point {
			x: 90, y: 69
		}
		vel: point {
			x: 8.0, y: 3.7
		}
		rad: default-radius
		color: color {
			r: 255, g: 0, b: 0
		}
	}

	^balls <<: []
	balls <- ball1
	balls <- ball2
	balls <- ball3

--


--blink!--
if time-flowing?
	for b in balls
		-update-

	time-counter < (time-counter + 1) % time-period

	-draw-model-
--




--add-button-click!--	
	// putting functions only where used, nice, but oyy
	// veyy, what of scope?

	rand-vel() -> (v: point)
		v.x < 12 - rngi(24)
		v.y < 12 - rngi(24)

	rand-radius() -> (r: float)
		r < 15 + rngi(25)

	ball <: ball {
		pos: point {
			x: 80, y: 80
		}
		// this struct builder syntax should work
		vel: rand-vel()
		rad: rand-radius()
		color: rand-color()
	}

	balls <- ball
--

--clear-button-click!--
balls <- []
--

--pause-button-click!--
time-flowing?!! // lol
--

--curve-button-click!--
curve-behavior!!
--

--color-shift-button-click!--
color-shift-behavior!!
--

--collide-button-click!-
collide-behavior!!
--










