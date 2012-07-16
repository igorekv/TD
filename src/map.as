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
		private var mapWidth:int = global.levelBitmap.width;
		private var mapHeight:int = global.levelBitmap.height;
		private var tileWidth:int = 16;
		private var tileHeight:int = 16;
		private var tilesPerRow:int = 9;
		private var mapBitmapData:BitmapData=new BitmapData(mapWidth*tileWidth,mapHeight*tileHeight,false,0xFFFFFF);// экранный обьект
		private var mapBitmap:Bitmap=new Bitmap(mapBitmapData);// экранный обьект
		private var loadedData:String;
		private var BlitPoint:Point; //точка начала копирования пикселей
		private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		
		
		public function map(level:int) 
		{
		
			var tmp:int = 0;
			addChild(mapBitmap);
			updateMap();
			
			
		}
		
		public function updateMap():void {
			
			trace(global.levelBitmap.height, global.levelBitmap.width);
			for (var _x:int = 0; _x < global.levelBitmap.width; _x++ ) {
			
				global.nodes[_x] = new Vector.<node>();
					for (var _y:int = 0; _y < global.levelBitmap.height; _y++ ) {
					//drawSprite(loadedData.charCodeAt(_y*10+_x)-48, _x, _y);
					
					
					drawSprite((global.levelBitmap.bitmapData.getPixel(_x, _y)& 0x0000FF), _x, _y);
					global.nodes[_x][_y] = new node(_x, _y, (global.levelBitmap.bitmapData.getPixel(_x, _y)& 0x0000FF) );
					//drawSprite((global.levelBitmap.bitmapData.getPixel(_x, _y)& 0x00FF00)>>8, _x, _y);
					//drawSprite((global.levelBitmap.bitmapData.getPixel(_x, _y)& 0xFF0000)>>16,  _x, _y);
					
					//trace(loadedData.charCodeAt(_y*10+_x)-65, _x);
					}
					//trace(global.nodes[_y]);
			}
			
		}
		
		
		private function drawSprite(tile:int,x:int,y:int):void
		{
			//trace(tile & 0x0000FF,(tile & 0x00FF00)>>8,(tile & 0xFF0000)>>16);
			
			var BlitPoint:Point = new Point(x * tileWidth, y * tileHeight);
			
			mapBitmapData.lock();
			blitRect.x = (tile % tilesPerRow) * tileWidth;
			blitRect.y = int(tile / tilesPerRow) * tileHeight;
			//trace(blitRect.x / tileWidth);
			mapBitmapData.copyPixels(global.terrainBitmap.bitmapData, blitRect, BlitPoint);
			mapBitmapData.unlock();
			
			
		}
		
	}

}