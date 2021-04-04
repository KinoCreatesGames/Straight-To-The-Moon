package game.char;

import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;

class Stars extends FlxTypedEmitter<FlxParticle> {
	public function new(x:Float, y:Float, ?starCount = 1000) {
		super(x, y, starCount);
		makeParticles(2, 2, KColor.YELLOW, starCount);
		acceleration.set(-100, 25, 100, 50);
		lifespan.set(6);
		// angle.set(0, 30, 60, 90);
	}
}