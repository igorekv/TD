package  
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class sfx extends Sprite
	{
		public static const SHOT:int = 0;//эфект огня при выстреле
		public static const BLOOD:int = 1;//эфект крови при попадании
		public static const SCRAP:int = 2;//эфект крошек битона при попадании
		public var toRemove:Boolean = false;
		private var currentFrame:int = 0;//текущий кадр эфекта
		private var framesTotal:int = 0;//всего кадров в эфекте
		private var animationSpeed:int = 0;//кадров в сек
		private var timer:Timer;//таймер вызывающий анимацию
		private var tiles:int = 0;
		private var tileWidth:int = 0;
		private var tileHeight:int = 0;
		private var _x:int = 0;
		private var _y:int = 0;
		private var row:int=0;
		
		private var displayBitmapData:BitmapData;// = new BitmapData(tileWidth, tileHeight, true, 0xffffff); //данныеспрайа на экране
		private var displayBitmap:Bitmap ;//= new Bitmap(displayBitmapData); //картинка спрайта на экране
		private var BlitPoint:Point = new Point(0, 0); //точка начала копирования пикселей
		private var blitRect:Rectangle// = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		public function sfx(type:int) 
		{
		
		if (type == SHOT) { row = 0; tiles = 3; tileWidth = tileHeight = 16; animationSpeed = 20; framesTotal = 4; _x = 15; _y = 8; }
		if (type == BLOOD) { row = 16; tiles = 3; tileWidth = tileHeight = 16; animationSpeed = 20; framesTotal = 4; _x = 8; _y = 8; }
		if (type == SCRAP) { row = 32; tiles = 3; tileWidth = tileHeight = 16; animationSpeed = 20; framesTotal = 4; _x = 8; _y = 8; }
		displayBitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff);
		displayBitmap = new Bitmap(displayBitmapData); 
		blitRect = new Rectangle(0, 0, tileWidth, tileHeight);
		timer = new Timer(int(1000 / animationSpeed), framesTotal);
		timer.addEventListener(TimerEvent.TIMER, updateSprite);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, complete);
		timer.start();
		addChild(displayBitmap);
		displayBitmap.x = 0 - _x;
		displayBitmap.y = 0 - _y;
		global.sfxlist.push(this);
		//trace('test',int(1000/animationSpeed),framesTotal);
		}
		
		public function updateSprite(e:TimerEvent):void
		{
			//trace('upd');
			displayBitmapData.lock();
			blitRect.x = currentFrame * tileWidth;
			blitRect.y = row;
			
			displayBitmapData.copyPixels(global.sfx1Bitmap.bitmapData, blitRect, BlitPoint);
			displayBitmapData.unlock();
			currentFrame++;
		}
		private function complete(e:TimerEvent):void {
			removeChild(displayBitmap);
			timer.removeEventListener(TimerEvent.TIMER, updateSprite);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, complete);
			timer.stop();
			toRemove = true;
			//trace('end');
		}
		
	}

}