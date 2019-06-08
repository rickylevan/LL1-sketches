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

struct point
	x: float
	y: float

struct color
	r: byte
	g: byte
	b: byte

struct ball
	pos:   point
	vel:   point
	rad:   float
	color: color


--update--
if on
	-move-straight-
if curve-behavior
	-curve-
if color-shift-behavior
	-color-shift-
if collide-behavior
	-collide-
--


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

rand-color() -> (c: Color)
	c.r < rngi(256) - 1
	c.g < rngi(256) - 1
	c.b < rngi(256) - 1


--color-shift--

if time-counter == 0
	b.color,, rand-color()

// damn that line is hot I burned my hand










--prelude--

time-flowing? <: off
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


