package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
		
	public class mapEditor extends Sprite
	{
		private var mapWidth:int = 10;
		private var mapHeight:int = 5;
		private var tileWidth:int = 16;
		private var tileHeight:int = 16;
		private var tilesPerRow:int = 9;
		private var tilesPerCol:int = 9;
		private var mapBitmapData:BitmapData=new BitmapData(mapWidth*tileWidth,mapHeight*tileHeight,false,0xFFFFFF);// экранный обьект
		private var mapBitmap:Bitmap=new Bitmap(mapBitmapData);// экранный обьект
		private var loadedData:String;
		private var BlitPoint:Point; //точка начала копирования пикселей
		private var blitRect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight); //прямоугольник область копирования пикселей
		private var menu:Sprite = new Sprite();
		private var desk:map = new map(1);
		private var currentTile:int;
		private var minimap:Sprite = new Sprite();
		private var grid:Shape = new Shape();
		public function mapEditor() 
		{
		
			var tmp:int = 0;
			//mapBitmapData = global.levelBitmap.bitmapData;
			
			mapBitmap.bitmapData = global.terrainBitmap.bitmapData;
			mapBitmap.scaleX = mapBitmap.scaleY = 0.8;
			menu.addEventListener(MouseEvent.CLICK, selectTile);
			menu.addChild(mapBitmap);
			grid.graphics.lineStyle(1, 0xFFFFFF,0.5);
			
			for (var i:int = 0; i < tilesPerRow/2;i++ ){
			grid.graphics.drawRect(tileWidth*mapBitmap.scaleX*(i*2), 0, tileWidth*mapBitmap.scaleX,menu.height );
			}
			for (i = 0; i < tilesPerCol/2;i++ ){
			grid.graphics.drawRect(0,tileHeight*mapBitmap.scaleY*(i*2), menu.width,tileHeight*mapBitmap.scaleY );
			}
			
			
			menu.addChild(grid);
			this.addChild(menu);
			desk.scaleX = desk.scaleY = 1;
			desk.x = tileWidth * mapBitmap.scaleX * tilesPerRow;
			desk.addEventListener(MouseEvent.CLICK, setTile);
			this.addChild(desk);
			
			
			minimap.addChild(global.levelBitmap);
			
			minimap.y = desk.height;
			minimap.x = menu.width;
			this.addChild(minimap);
			
			
		}
		
		private function selectTile(e:MouseEvent):void {
			currentTile=int(e.localX/(tileWidth*mapBitmap.scaleX))+tilesPerRow*int(e.localY/(tileHeight*mapBitmap.scaleY));
		}
		
		private function setTile(e:MouseEvent):void {
			//trace(global.levelBitmap.bitmapData.getPixel(int(e.localX/tileWidth),int(e.localY/tileHeight)));
			global.levelBitmap.bitmapData.setPixel(int(e.localX / tileWidth), int(e.localY / tileHeight), currentTile);
			desk.updateMap();
			}
		
		
				
	}

}