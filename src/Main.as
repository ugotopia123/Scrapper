package{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ship.Ship;
	import shipParts.Hull;
	import shipParts.MainThruster;
	import shipParts.ShipPart;
	import shipParts.SideThruster;
	import StarLayer;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Main extends Sprite {
		public static var stageInstance:Stage;
		public static var player:ship.Ship;
		public static var keysDown:Vector.<uint> = new Vector.<uint>();
		
		private static var updateTimer:Timer = new Timer(1000 / 60);
		private static var currentStageWidth:Number;
		private static var currentStageHeight:Number;
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			stageInstance = stage;
			currentStageWidth = stageInstance.stageWidth;
			currentStageHeight = stageInstance.stageHeight;
			
			StarLayer.initialize();
			ShipPart.initialize();
			
			stageInstance.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stageInstance.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			updateTimer.addEventListener(TimerEvent.TIMER, updateHandler);
			updateTimer.start();
			
			player = new ship.Ship(Hull.standard, MainThruster.warp, SideThruster.standard);
			player.x = stageInstance.stageWidth / 2 - player.width / 2;
			player.y = stageInstance.stageHeight / 2 - player.height / 2;
		}
		
		public static function randNumber(min:Number, max:Number):Number {
			return Math.floor(Math.random() * (1 + max - min)) + min
		}
		
		public static function keyIsDown(keycode:uint):Boolean {
			return keysDown.indexOf(keycode) != -1;
		}
		
		private static function updateHandler(e:TimerEvent):void {
			if (stageInstance.stageWidth != currentStageWidth || stageInstance.stageHeight != currentStageHeight) resizeHandler();
			
			var angle:Number = player.rotation * Math.PI / 180;
			
			var xSpeed:Number = player.updatedSpeed() * Math.sin(angle);
			var ySpeed:Number = player.updatedSpeed() * Math.cos(angle);
			var rotate:Number = player.updatedRotation();
			
			if (xSpeed != 0 || ySpeed != 0) StarLayer.starHandler(-xSpeed, ySpeed);
			if (rotate != 0) player.rotation += rotate;
		}
		
		private static function resizeHandler():void {
			currentStageWidth = stageInstance.stageWidth;
			currentStageHeight = stageInstance.stageHeight;
		}
		
		private static function keyDownHandler(e:KeyboardEvent):void {
			if (keysDown.indexOf(e.keyCode) != -1) return;
			else keysDown.push(e.keyCode);
		}
		
		private static function keyUpHandler(e:KeyboardEvent):void {
			try { keysDown.removeAt(keysDown.indexOf(e.keyCode)); }
			catch (err:Error) { trace("Could not remove index containing keyCode " + e.keyCode + " (key character " + String.fromCharCode(e.keyCode) + ")"); }
		}
	}
}