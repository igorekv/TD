package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import bullet;
	import fire;
	
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			var sprt:bullet = new bullet("bullet.png");
			addChild(sprt);
		}
	}
	
}