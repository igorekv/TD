package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import bullet;
	import fire;
	import flash.text.TextField;
	import global;
	import flash.display.Bitmap;
	import map;
	public class Main extends Sprite 
	{
		private var frame:int = 0;
		private var loadingTxt:TextField=new TextField();
		private var loadingTmp:int = 0;
		private var mapLevel:map;
		public function Main():void 
		{
			global.loadBitmap("bullet.png", global.bulletBitmap);
			global.loadBitmap("terrain.png", global.terrainBitmap);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init); 
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			
			
			addEventListener(Event.ENTER_FRAME, loadingWait); //событие на каждый кадр
		}
		
		private function loadingWait(e:Event):void {// тут можно прикрутить анимацию загрузки
			
			if (loadingTmp == 0) {  loadingTxt.y = Math.random() * 100; loadingTxt.text = "loading..."+String(loadingTmp); addChild(loadingTxt); loadingTmp++; }
			if (global.loadQueue == global.loadStatus) {
				removeChild(loadingTxt);
				removeEventListener(Event.ENTER_FRAME, loadingWait);
				addEventListener(Event.ENTER_FRAME, onEnterFrame)
				afterLoading();
				
			}
			loadingTxt.text = "loading..." + String(loadingTmp);
			loadingTmp++; 
		}
		
		private function afterLoading() {
			mapLevel = new map(1);
			addChild(mapLevel);
		}
		
		private function onEnterFrame(e:Event):void {
			if (frame == 1) { frame = 0;
			/*
			var rnd = Math.random() * 360;
			var sprt:bullet = new bullet(2, rnd);
			//var sprt:bullet = new bullet(0,180);
			sprt.x = 100;
			sprt.y = 100;
			sprt.scaleX = sprt.scaleY = 1;
			addChild(sprt);
			
			*/
			
			}
			frame++;
			
		}
		
		
	}
	
}