package game.item;

import flixel.math.FlxMath;

class Item extends FlxSprite {
	public var initialPosition:FlxPoint;
	public var count:Int = 0;

	public function new(x:Float, y:Float) {
		super(x, y);
		this.initialPosition = this.getPosition().copyTo(new FlxPoint(0, 0));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		count += cast elapsed * 5;
		var result = FlxMath.wrap(count, -100, 100);

		this.x = this.initialPosition.x + (FlxMath.fastCos(result) * 30);
	}
}