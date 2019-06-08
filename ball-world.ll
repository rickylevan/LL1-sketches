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


--prelude--

time-flowing? <: false
const time-period <: 3 // for cycling color shifts
time-counter <: 0

const default-radius = 30

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
			r: 255
			g: 0
			b: 0
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
			r: 0
			g: 0
			b: 255
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
			r: 255
			g: 0
			b: 0
		}
	}

	^balls <<: []
	balls <- ball1
	balls <- ball2
	balls <- ball3


--


--blink!--

if time-flowing?
	for ball in balls
		ball.update()

	time-counter < (time-counter + 1) % time-period

	-draw-model-
--



