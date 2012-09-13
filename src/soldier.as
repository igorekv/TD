package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author igorek
	 */
	public class soldier extends buddy
	{
		

		
		
	private var deadCount:int = 5;
		private var curX:Number;//текущая точка
		private var curY:Number;
		internal var targetX:int;//цель для движения
		internal var targetY:int;
		

		
		private var walkState:int = 0;
		private var currentSector:node;
		private var sectorSlot:int = 0;
		
		
		
		public function soldier(x:int, y:int, _targetX:int = 0,_targetY:int=0 ) 
		{
			animationSpeed = 100;//милисекунд между кадрами
			life = 1000;
			damage = 10;
			speed = 3;
			rateofFire = 5;
			tileHeight = 22;
			
			
			displayBitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff);
			displayBitmap = new Bitmap(displayBitmapData); 
			blitRect = new Rectangle(0, 0, tileWidth, tileHeight);
			
			this.x=curX = targetX = x; this.y=curY = targetY = y;
			if (_targetX != 0 && targetY != 0) { targetX = _targetX; 
			targetY = _targetY;}
			//таймер расчета
			mainTimer = new Timer(10);
			mainTimer.start();
			mainTimer.addEventListener(TimerEvent.TIMER, draw);
			
			//таймер анимации
			animationTimer = new Timer(animationSpeed);
			animationTimer.start();
			animationTimer.addEventListener(TimerEvent.TIMER, animateSprite);
			
			
			//this.addEventListener(Event.ENTER_FRAME, draw)	;
			
			//sprite.graphics.beginFill(0x33cc33);
			//sprite.graphics.drawRect(0, 0, global.TILE_WIDTH, global.TILE_HEIGHT);
			//sprite.graphics.endFill();
			sprite.visible = true;
			//sprite.x = -5; sprite.y = -5;
			
			texture = global.soldierBitmap;
			addChild(sprite);
			addChild(displayBitmap);
			addEventListener(MouseEvent.CLICK, onclick);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			//trace('soldier', this.width)	;
			
			statBar = new statusBar(life, 100);
			statBar.setWidth(this.width);
			addChild(statBar);
		}
		private function mouseDown(e:MouseEvent):void {
			global.startSelect = true;
			
			}
		public function draw(e:Event):void {//при выводе на экран
			oldX = this.x;
			oldY = this.y;
			intTimer++;
			if (intTimer == 3 || intTimer == 6 || intTimer==9  ) { global.cleanGarbage(); }
			
			if (toDelete) {//действия при смерти
				if (deadCount < 0) { 
					//удаление обьекта
					this.toRemove = true; 
					mainTimer.stop();
					mainTimer.removeEventListener(TimerEvent.TIMER, draw);
					//this.removeEventListener(Event.ENTER_FRAME, draw);
					}
				deadCount--;
				
			}else{
			
			sprite.graphics.clear();
		if (select) { 
			sprite.graphics.lineStyle(4, 0xFFFF00,0.3); sprite.graphics.drawEllipse(0, global.TILE_HEIGHT, global.TILE_WIDTH + 4, global.TILE_HEIGHT / 2);
			sprite.graphics.lineStyle(0.5, 0xFFFF00); sprite.graphics.drawEllipse(0, global.TILE_HEIGHT, global.TILE_WIDTH + 4, global.TILE_HEIGHT / 2);
			
		
		
			}
			//sprite.graphics.beginFill(0x33cc33);
			
			//sprite.graphics.endFill();
			
			if(Math.abs(int(curX)-targetX)>1 || Math.abs(int(curY)-targetY)>1)  {//если до цели еще далеко
			if (walkState == 0) {  walkState = 1; }//if (currentSector) { currentSector.leave(sectorSlot); } }
			var len:Number = destCalc(Math.abs(curX - targetX), Math.abs(curY - targetY));
			if (len > 0) {
			curX +=(targetX - curX) / len;
			curY += (targetY - curY) / len;
			}
			}
			else 
			{//если пришли до цели
				if (walkState == 1) { this.select = false;walkState = 0;  } 
			}
			
			this.x = curX;
			this.y = curY;
			checkFire(global.foeArmy);
			}
			if (intTimer >= 10) { intTimer = 0;}
			
		}
		
		public function hit(dmg:int):void
		{
			life -= dmg;
			statBar.draw(life);
			//global.stat_bullHitCount++;
			//global.stat_dmgCount += dmg;
			if (life < 0 && !this.toDelete)
			{
				dead();
			}
		}
		
		private function dead():void
		{
			//
			//parent.removeChild(this);
			//global.score += 10;
			//global.money += 5;
			//statBar.show("$"+5);
			this.toDelete = true;
		}
		
		private function getPosition():void {
		trace('getposition надо удалить');
			currentSector = global.getSector(this.x,this.y);//int(this.x / global.SECTOR_WIDTH)][int(this.y / global.SECTOR_HEIGHT)]
		var coord:Vector.<int> = currentSector.getPosition();
		if(coord.length!=0){
		targetX = coord[0];
		targetY = coord[1];
		sectorSlot = coord[2];
		}else { currentSector = null;}
		}
		
		
		
		
		
		
		
		private function onclick(e:MouseEvent):void {
			//trace('click');
			if(global.gameMode()==global.MODE_GAME){
			global.startSelect = false;
			
			global.cleanSelection();
			//var len:int = global.myArmy.length; for (var i:int = 0; i < len; i++) { if (global.myArmy[i].select) { global.myArmy[i].select = false; }; } //очищаем выделение
			if (select) { select = false; } else { select = true; }
			}
		}
		
		public function setTarget(_x:int, _y:int):Boolean {
			
			//targetX = x; targetY = y;
			if (currentSector != null) {  currentSector.leave(sectorSlot); }
		currentSector = global.getSector(_x,_y);//int(this.x / global.SECTOR_WIDTH)][int(this.y / global.SECTOR_HEIGHT)]
		var coord:Vector.<int> = currentSector.getPosition();
		if(coord.length!=0){
		targetX = coord[0];
		targetY = coord[1];
		sectorSlot = coord[2];
		return true;
		}else { currentSector = null; return false; }
			
			
		}
	
		
	}

}