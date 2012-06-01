package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class map extends Sprite
	{
		private var mapWidth:int = 10;
		private var mapHeight:int = 5;
		private var tileWidth:int = 32;
		private var tileHeight:int = 32;
		private var tilesPerRow:int = 12;
		private var mapBitmapData:BitmapData=new BitmapData(mapWidth*tileWidth,mapHeight*tileHeight,false,0xFFFFFF);
		private var mapBitmap:Bitmap=new Bitmap(mapBitmapData);
		private var loadedData:String;
		private var BlitPoint:Point; //точка начала копирования пикселей
		private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		
		
		public function map(level:int) 
		{
		
		var loader:URLLoader = new URLLoader();
		
		loader.load(new URLRequest("level" + String(level) +".txt")); //загрузка спрайтлиста	
		loader.addEventListener(Event.COMPLETE, onLoadLevelComplete);
			
		}
		private function onLoadLevelComplete(e:Event) {
			loadedData = e.target.data;
			var pattern:RegExp=/\r\n/g;
			loadedData = loadedData.replace(pattern,"B");
			var tmp:int = 0;
			addChild(mapBitmap);
			for (var i:int = 0; i < 5; i++ ) {
				for (var j:int = 0; j < 12; j++ ) {
					//drawSprite(loadedData.charCodeAt(i*10+j)-48, j, i);
					drawSprite(tmp, j, i);
					tmp++;
					//trace(loadedData.charCodeAt(i*10+j)-65, j);
					}
				}
		}
		
		private function drawSprite(tile:int,x:int,y:int):void
		{
			var BlitPoint = new Point(x * tileWidth, y * tileHeight);
			mapBitmapData.lock();
			blitRect.x = (tile % tilesPerRow) * tileWidth;
			blitRect.y = int(tile / tilesPerRow) * tileHeight;
			trace(blitRect.x / tileWidth);
			mapBitmapData.copyPixels(global.terrainBitmap.bitmapData, blitRect, BlitPoint);
			mapBitmapData.unlock();
			
			
		}
		
	}

}