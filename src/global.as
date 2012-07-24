package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author igorek
	 */
	public class global
	{
		private var loader:Loader; //загрузщик
		
		//библиотека картинок
		public static const STAGE_WIDTH:int = 640;
		public static const STAGE_HEIGHT:int = 480;
		public static const FIRE:int = 0;
		public static const SMOKE:int = 2;
		public static var smoke:Bitmap = new Bitmap();
		public static var bulletBitmap:Bitmap = new Bitmap();
		public static var terrainBitmap:Bitmap = new Bitmap();
		public static var levelBitmap:Bitmap = new Bitmap();
		public static var levelInfo:Object = new Object();
		public static const TILE_HEIGHT:int = 16;
		public static const TILE_WIDTH:int = 16;
		public static const NODES_PER_SECTOR = 4;
		public static const UNIT_PER_SECTOR = 6;
		public static const radian:Number = 180 / Math.PI;
		public static const degree:Number = Math.PI / 180;
		public static var levelTime:Timer = new Timer(1000);
		public static var lastWave:Boolean = false;
		public static var waveNumber:int = 0;
		public static var myArmy:Array = new Array(); //массив с солдатами
		public static var foeArmy:Array = new Array(); //массив с врагами
		public static var loadQueue:int = 0;
		public static var loadStatus:int = 0;
		public static var startSelect:Boolean = false; //служебная для определения кликов по обьекту
		public static var mouseState:Boolean = false; //служебная для определения состояния кнопки мышки
		public static var tmp:Boolean = false;
		public static var stat_bulletCount:int = 0;
		public static var stat_bullHitCount:int = 0;
		public static var stat_dmgCount:int = 0;
		public static var nodes:Vector.<Vector.<node>> = new Vector.<Vector.<node>>(); //массив нод для поиска пути
		public static var sectors:Vector.<Vector.<node>> = new Vector.<Vector.<node>>(); //массив нод для поиска пути
		public static var score:int = 0;
		public static var money:int = 100;
		public static var time:int = 60;
		public static var uiMenu:userInterface; 
		public static const SECTOR_WIDTH:int = TILE_WIDTH * NODES_PER_SECTOR;
		public static const SECTOR_HEIGHT:int = TILE_HEIGHT * NODES_PER_SECTOR;
		
		//public static var nodes:Array = new Array();//массив для a*
		public function global()
		{
		
		}
		
		
		public static function loadText(path:String, dest:Object):void
		{
			loadQueue++;
			var loader:URLLoader = new URLLoader(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{onLoadTextComplete(e, dest);})
		}
		
		public static function onLoadTextComplete(e:Event, dest:Object):void
		{
			dest.text = e.target.data;
			loadStatus++;
		}
		
		public static function loadBitmap(path:String, dest:Bitmap):void
		{
			loadQueue++;
			var loader:Loader = new Loader();
			loader.load(new URLRequest(path)); //загрузка спрайтлиста	
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{onLoadBitmapComplete(e, dest);})
		}
		
		public static function onLoadBitmapComplete(e:Event, dest:Bitmap):void
		{
			
			var bitmapdata:BitmapData = e.target.loader.content.bitmapData; //loader.content.bitmapData; //получаем данные о спрайтах	
			dest.bitmapData = bitmapdata;
			loadStatus++;
		
		}
		public static function prepText(text:String, size:int, color:int,sel:Boolean=false):TextField {
			var txtFld:TextField = new TextField();
			txtFld.embedFonts = true;
			txtFld.defaultTextFormat = new TextFormat('stencil', size, color);
			txtFld.backgroundColor = 0xFF0000;
			txtFld.autoSize = TextFieldAutoSize.LEFT;
			txtFld.selectable = sel;
			txtFld.text = text;
			return txtFld;
		}
		
		public static function cleanGarbage():void
		{
			for (var i:int = 0; i < foeArmy.length; i++)
			{
				if (foeArmy[i].toDelete)
				{
					trace("deleting", foeArmy[i].name);
					foeArmy.splice(i, 1);
					tmp = true;
					
				}
			}
		}
		
		public static function getAngle(x:int, y:int):int
		{
			return Math.atan2(y, x) * global.radian + 180;
		}
		
		public static function findPath(start:node, dest:node):Array
		{
			
			var path:Array = new Array();
			var oList:Vector.<node> = new Vector.<node>();
			var cList:Vector.<node> = new Vector.<node>();
			var currentNode:node = start;
			oList.push(start);
			var timer:int = getTimer();
			var sortFlag:Boolean = false;
			while (currentNode != dest)
			{
				var timertmp:int = getTimer();
				if (sortFlag) { oList.sort(Array.NUMERIC); sortFlag = false; }
				currentNode = oList[0]; //берем первую ноду
				oList.splice(0, 1); //убираем ее из очереди
				cList.push(currentNode); //добавляем в список проверенных
				
				for (var i:int = 0; i < 9; i++)
				{
					var _x:int = (currentNode.x - 1) + (i % 3);
					var _y:int = (currentNode.y - 1) + int(i / 3);
					if ((_x >= 0 && _x < global.nodes.length) && (_y >= 0 && _y < global.nodes[0].length))
					{
						
						
						if (cList.indexOf(global.nodes[_x][_y]) < 0)
						{ //если нода не находится в открытом или закрытом листах
							var cost:int = 10; //цена на переход по горизонтали/вертикали
							if (i == 0 || i == 2 || i == 6 || i == 8)
							{
								cost = 14;
							} //цена по диагонали
							var tempG:int = currentNode.g + cost + global.nodes[_x][_y].k
							var tempH:int = (Math.abs(global.nodes[_x][_y].x - dest.x) + Math.abs(global.nodes[_x][_y].y - dest.y)) * 5; //манхетен
							if (oList.indexOf(global.nodes[_x][_y]) < 0)
							{
								oList.push(global.nodes[_x][_y]); sortFlag = true;
								global.nodes[_x][_y].g += tempG;
								global.nodes[_x][_y].h = tempH
								//global.nodes[_x][_y].h = 10*Math.sqrt((global.nodes[_x][_y].x - dest.x) * (global.nodes[_x][_y].x - dest.x) + (global.nodes[_x][_y].y - dest.y) * (global.nodes[_x][_y].y - dest.y));//euqlid
								global.nodes[_x][_y].f = global.nodes[_x][_y].g + global.nodes[_x][_y].h;
								//trace(global.nodes[_x][_y].nodeName, global.nodes[_x][_y].k);
								global.nodes[_x][_y].parentNode = currentNode;
							}
							else
							{
								if (global.nodes[_x][_y].g > tempG)
								{
									global.nodes[_x][_y].g += tempG;
									global.nodes[_x][_y].h = tempH;
									//global.nodes[_x][_y].h = 10*Math.sqrt((global.nodes[_x][_y].x - dest.x) * (global.nodes[_x][_y].x - dest.x) + (global.nodes[_x][_y].y - dest.y) * (global.nodes[_x][_y].y - dest.y));//euqlid
									global.nodes[_x][_y].f = global.nodes[_x][_y].g + global.nodes[_x][_y].h;
									global.nodes[_x][_y].parentNode = currentNode;
								}
							}
							
								//trace("node:", global.nodes[_x][_y].nodeName, "go:", cost, "heuristic:", global.nodes[_x][_y].h,"weight:",global.nodes[_x][_y].k,"full:",global.nodes[_x][_y].f);
							
						}
					}
					;
				}
				
				//if (start != currentNode) { trace("curent node:", currentNode.nodeName,"parentNode:",currentNode.parentNode.nodeName);}// trace(oList);
				//oList.sort();
				/*
				if (getTimer() - timer >= 10000)
				{
					break;
				}
				; //если очень долго то выход
				*/
			}
			trace(getTimer() - timer);
			
			var _node:node = dest;
			path.push(_node);
			while (_node != start)
			{
				_node = _node.parentNode;
				path.unshift(_node);
			}
			trace(getTimer() - timer);
			var len:int = path.length;
			path[0].mapX = (path[0].x + path[0].x + path[1].x) / 3 * TILE_WIDTH;
			path[0].mapY = (path[0].y + path[0].y + path[1].y) / 3 * TILE_HEIGHT;
			for (var i:int = 1; i < len - 1; i++)
			{
				path[i].mapX = (path[(i - 1)].x + path[i].x + path[(i + 1)].x) / 3 * TILE_WIDTH;
				path[i].mapY = (path[i - 1].y + path[i].y + path[i + 1].y) / 3 * TILE_HEIGHT;
			}
			path[len - 1].mapX = (path[len - 2].x + path[len - 1].x + path[len - 1].x) / 3 * TILE_WIDTH;
			path[len - 1].mapY = (path[len - 2].y + path[len - 1].y + path[len - 1].y) / 3 * TILE_HEIGHT;
			trace(getTimer() - timer);
			return path;
		}
	
	/*
	   public function checkList(_node:node,) {
	   for (var i:int = 0; i < 9; i++) {
	
	   }
	 */
	
	}

}