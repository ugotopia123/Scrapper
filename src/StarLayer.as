package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class StarLayer extends Sprite {
		public static const numStars:uint = 25;
		private static const layerWidth:uint = 3;
		private static const layerHeight:uint = 3;
		private static const layerDepth:uint = 5;
		private static var currentX:uint = 0;
		private static var currentY:uint = 0;
		private static var currentZ:uint = 0;
		
		public var position:Vector.<uint> = new Vector.<uint>(3, true);
		private var depthMult:Number;
		private var background:Bitmap;
		private var backgroundData:BitmapData = new BitmapData(Main.stageInstance.stageWidth, Main.stageInstance.stageHeight, true, 0);
		
		private static var layerVector:Vector.<Vector.<Vector.<StarLayer>>> = new Vector.<Vector.<Vector.<StarLayer>>>();
		
		public function StarLayer() {
			addLayerAt(getNextPosition());
			depthMult = 1 - (1 / layerDepth * position[2]);
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, Main.stageInstance.stageWidth, Main.stageInstance.stageHeight);
			graphics.beginFill(0xFFFFFF);
			
			for (var i:uint = 0; i < numStars; i++) {
				graphics.drawRect(Main.randNumber(0, Main.stageInstance.stageWidth), Main.randNumber(0, Main.stageInstance.stageHeight), Main.randNumber(1, 3), Main.randNumber(1, 3));
			}
			
			backgroundData.draw(this);
			background = new Bitmap(backgroundData);
			graphics.clear();
			graphics.endFill();
			this.addChild(background);
			
			Main.stageInstance.addChild(this);
			x = Main.stageInstance.stageWidth * position[0];
			y = Main.stageInstance.stageHeight * position[1];
		}
		
		public static function initialize():void {
			for (var i:uint = 0; i < layerWidth; i++) {
				layerVector.push(new Vector.<Vector.<StarLayer>>());
				
				for (var j:uint = 0; j < layerHeight; j++) {
					layerVector[i].push(new Vector.<StarLayer>());
				}
			}
			
			for (var k:uint = 0; k < layerWidth * layerHeight * layerDepth; k++) new StarLayer();
		}
		
		public static function starHandler(xSpeed:Number, ySpeed:Number):void {
			for (var i:uint = 0; i < layerVector.length; i++) {
				for (var j:uint = 0; j < layerVector[i].length; j++) {
					for (var k:uint = 0; k < layerVector[i][j].length; k++) {
						var currentLayer:StarLayer = layerVector[i][j][k];
						
						if (xSpeed != 0) currentLayer.x += xSpeed * currentLayer.depthMult;
						if (ySpeed != 0) currentLayer.y += ySpeed * currentLayer.depthMult;
						
						if (currentLayer.x < -currentLayer.width) currentLayer.x = Main.stageInstance.stageWidth + currentLayer.width;
						else if (currentLayer.x > Main.stageInstance.stageWidth + currentLayer.width) currentLayer.x = -currentLayer.width;
						
						if (currentLayer.y < -currentLayer.height) currentLayer.y = Main.stageInstance.stageHeight + currentLayer.height;
						else if (currentLayer.y > Main.stageInstance.stageHeight + currentLayer.height) currentLayer.y = -currentLayer.height;
					}
				}
			}
		}
		
		public static function getLayerAt(x:uint, y:uint):Vector.<StarLayer> {
			return layerVector[x][y];
		}
		
		public static function getStarLayerAt(x:uint, y:uint, z:uint):StarLayer {
			return layerVector[x][y][z];
		}
		
		private static function getNextPosition():Vector.<uint> {
			if (layerVector[currentX][currentY].length == layerDepth) {
				if (currentX == layerWidth - 1) {
					currentX = 0;
					currentY++;
				}
				else currentX++;
				
				currentZ = 0;
			}
			else if (layerVector[currentX][currentY].length > 0) currentZ++;
			
			return new <uint>[currentX, currentY, currentZ];
		}
		
		public function addLayerAt(positions:Vector.<uint>):void {
			layerVector[positions[0]][positions[1]][positions[2]] = this;
			position = positions;
		}
	}
}