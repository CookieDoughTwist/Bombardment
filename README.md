# Bombardment
A simple game about space, orbits, and BOMBARDMENT! You are the commander of your fleet of JUSTICE! Destroy all enemies!

## Disclaimer
I am compelled to open with game's inadequacies. First, I certainly chose a game concept that a little bit more than I can achieve in a week, and I ran out of time. Though the current product meets the minimum Final Project Objectives, the scenarios the engine is designed for are mildly extremely difficult. Even the provided watered down scenarios are rather tricky without some knowledge of orbital mechanics (or at least some Kerbal Space Program experience). Good luck commander!

## Coming Soon...
* Panels - No UI is complete without flexible panels to show you what's happening.
* Trajectories - Now wouldn't it be nice to know where we're going without estimating conic sections in our head?
* Basic AI - Yeah, the enemies don't even know how to maneuver to broadside right now...
* More Weapons - What's a space game without lasers and missiles?

## Quickstart Controls
### Ship Controls
Key Stroke | Effect
-|-
Q/E | torque ccw/cw
LShift/LCtrl | throttle up/throttle down
Z/X | throttle max/throttle min
T | toggle gimbal stabilizer
### Camera Controls
Key Stroke | Effect
-|-
+/-, WhlUp/WhlDown | zoom in/zoom out
PgUp/PgDn | rotate ccw/rotate cw
Arrow Keys | camera pan (when camera unlocked)
Y | toggle camera lock
[/] | cycle craft (if you have more than one)
M | toggle map mode (you can zoom out further but cannot control your craft)
H | toggle hit box and range indicators

## Infodump
Some hopefully helpful tips.

### How to Play
The goal of the gmae is to destroy all enemy craft. This can be accomplished most easily by shooting them with the weapons on your crft. Most weapon systems are mounted on the side of your craft and are active by default. Weapons will automatically aim and fire when in range. Be aware that weapons have nonnegligible turning time. The key to this game is planning interceptions and executing favorable encounters.

### UI
* The armor bar is your HP. If it goes to 0 your craft explodes.
* Orbital velocity is your craft velocity relative to the most gravitationally significant body from the current position.
* The navigation dial displays some key vectors:
  * Θ - current craft bearing (where your ship is pointing)
  * v - current orbital velocity (velocity relative to planet)
  * a - current vector of acceleration (sum of gravity and thrust)

### Physics
* There is no air resistance in space, so Newton's first law is very apparent.
  * __If you have stabilization toggled on, your craft gimbal will resist rotational velocity whenever you're not actively turning your ship.__
* Whenever you apply thrust to your craft, your orbit will necessarily change. Understanding how the shape of your orbit is affected by your craft thrust is the key to planning a successful intercept (tutorial to come eventually...).

## Game Design Notes
This game relies heavily on the Box2D architechture for kinematic propagation. The objects in the universe folder all exist to feed information to the Box2D physics engine. Due to the nature of space, gravity is computed externally and then fed to Box2D. Unfortunately, Box2D does not seem to do linear interpolation to solve for clipping in high velocity collisions. In order to compensate, Box2D is updated multiple times per frame in order to improve physical stability.

## Resources
Any stolen resources are credited in the Dependencies.lua file. Much of the sprite art was drawn by my little brother (not credited).

## Author
* Andrew Wang
