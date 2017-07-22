package {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class DistantStar extends Sprite {
		public static const generatedStars:uint = 100;
		
		private static var stars:Vector.<DistantStar> = new Vector.<DistantStar>();
		
		private const randDepth:Number = Main.randNumber(50, 100) / 100;
		
		public function DistantStar() {
			super();
			
			stars.push(this);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, Main.randNumber(1, 3), Main.randNumber(1, 3));
			graphics.endFill();
			
			Main.stageInstance.addChildAt(this, 0);
			x = Main.randNumber(0, Main.stageInstance.stageWidth - width);
			y = Main.randNumber(0, Main.stageInstance.stageHeight - height);
		}
		
		public static function initialize():void {
			for (var i:uint = 0; i < generatedStars; i++) new DistantStar();
		}
		
		public static function starHandler(xSpeed:Number, ySpeed:Number):void {
			for (var i:uint = 0; i < stars.length; i++) {
				if (xSpeed != 0) stars[i].x += xSpeed * stars[i].randDepth;
				if (ySpeed != 0) stars[i].y += ySpeed * stars[i].randDepth;
				
				if (stars[i].x < -stars[i].width) stars[i].x = Main.stageInstance.stageWidth + stars[i].width;
				else if (stars[i].x > Main.stageInstance.stageWidth + stars[i].width) stars[i].x = -stars[i].width;
				
				if (stars[i].y < -stars[i].height) stars[i].y = Main.stageInstance.stageHeight + stars[i].height;
				else if (stars[i].y > Main.stageInstance.stageHeight + stars[i].height) stars[i].y = -stars[i].height;
			}
		}
	}
}