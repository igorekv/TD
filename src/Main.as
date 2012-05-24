package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import bullet;
	import fire;
	import global;
	import flash.display.Bitmap;
	public class Main extends Sprite 
	{
		private var frame:int = 0;
		public function Main():void 
		{
			global.loadBitmap("bullet.png", global.bulletBitmap);
			global.loadBitmap("smoke.png", global.smoke);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init); 
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			trace(global.loadStatus);
			
			addEventListener(Event.ENTER_FRAME, loadingWait); //событие на каждый кадр
		}
		
		private function loadingWait(e:Event):void {// тут можно прикрутить анимацию загрузки
			if (global.loadQueue == global.loadStatus) {
				removeEventListener(Event.ENTER_FRAME, loadingWait);
				addEventListener(Event.ENTER_FRAME, onEnterFrame)
				
			}
		}
		
		
		private function onEnterFrame(e:Event):void {
			if (frame == 1) { frame = 0;
			var sprt:bullet = new bullet(0, Math.random() * 360);
			//var sprt:bullet = new bullet(0,180);
			sprt.x = 100;
			sprt.y = 100;
			sprt.scaleX = sprt.scaleY = 1;
			addChild(sprt);
			//sprt.rotation =90;
			//sprt.x+=2; 
			}
			frame++;
			
		}
		
		
	}
	
}