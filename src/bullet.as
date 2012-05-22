package  
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author igorek
	 */
	public class bullet extends Sprite
	{
	private var loader:Loader; //загрузщик
	private var tileSheet:BitmapData; //данные со спрайтами
	private var tileWidth:int = 9; //ширина спрайта
	private var tileHeight:int = 9; //высота спрайта
	private var displayBitmapData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff); //данные спрайта на экране
	private var displayBitmap:Bitmap = new Bitmap(displayBitmapData); //картинка спрайта на экране
	private var BlitPoint:Point = new Point(0, 0); //точка начала копирования пикселей
	private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
	private var tilesPerRow:int = 9;	
	private var url:String = "bullet.png";
	private var bulletType:int = 0;
		
		public function bullet(btype) {
			this.bulletType = btype;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete); //событие об окончании загрузки
			loader.load(new URLRequest(url)); //загрузка спрайтлиста
						
		}
		
		private function onLoadComplete(e:Event):void
		{ //обработчик окончания загрузки
			tileSheet = e.target.loader.content.bitmapData; //получаем данные о спрайтах
			addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
			//updateSprite();
			addChild(displayBitmap); //выводим обьект на экран
			
			
			updateSprite();
		
		}
		
		private function onEnterFrame(e:Event):void {
			var Fire:fire = new fire(this.x+this.width,this.y-1,this.scaleX);
			
			
			
			parent.addChild(Fire);
			
			
		}
		
		
		
		
		private function updateSprite():void
		{
			
			displayBitmapData.lock();
			blitRect.x = bulletType*tileWidth;
			blitRect.y = 0;
			
			displayBitmapData.copyPixels(tileSheet, blitRect, BlitPoint);
			displayBitmapData.unlock();
		}
		
		
	}

}