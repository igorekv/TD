package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import bullet;
	import fire;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.text.Font;
	import global;
	import flash.display.Bitmap;
	import map;
	import mapEditor;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import SWFProfiler;
	
	
	
	public class Main extends Sprite
	{
		[Embed (  source = "../lib/STENCIL.TTF", fontFamily = "stencil",  mimeType = 'application/x-font-truetype',embedAsCFF="false") ]private var CooperFont:Class;
		
		private var loadingTxt:TextField = new TextField();
		private var loadingTmp:int = 0;
		private var frame:int = 0;
		private var mapLevel:map;
		private var mapEdit:mapEditor;
		private const MOUSEDELAY:int = 5; //чувствительность мышки к кликам или выделению
		private var mouseDelay:int = MOUSEDELAY;
		private var selection:selectTool;
		private var mX:int;
		private var mY:int;
		private var game:Sprite=new Sprite();
		private var mariner:soldier;
		private var dummy:enemy;
		private var menu:Sprite = new Sprite();//экран с меню
		private var uiMenu:userInterface = new userInterface();
		public function Main()
		{
			
			global.loadBitmap("bullet.png", global.bulletBitmap);
			global.loadBitmap("terrain2.png", global.terrainBitmap);
			global.loadBitmap("level4.png", global.levelBitmap);
			global.loadText('level1.txt', global.levelInfo);
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			SWFProfiler.init(stage, this);
			loadingTxt.y = Math.random() * 100;
			loadingTxt.text = "loading..." + String(loadingTmp);
			addChild(loadingTxt);
//			stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal;
			//trace(stage.loaderInfo.bytesTotal);
			
			
		
			addEventListener(Event.ENTER_FRAME, loadingWait); //запускаем ожидание пока загрузятся ресурсы
		}
		
		private function loadingWait(e:Event):void
		{ 
			
			loadingTmp++;
			if (global.loadQueue == global.loadStatus)
			{
				removeEventListener(Event.ENTER_FRAME, loadingWait);
				removeChild(loadingTxt);
				//addEventListener(Event.ENTER_FRAME, onEnterFrame)
				afterLoading();
				
			}
			
		}
		
		private function afterLoading():void
		{
			//showMenu();//отображает меню
			showGame();//запускает игру
			
			
		}
		
		private function showMenu() {
			
			
			menu.graphics.beginFill(0x333333);
			menu.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			menu.graphics.endFill();
			var button:Sprite = new Sprite()
			button.graphics.beginFill(0xaaaaaa);
			button.graphics.drawRect(global.STAGE_WIDTH/3-100, global.STAGE_HEIGHT/2-10,200,20);
			button.graphics.endFill();
			button.addEventListener(MouseEvent.CLICK, menuPlay);
			var buttonText:TextField = global.prepText('Play', 14, 0x777777);
			buttonText.x = global.STAGE_WIDTH / 3;
			buttonText.y = global.STAGE_HEIGHT / 2-9;
			button.addChild(buttonText);
			menu.addChild(button);
			
			addChild(menu);
			
		}
		
		private function menuPlay(e:MouseEvent) {
			e.target.removeEventListener(MouseEvent.CLICK, menuPlay);
			removeChild(menu);
			showGame();
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function showGame() {
			
			//addChild(global.prepText("tst1 level 1", 14, 0xFFFFFF));
			
			//едитор--------------------------
			//mapEdit = new mapEditor();
			//addChild(mapEdit);
			
			//карта----------------------------
			
			mapLevel = new map(1);
			//mapLevel.scaleX = mapLevel.scaleY=0.5;
			uiMenu.layer1.addChild(mapLevel);
			//юзеринтерфейс
			addChild(uiMenu);
			uiMenu.update();
			//солдатики---------------
			/*mariner = new soldier(20, 20);
			global.myArmy.push(mariner);
			addChild(mariner);
			
			/*mariner = new soldier(200, 100);
			global.myArmy.push(mariner);
			addChild(mariner);
			
			mariner = new soldier(100, 200);
			global.myArmy.push(mariner);
			addChild(mariner);
			//враги-----------------------
			dummy = new enemy(150, 150);
			global.foeArmy.push(dummy);
			addChild(dummy);
			*/
			
			//parseLevel();
			/*
			dummy = new enemy(100, 150);
			global.foeArmy.push(dummy);
			addChild(dummy);
		
			
			*/
			
		}
		
		
		private function parseLevel():void {
			var strings:Array = global.levelInfo.text.split('\r\n');
			global.levelInfo.levelName = strings[0];//название уровня
			trace(global.levelInfo.levelName);
			var tmp:Array = strings[1].split(';');
			global.levelInfo.levelPath = new Array();
			for (var i:int = 0; i < tmp.length;i++ ){//тропинка
			global.levelInfo.levelPath[i] = tmp[i].split(',');
			}
			
			
			//trace(global.levelInfo.levelPath[2][0]);
			}
			
			
		private function onEnterFrame(e:Event):void
		{
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			if (frame == 1)
			{
				frame = 0;
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
		global.cleanGarbage();
		//trace(global.stat_bulletCount, global.stat_bullHitCount);
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			/*var len = global.myArmy.length; for (var i:int= 0; i < len; i++) {
			   if (global.myArmy[i].select) { global.myArmy[i].select = false; }
			
			   };
			 */
			global.mouseState = true; //запоминаем координаты мышки в момент нажатия
			mX = e.stageX;
			mY = e.stageY;
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			//если мыш двигалась с нажатой кнопкой
			
			if (mouseDelay != MOUSEDELAY)
			{
				//если было выделение
				if (mouseDelay == 0)
				{
					
					removeChild(selection); //убираем рамку
					selection.select(e.stageX, e.stageY) //выделяем все что было в рамке
				}
				else
				{
					click(e);
				}
				//если выделения небыло восстанавливаем таймер 
				mouseDelay = MOUSEDELAY;
				
			}
			else
			{ //если мыш не двигалась а просто был клик
				
				click(e);
				
			}
			
			global.mouseState = false;
		
		}
		
		private function click(e:MouseEvent):void
		{
		
			if (!global.startSelect)
			{
				
				//устанавливаем цель
				
				for (var i:int= 0; i <global.myArmy.length; i++)
				{
					if (global.myArmy[i].select)
					{
						global.myArmy[i].setTarget(e.stageX, e.stageY);
						global.myArmy[i].select=false;
					}
				}
			}
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			if (global.mouseState)
			{ //проверяем нажата ли мышка
				
				mouseDelay--; //уменьшаем таймер при котором мыш нажата и двигается
				if (mouseDelay <= 0)
				{ //если таймер закончился
					//если -1 то создаем рамку, если 0 то перерисовываем
					
					if (mouseDelay == 0)
					{
						//очищаем выделенные
						var len:int = global.myArmy.length;
						for (var i:int= 0; i < len; i++)
						{
							if (global.myArmy[i].select)
							{
								global.myArmy[i].select = false;
							}
							
						}
						selection = new selectTool(mX, mY);
						addChild(selection);
					}
					else
					{
						selection.draw(e.stageX, e.stageY);
					}
					
					//trace(mouseDelay);
					mouseDelay = 0;
				}
				
			}
		
		}
	
	}

}