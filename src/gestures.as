package {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author igorek
	 */
	public class gestures {
		
		private var precision:int = 15;
		private var timer:Timer;
		private var old_x:int = 0;
		private var old_y:int = 0;
		private var mx:int = 0;
		private var my:int = 0;
		private var countdown:int = 0;
		private var stage:Stage;
		private var gesture:String;
		private var lastSymbol:String;
		private var action:String = "";
		public const CANCEL:String = 'cancel';
		
		public function gestures(_stage:Stage){
			stage = _stage;
			timer = new Timer(1000 / precision);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onFrame);
			countdown = precision;
		
		}
		
		public function onFrame(e:TimerEvent):void {
			var dx:int = stage.mouseX - old_x;
			var dy:int = stage.mouseY - old_y;
			var dist:int = dx * dx + dy * dy;
			//trace(dist);
			old_x = stage.mouseX;
			old_y = stage.mouseY;
			
			if (countdown == int(precision / 10 * 8)){
				
				gesture = "";
			} //сбрасываем жест
			if (dist > 10000 / precision){
				var angle:Number = Math.atan2(dy, dx) * global.radian + 202;
				
				countdown = precision;
				var symbol:String = "";
				if (45 < angle && angle < 90){
					symbol += "NW."
				}
				if (90 < angle && angle < 135){
					symbol += "N."
				}
				if (135 < angle && angle < 180){
					symbol += "NE."
				}
				if (180 < angle && angle < 225){
					symbol += "E."
				}
				if (225 < angle && angle < 270){
					symbol += "SE."
				}
				if (270 < angle && angle < 315){
					symbol += "S."
				}
				if (315 < angle && angle < 360){
					symbol += "SW."
				}
				if (360 < angle && angle < 405){
					symbol += "W."
				}
				if (0 < angle && angle < 45){
					symbol += "W."
				}
				if (symbol != lastSymbol){
					gesture += symbol;
					lastSymbol = symbol;
					selectAction(gesture);
				}
			}
			countdown--;
			
			if (countdown < 0){
				action = "";
				countdown = 0
			}
			;
		
		}
		
		private function selectAction(gest:String):void {
			//trace(gest, gest.search("W.E.W.E."));
			if (gest.search("W.E.W.E.") >= 0){
				action = CANCEL;
			}
			if (gest.search("E.W.E.W.") >= 0){
				action = CANCEL;
			}
			//trace(gest);
		}
		
		public function check(str:String):Boolean {
			
			if (str == action){
				action = "";
				return true;
			} else {
				return false
			}
		}
	}

}