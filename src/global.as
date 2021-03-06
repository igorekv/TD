package
{
	import flash.display.Sprite;
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
		public static const STAGE_HEIGHT:int = 500;
		public static const TILE_HEIGHT:int = 16;
		public static const TILE_WIDTH:int = 16;
		public static var LEVEL_WIDTH:int = 31;
		public static var LEVEL_HEIGHT:int = 27;
		public static const MAP_WIDTH:int = LEVEL_WIDTH*TILE_WIDTH;
		public static const MAP_HEIGHT:int = LEVEL_HEIGHT*TILE_HEIGHT;
		public static const TOPMENU_HEIGHT:int = 20;
		public static var LEVEL_TARGET_X:int;
		public static var LEVEL_TARGET_Y:int;
		public static const FIRE:int = 0;
		public static const SMOKE:int = 2;
		public static var smoke:Bitmap = new Bitmap();//картинка дыма
		public static var bulletBitmap:Bitmap = new Bitmap();//картинка пуль
		public static var terrainBitmap:Bitmap = new Bitmap();//картинка карты
		public static var levelBitmap:Bitmap = new Bitmap();//картинка уровня
		public static var buttonBitmap:Bitmap = new Bitmap();//картинка кнопок
		public static var sfx1Bitmap:Bitmap = new Bitmap();//картинка sfx1
		public static var soldierBitmap:Bitmap = new Bitmap();//картинка слодата
		public static var levelInfo:Object = new Object();
		public static var mobConfig:Object = new Object();
		public static var skill:Array=new Array();
		
		public static const NODES_PER_SECTOR:int = 4;
		public static const UNIT_PER_SECTOR:int = 6;
		public static const radian:Number = 180 / Math.PI;
		public static const degree:Number = Math.PI / 180;
		public static var levelTime:Timer = new Timer(1000);
		public static var lastWave:Boolean = false;
		public static var waveNumber:int = 0;
		public static var ownBase:myBase;
		public static var myArmy:Array = new Array(); //массив с солдатами
		public static var foeBase:enemyBase;
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
		public static var money:int = 900;//деньги
		public static var time:int = 60;
		public static var lives:int = 10;
		public static var uiMenu:userInterface; 
		public static var magazine:Vector.<bullet>=new Vector.<bullet>;
		public static var sfxlist:Vector.<sfx>=new Vector.<sfx>;
		public static const SECTOR_WIDTH:int = TILE_WIDTH * NODES_PER_SECTOR;
		public static const HALF_SECTOR:int = (TILE_WIDTH * NODES_PER_SECTOR)/2;
		public static const SECTOR_HEIGHT:int = TILE_HEIGHT * NODES_PER_SECTOR;
		public static const MODE_GAME:String = 'mode_game';
		public static const MODE_OVER:String = 'mode_over';
		public static const MODE_BUILD:String = 'mode_build';
		public static var gameModeFlag:String = "";
		
		//для разработки
		public static var tempCounter:int=0
		
		//public static var nodes:Array = new Array();//массив для a*
		public function global()
		{
		
		}
		
		
		
		/*
		public static function onLoadTextComplete(e:Event, dest:Object):void
		{
			dest.text = e.target.data;
			loadStatus++;
		}
		*/
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
			
			for (var i:int = 0; i < foeArmy.length; i++)//убираем трупы врагов
			{
				if (foeArmy[i].toRemove)
				{
					uiMenu.layer1.removeChild(foeArmy[i]);
					//trace("deleting", foeArmy[i].name);
					foeArmy.splice(i, 1);
					tmp = true;
					
				}
			}
			for (var j:int = 0; j < myArmy.length; j++)//убираем свои трупы
			{
				if (myArmy[j].toRemove)
				{
					uiMenu.layer1.removeChild(myArmy[j]);
					//trace("deleting", myArmy[i].name);
					myArmy.splice(j, 1);
					tmp = true;
					
				}
			}
			for (var k:int = 0; k < magazine.length;k++ ) {//убираем пули
				
				//trace(">", i);
				if (magazine[k].toRemove) { 					
					uiMenu.layer1.removeChild(magazine[k]);
					magazine.splice(k, 1);
					}
			}
			for (var l:int = 0; l < sfxlist.length;l++ ) {//убираем эфекты
				
				//trace(">", i);
				if (sfxlist[l].toRemove) { 					
					uiMenu.layer1.removeChild(sfxlist[l]);
					sfxlist.splice(l, 1);
					}
			}
			
		}
		public static function gameMode():String {
			return gameModeFlag;
		}
		
		public static function changeGameMode(str:String):void {
			//trace(str);
			gameModeFlag = str;
		}
		
		public static function destCalc(x1:int, y1:int, x2:int, y2:int, type:int):Number {
			//trace("параметры", x1, y1, x2, y2);
			var dstx:int = Math.abs(x1 - x2);
			var dsty:int = Math.abs(y1 - y2);
			//trace("до цели х", dstx, "до цели у", dsty);
			var dest:Number=0;
			if (type == 1) {
				dest=Math.sqrt((dstx*dstx) + (dsty *dsty));
			}
			if (type == 2) {
				if (dstx > dsty) { dest = 1.4 * dsty + (dstx - dsty);}else{dest = 1.4 * dstx + (dsty - dstx);}
			}
			//trace("destination", dest);
			return dest;
		}
		
		public static function getAngle(x:int, y:int):int
		{
			return Math.atan2(y, x) * global.radian + 180;
		}
	
		
		public static function chkDest(cur:node, dest:node):Boolean {
			if (cur.x != dest.x || cur.y != dest.y) {
				return true
			}else {
				return false
				}
		}
		
		
		public static function getSector(_x, _y):node {
			
		var it:int = _y / 48;
		var jt:int = (_x - (it % 2 * 32)) / 64;
		var xt:int = (_x - (it % 2 * 32))-jt*64;
		var yt:int = _y - it * 48;
		var i:int = 0;
		var j:int = 0;
		if (yt < 16) {
		//trace("drw");
		if (yt < (32 - xt) / 2 && xt < 32) { it--; if (it % 2) { jt-- };  };
		if (yt < (xt-32)/2 && xt > 32) { it--; if (!(it % 2)) {jt++}; };
			}
		//trace(jt, it);
		//trace(xt, yt);
		return sectors[jt][it];
			
			
		}
		public static function drawdot(_x, _y, _c = 0xFF0000):void {
			var dot = new Sprite();
				dot.graphics.beginFill(_c,0.2);	
				dot.graphics.drawRect(_x, _y, 16, 16);
				dot.graphics.endFill();
				global.uiMenu.layer1.addChild(dot);
			
		}
		
			
		public static function chkArray(list:Vector.<node>, _x,_y):Boolean {
			//for (var i:int = 0; i < list.length;i++){
			for(var i in list){	
				if (list[i].x == _x && list[i].y == _y){
					return true
				}
			}
			return false;
			
		}
		
		public static function popNode(list:Vector.<node>, _x,_y):node {
			//for (var i:int = 0; i < list.length;i++){
			for(var i in list){	
				if (list[i].x == _x && list[i].y == _y){
					return list[i];
				}
			}
			//trace("ERROR не нашлась нода в списке!!!");
			return null;
			
			
		}
		
		
		
		public static function findPath(start:node, dest:node):Array
		{
			var _start:node = start.copy();
			var path:Array = new Array();
			var oList:Vector.<node> = new Vector.<node>();
			var cList:Vector.<node> = new Vector.<node>();
			var currentNode:node = _start;
			oList.push(currentNode);
			var timer:int = getTimer();
			
			//while (chkDest(currentNode,dest))
			var tmpCouter:int = 0;
			while (oList.length)
			{
				
				//trace(currentNode.nodeName);//трейс
				var timertmp:int = getTimer();
				//trace(oList.length);
				var best:node = oList[0];
				var oListPos:int = 0;
				for (var j in oList) {
					if (best.f > oList[j].f) { best = oList[j]; oListPos=j }
					}
				currentNode = best;
				
				oList.splice(oListPos, 1); //убираем ее из очереди
			
				cList.push(currentNode); //добавляем в список проверенных
				
				for (var i:int = 0; i < 9; i++)
				{
					var _x:int = (currentNode.x - 1) + (i % 3);
					var _y:int = (currentNode.y - 1) + int(i / 3);
					
					
					if ((_x >= 0 && _x < global.nodes.length-1) && (_y >= 0 && _y < global.nodes[0].length-1)  )
					{
					if(global.nodes[_x][_y].k < 420){
						
						
						tmpCouter++;
					
						if (!chkArray(cList, _x,_y))
						
						{ //если нода не находится в закрытом листах
							
							var cost:int = 50; //цена на переход по горизонтали/вертикали
							if (i == 0 || i == 2 || i == 6 || i == 8){cost = 70;} //цена по диагонали
					
							
							var new_node:node = popNode(oList, _x, _y);
							//trace(new_node);
							if (new_node==null)//!chkArray(oList, _x,_y))
							{
								var new_node:node = global.nodes[_x][_y].copy();
								var tempG:int = currentNode.g + cost + new_node.k
								var tempH:int = (Math.abs(new_node.x - dest.x) + Math.abs(new_node.y - dest.y)) * 1; //манхе
								
								//drawdot(new_node.x * 16, new_node.y * 16);
								oList.push(new_node); 
								new_node.g += tempG;
								new_node.h = tempH
								new_node.f = new_node.g + new_node.h;
								new_node.parentNode = currentNode;
							}
							else
							{
								
								
								//var new_node = popNode(oList, _x, _y);
								var tempG:int = currentNode.g + cost + new_node.k
								var tempH:int = (Math.abs(new_node.x - dest.x) + Math.abs(new_node.y - dest.y)) * 1; //манхе
								if (new_node.g > tempG)
								{
									new_node.g += tempG;
									new_node.h = tempH;
									//global.nodes[_x][_y].h = 10*Math.sqrt((global.nodes[_x][_y].x - dest.x) * (global.nodes[_x][_y].x - dest.x) + (global.nodes[_x][_y].y - dest.y) * (global.nodes[_x][_y].y - dest.y));//euqlid
									new_node.f = new_node.g + new_node.h;
									new_node.parentNode = currentNode;
								
								}
								
							}
							
							
						}
					}//не искать 255
					
					}
					
				}
			if (_x == dest.x && _y == dest.y) { break}
			}
			
			trace(getTimer() - timer, "ms",tmpCouter,"iterations",oList.length,"Olist");
			
			
			
			
			
			var _node:node = currentNode;
			path.push(_node);
			while (_node != _start)
			{
				_node = _node.parentNode;
				path.unshift(_node);
			}
			
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
			//trace(getTimer() - timer);
			
			return path;
		}
	
		public static function cleanSelection():void {
			
			var len:int = global.myArmy.length;
						for (var i:int= 0; i < len; i++)
						{
							
							if (global.myArmy[i].select)
							{
								global.myArmy[i].deSelect();
							}
							
						}
		}
	
	
		/*public static function loadText(path:String, dest:Object):void
		{
			loadQueue++;
			var loader:URLLoader = new URLLoader(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{onLoadTextComplete(e, dest);})
		}*/
		public static function loadText():void {
		global.levelInfo.text = "Level One time level pos,41,4\r\n\
		10, 5, 6; 10, 5, 3; 10, 5, 6; 10, 5, 5; 10, 5, 4\r\n\
		10, 1, 4; 10, 2, 5; 10, 3, 6; 10, 1, 3; 10, 1, 4; 10, 2, 5; 10, 3, 6; 10, 1, 5; 10, 1, 4; 10, 2, 5; 10, 1, 6; 10, 1, 6; 10, 1, 4; 10, 2, 5; 10, 3, 6; 10, 4, 3; 10, 5, 4; 10, 2, 5; 10, 3, 6; 10, 4, 4; 10, 5, 4; 10, 2, 5; 10, 3, 6; 10, 4, 5; 10, 5, 4; 10, 2, 5; 10, 3, 6; 10, 4, 6; 10, 5, 4; 10, 2, 5; 10, 3, 6; 10, 4, 3; 10, 5, 4; 10, 2, 5; 10, 3, 6; 10, 4, 2; 10, 5, 4"; //global.loadText('level1.txt', );

		global.mobConfig.text = "life,speed,firerate,damage\r\n\
		50, 1, 20, 10\r\n\
		60, 2, 10, 10\r\n\
		70, 3, 10, 10\r\n\
		50, 4, 10, 10\r\n\
		60, 5, 10, 10\r\n\
		70, 2, 10, 10r\n";//global.loadText('mobConfig.txt', global.mobConfig);
			trace(global.levelInfo);
		}
		
		}

}