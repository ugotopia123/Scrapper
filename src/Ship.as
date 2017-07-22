package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import shipParts.Hull;
	import shipParts.MainThruster;
	import shipParts.SideThruster;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Ship extends Sprite {
		[Embed(source = "../bin/ship.png")]
		private var ShipClass:Class;
		private var shipIcon:Bitmap = new ShipClass();
		
		public static var momentum:Number = 0.75;
		
		public var hull:Hull;
		public var mainThruster:MainThruster;
		public var sideThruster:SideThruster;
		public var weight:Number = 0;
		public var currentSpeed:Number = 0;
		public var currentTurnSpeed:Number = 0;
		
		public function Ship(hull:Hull, mainThruster:MainThruster, sideThruster:SideThruster) {
			super();
			hull.equip(this);
			mainThruster.equip(this);
			sideThruster.equip(this);
			
			addChild(shipIcon);
			shipIcon.x -= 32;
			shipIcon.y -= 32;
			Main.stageInstance.addChild(this);
		}
		
		public function updatedSpeed():Number {
			if (Main.keyIsDown(Keyboard.W) && currentSpeed < mainThruster.speed) currentSpeed += acceleration();
			else if (!Main.keyIsDown(Keyboard.W) && currentSpeed > 0) currentSpeed -= deceleration();
			
			if (Main.keyIsDown(Keyboard.S) && currentSpeed > 0) currentSpeed -= currentSpeed / (6.5 * 60);
			
			if (currentSpeed > mainThruster.speed) currentSpeed = mainThruster.speed;
			else if (currentSpeed < 0) currentSpeed = 0;
			
			return currentSpeed;
		}
		
		private function acceleration():Number {
			var actualThrust:Number = mainThruster.thrust * Math.pow(0.985, weight);
			
			return actualThrust / 60;
		}
		
		private function deceleration():Number {
			return momentum / weight;
		}
		
		public function updatedRotation():Number {
			if (Main.keyIsDown(Keyboard.A) && Math.abs(currentTurnSpeed) < sideThruster.speed) {
				if (currentTurnSpeed > 0) currentTurnSpeed -= deceleration();
				
				currentTurnSpeed -= turnAcceleration();
			}
			else if (Main.keyIsDown(Keyboard.D) && currentTurnSpeed < sideThruster.speed) {
				if (currentTurnSpeed < 0) currentTurnSpeed += deceleration();
				
				currentTurnSpeed += turnAcceleration();
			}
			else {
				if (currentTurnSpeed < 0) {
					currentTurnSpeed += deceleration() * 2;
					
					if (currentTurnSpeed > 0) currentTurnSpeed = 0;
				}
				else {
					currentTurnSpeed -= deceleration() * 2;
					
					if (currentTurnSpeed < 0) currentTurnSpeed = 0;
				}
			}
			
			if (currentTurnSpeed < 0 && Math.abs(currentTurnSpeed) > sideThruster.speed) currentTurnSpeed = -sideThruster.speed;
			else if (currentTurnSpeed > sideThruster.speed) currentTurnSpeed = sideThruster.speed;
			
			return currentTurnSpeed;
		}
		
		private function turnAcceleration():Number {
			var actualThrust:Number = sideThruster.thrust * Math.pow(0.98, weight);
			return actualThrust / 60;
		}
	}
}