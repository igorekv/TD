package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author igorek
	 */
	public class bullet extends Sprite
	{
		private var degree:Number = Math.PI / 180;
		private var tileWidth:int = 9; //ширина спрайта
		private var tileHeight:int = 9; //высота спрайта
		private var displayBitmapData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff); //данные спрайта на экране
		private var displayBitmap:Bitmap = new Bitmap(displayBitmapData); //картинка спрайта на экране
		private var BlitPoint:Point = new Point(0, 0); //точка начала копирования пикселей
		private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		private var tilesPerRow:int = 9;
		private var bulletType:int = 0;
		private var bulletAngle:int = 0;
		private var bulletSpeed:int = 3;
		private var bulletRange:int = 40;
		private var frame:int = 0;
		
		public function bullet(bType:int, bAngle:int)
		{
			this.bulletAngle = bAngle
			this.bulletType = bType;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
			displayBitmap.x = -tileWidth / 2;
			displayBitmap.y = -tileHeight / 2;
			this.rotation = bulletAngle + 180;
			addChild(displayBitmap); //выводим обьект на экран
			
			updateSprite();	
		}
		/*
		private function onLoadComplete(e:Event):void
		{ //обработчик окончания загрузки
			tileSheet = e.target.loader.content.bitmapData; //получаем данные о спрайтах
			addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
			//updateSprite();
			global.bulletBitmap.x = -tileWidth / 2;
			global.bulletBitmap.y = -tileHeight / 2;
			this.rotation = bulletAngle + 180;
			addChild(global.bulletBitmap); //выводим обьект на экран
			
			updateSprite();
		
		}
		*/
		
		private function onEnterFrame(e:Event):void
		{
			//var Fire:fire = new fire(this.x-this.width/2,this.y-this.height/2,this.scaleX);
			this.x += Math.cos(bulletAngle * degree) * bulletSpeed;
			this.y += Math.sin(bulletAngle * degree) * bulletSpeed;
			
			if (frame == 2)
			{
				frame = 0;
				var Fire:fire = new fire(this.x, this.y, this.scaleX, bulletAngle, bulletSpeed);
				parent.addChild(Fire);
			}
			frame++;
			
			if (bulletRange <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				parent.removeChild(this);
				
			}
			bulletRange--;
		
		}
		
		private function updateSprite():void
		{
			
			displayBitmapData.lock();
			blitRect.x = bulletType * tileWidth;
			blitRect.y = 0;
			
			displayBitmapData.copyPixels(global.bulletBitmap.bitmapData, blitRect, BlitPoint);
			displayBitmapData.unlock();
		}
	
	}

}