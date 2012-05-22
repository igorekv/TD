package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import bullet;
	import fire;
	
	public class Main extends Sprite 
	{
		private var sprt:bullet = new bullet("bullet.png");
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			
			sprt.x = 100;
			sprt.y = 100;
			//sprt.scaleX = sprt.scaleY = 1;
			addChild(sprt);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
		}
		
		private function onEnterFrame(e:Event):void {
			sprt.x--; sprt.y--;
			
			
		}
		
		
	}
	
}