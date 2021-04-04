package game.char;

import flixel.math.FlxMath;
import openfl.sensors.Accelerometer;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;

class Player extends FlxTypedGroup<FlxBasic> {
	public var position:FlxPoint;
	public var rocket:FlxSprite;
	public var thrusters:FlxEmitter;
	public var invincible:Bool;
	public var currentAcceleration:Float;

	public static inline var SPD:Float = 150;
	public static inline var INVINCIBILITY_TIME:Float = .75;
	public static inline var FALL_SPD:Float = 250;
	public static inline var MAX_Y:Float = 250;
	public static inline var MAX_X:Float = 150;
	public static inline var THRUST_MAX:Int = 1000;
	public static inline var THRUST_MIN:Int = 800;

	public function new(x:Float, y:Float) {
		super();
		position = new FlxPoint(x, y);
		currentAcceleration = 0;
		this.invincible = false;
		create();
	}

	inline public function playerPosition() {
		return rocket.getPosition();
	}

	public function create() {
		createRocket(position);
		createThrusters(position);
	}

	public function createRocket(position:FlxPoint) {
		rocket = new FlxSprite(position.x, position.y);
		rocket.makeGraphic(4, 8, KColor.WHITE);
		rocket.drag.x = rocket.drag.y = 600;
		// Max Velocity must be set to cap velocity
		// But has to be called in the update movement function
		add(rocket);
	}

	public function createThrusters(position:FlxPoint) {
		thrusters = new FlxEmitter(position.x, position.y + rocket.height);
		thrusters.acceleration.set(0, THRUST_MIN, 0, THRUST_MAX);
		thrusters.makeParticles(2, 2, KColor.WHITE, 500);
		thrusters.drag.set(0, 200);
		add(thrusters);
	}

	public inline function health() {
		return rocket.health;
	}

	public function takeDamage(value:Int) {
		if (!invincible) {
			rocket.health -= value;
			invincible = true;
			rocket.flicker(INVINCIBILITY_TIME, 0.04, true, (effect) -> {
				invincible = false;
			});
		} else {
			// Do nothing
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement(elapsed);
	}

	public function updateMovement(elapsed:Float) {
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);
		var thrusting = FlxG.keys.anyPressed([Z]);
		var newAngle = -90;
		if (thrusting) {
			currentAcceleration += (SPD * elapsed);
			if (thrusters.emitting == false) {
				thrusters.start(false, 0.030, 0);
			}
			thrusters.emitting = true;
		} else {
			currentAcceleration -= elapsed * FALL_SPD;
			currentAcceleration.clampf(-100, FlxMath.MAX_VALUE_INT);
			thrusters.emitting = false;
		}

		if (left || right) {
			if (left) {
				newAngle = -145;
			} else if (right) {
				newAngle = -35;
			}
		}
		rocket.velocity.set(currentAcceleration, 0);
		if (currentAcceleration > 0) {
			rocket.velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		} else {
			rocket.velocity.rotate(FlxPoint.weak(0, 0), newAngle);
			rocket.velocity.x = rocket.velocity.x * -1;
		}
		// Cap Velocity
		rocket.velocity.x = rocket.velocity.x.clampf(-MAX_X, MAX_X);
		rocket.velocity.y = rocket.velocity.y.clampf(-MAX_Y, MAX_Y);
		thrusters.setPosition(rocket.x, rocket.y + rocket.height);
		// trace(rocket.velocity);
		rocket.bound(); // Keep within screenspace
	}
}