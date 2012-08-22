package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import bullet;
	import fire;
	import flash.events.TimerEvent;
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
	import flash.utils.getTimer;
	
	
	
	public class Main extends Sprite
	{
		[Embed (  source = "../lib/STENCIL.TTF", fontFamily = "stencil",  mimeType = 'application/x-font-truetype',embedAsCFF="false") ]private var CooperFont:Class;
		
		private var loadingTxt:TextField = new TextField();
		private var loadingTmp:int = 0;
		private var frame:int = 0;
		private var mapLevel:map;
		private var mapEdit:mapEditor;
		private const MOUSEDELAY:int = 10; //чувствительность мышки к кликам или выделению
		private var mouseDelay:int = MOUSEDELAY;
		private var selection:selectTool;
		private var mX:int;
		private var mY:int;
		private var game:Sprite=new Sprite();
		private var mariner:soldier;
		private var dummy:enemy;
		private var menu:Sprite = new Sprite();//экран с меню
		private var gest:gestures;
		private var oldGameMode:String = "";
		
		
		public function Main()
		{
			
			global.loadBitmap("bullet.png", global.bulletBitmap);
			global.loadBitmap("terrain2.png", global.terrainBitmap);
			global.loadBitmap("level4.png", global.levelBitmap);
			global.loadBitmap("buttons.png", global.buttonBitmap);
			global.loadText('level1.txt', global.levelInfo);
			global.loadText('mobConfig.txt', global.mobConfig);
			
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
			//if (global.loadQueue == global.loadStatus)
			if(loadingTmp>20)
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
		
		private function showMenu():void {
			
			
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
		
		private function menuPlay(e:MouseEvent):void {
			e.target.removeEventListener(MouseEvent.CLICK, menuPlay);
			removeChild(menu);
			showGame();
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function showGame():void {
			gest = new gestures(stage);
			
			global.changeGameMode(global.MODE_GAME);
			
			global.uiMenu= new userInterface();
			//addChild(global.prepText("tst1 level 1", 14, 0xFFFFFF));
			
			//едитор--------------------------
			//mapEdit = new mapEditor();
			//addChild(mapEdit);
			
			//карта----------------------------
			parseLevel();
			prepareConfig();
			mapLevel = new map(1);
			//mapLevel.scaleX = mapLevel.scaleY=0.5;
			mapLevel.y = global.TOPMENU_HEIGHT;
			//global.uiMenu.layer1.addChild(mapLevel);
			//юзеринтерфейс
			addChild(global.uiMenu);
			global.uiMenu.update();
			global.levelTime.start();
			
			//солдатики---------------
			
			global.foeBase = new enemyBase();
			global.uiMenu.layer1.addChild(global.foeBase);	
			
			
			
			mariner = new soldier(150, 80);
			global.myArmy.push(mariner);
			global.uiMenu.layer1.addChild(mariner);
			
			/*
			mariner = new soldier(60, 90);
			global.myArmy.push(mariner);
			global.uiMenu.layer1.addChild(mariner);
			
			mariner = new soldier(200, 100);
			global.myArmy.push(mariner);
			global.uiMenu.layer1.addChild(mariner);
			
			//враги-----------------------
			/*
			dummy = new enemy(150, 150);
			global.foeArmy.push(dummy);
			global.uiMenu.layer1.addChild(dummy);
			
			
			//parseLevel();
			/*
			dummy = new enemy(100, 150);
			global.foeArmy.push(dummy);
			addChild(dummy);
		
			
			*/
			addEventListener(Event.ENTER_FRAME,onEnterFrame)
		}
		
		private function showOver():void {
			//геймоверскрин
			
			
			
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function prepareConfig() {
			
			
			var strings:Array = global.mobConfig.text.split('\r\n');
			//global.skill.push(new Array());
			for (var i:int = 1; i < strings.length; i++) {
				var infoTmp:Array=strings[i].split(',');
				global.skill[i]=new Array();
				global.skill[i]['life'] = infoTmp[0];
				global.skill[i]['speed'] =infoTmp[1];
				global.skill[i]['fireRate'] =infoTmp[2];
				global.skill[i]['damage'] =infoTmp[3];
				
				
			}
			
			
		}
		
		
		
		private function parseLevel():void {
			var strings:Array = global.levelInfo.text.split('\r\n');
			var infoTmp:Array = strings[0].split(',');
			global.levelInfo.levelName = infoTmp[0];//название уровня
		global.LEVEL_TARGET_X = infoTmp[1];
		global.LEVEL_TARGET_Y = infoTmp[2];
			
			
			global.levelInfo.wave = new Array();
			
			for (var wv:int = 0; wv < strings.length-1;wv++ ){//волны
				global.levelInfo.wave[wv] = new Array();
				var elements:Array = strings[wv+1].split(';');//разбиваем на строчки
				var fullTime:int = 0;
				for (var i:int = 0; i < elements.length; i++) {
					var unitTmp:Array = elements[i].split(',');
					fullTime += int(unitTmp[0]);//					timer, 	   health,    startPos,   fulltime
					global.levelInfo.wave[wv][i] = new waveElement(unitTmp[0], unitTmp[1],unitTmp[2], fullTime);
					if (i == 0) { fullTime = 0;}
					//trace(i,int(fullTime));
				}
				
			}
			//trace(global.levelInfo.wave[0][0].startTimer);
			
			}
			
			private function changeGameMode(cur:String):void {
				if (cur == global.MODE_GAME) {
					stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					
					}
				if (oldGameMode == global.MODE_GAME) {
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				}
				
				if (cur == global.MODE_BUILD) {
					stage.addEventListener(MouseEvent.MOUSE_MOVE, buildMouseMove);
					stage.addEventListener(MouseEvent.CLICK, buildClick);
				}
				if (oldGameMode == global.MODE_BUILD) {
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, buildMouseMove);
					stage.removeEventListener(MouseEvent.CLICK, buildClick);
					trace(global.ownBase);
					if(global.ownBase!=null){if(!global.ownBase.builded){global.ownBase = null;}}
					}
				if (cur == global.MODE_OVER) {
					trace('gameover');
				}
				
			}
			
			private function buildMouseMove(e:MouseEvent):void {
				var tmpy:int=int(mouseY / (global.TILE_HEIGHT*3)) * (global.TILE_HEIGHT*3);
				var tmpx:int=int((mouseX-32*((tmpy/global.TILE_HEIGHT*3)%2))/global.SECTOR_WIDTH)*global.SECTOR_WIDTH;
				if (((int(mouseY / (global.TILE_HEIGHT * 3))) & 1) != 0) { tmpx += 32; }
				global.ownBase.x = tmpx;
				global.ownBase.y  = tmpy;
				
				
			}
			
			private function buildClick(e:MouseEvent):void {
				if (e.stageY > global.TOPMENU_HEIGHT && e.stageY < global.TOPMENU_HEIGHT + global.MAP_HEIGHT) {
					global.changeGameMode(global.MODE_GAME);
					global.ownBase.build();
				}
			}
			
		private function onEnterFrame(e:Event):void	{
			global.cleanGarbage();
			if (global.lives == 0) {//gmover
				changeGameMode(global.MODE_OVER);
				showOver();
				}
			if (global.gameMode() != oldGameMode) { changeGameMode(global.gameMode());oldGameMode=global.gameMode() }
			
			if(global.gameMode()==global.MODE_GAME){ //игровой режим
			if (gest.check(gest.CANCEL)) {
				
				global.cleanSelection();
			}
			
			
			}
			if (global.gameMode() == global.MODE_BUILD) { 
				if (gest.check(gest.CANCEL)) { 
					global.uiMenu.layer1.removeChild(global.ownBase); 
					
					global.changeGameMode(global.MODE_GAME) 
					
					}
				
				
			}
			
			
			if (frame == 15)
			{
				if(global.uiMenu.updateUi){global.uiMenu.update();}
				frame = 0;
			}
			frame++;
		
		//trace(global.stat_bulletCount, global.stat_bullHitCount);
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			
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
		//trace("click", mouseX, mouseY);
		
		
		
			if(e.stageY>global.TOPMENU_HEIGHT && e.stageY<global.TOPMENU_HEIGHT+global.MAP_HEIGHT){
			if (!global.startSelect)
			{
				
				//устанавливаем цель
				
				for (var i:int= 0; i <global.myArmy.length; i++)
				{
					if (global.myArmy[i].select)
					{
						global.myArmy[i].setTarget(e.stageX, e.stageY);
						
					}
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
						global.cleanSelection();
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
				
			}else {
				if (frame == 1) {
					
					
				}
			}
			
		}
	
	}

}