package game.char;

class Asteroid extends Enemy {
	public function new(x:Float, y:Float) {
		super(x, y, null, null);
		create();
	}

	public function create() {
		makeGraphic(16, 16, KColor.RED);
	}

	override function assignStats() {}
}