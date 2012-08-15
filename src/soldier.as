package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author igorek
	 */
	public class soldier extends buddy
	{
		private var state:int;//состояние

		
		public var select:Boolean = false;//флаг выбран/невыбран
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
			
			life = 1000;
			damage = 10;
			speed = 3;
			rateofFire = 5;
			
			this.x=curX = targetX = x; this.y=curY = targetY = y;
			if(_targetX!=0 && targetY!=0){targetX = _targetX;
			targetY = _targetY;}
			mainTimer = new Timer(10);
			mainTimer.start();
			mainTimer.addEventListener(TimerEvent.TIMER, draw);
			
			//this.addEventListener(Event.ENTER_FRAME, draw)	;
			sprite.graphics.beginFill(0x33cc33);
			sprite.graphics.drawRect(0, 0, global.TILE_WIDTH, global.TILE_HEIGHT);
			sprite.graphics.endFill();
			//sprite.x = -5; sprite.y = -5;
			addChild(sprite);
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
		if (select) { sprite.graphics.lineStyle(2, 0xFF0033); }
			sprite.graphics.beginFill(0x33cc33);
			sprite.graphics.drawRect(0, 0, global.TILE_WIDTH, global.TILE_HEIGHT);
			sprite.graphics.endFill();
			
			if(Math.abs(int(curX)-targetX)>1 || Math.abs(int(curY)-targetY)>1)  {//если до цели еще далеко
			if (walkState == 0) {  walkState = 1; if (currentSector) { currentSector.leave(sectorSlot); } }
			var len:Number = destCalc(Math.abs(curX - targetX), Math.abs(curY - targetY));
			if (len > 0) {
			curX +=(targetX - curX) / len;
			curY += (targetY - curY) / len;
			}
			}
			else 
			{//если пришли до цели
				if (walkState == 1) {  getPosition(); walkState = 3; this.select = false; } else { walkState = 0;  } 
			}
			
			this.x = curX; this.y = curY;
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
		currentSector=global.sectors[int(this.x / global.SECTOR_WIDTH)][int(this.y / global.SECTOR_HEIGHT)]
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
		
		public function setTarget(x:int, y:int):void {
			
			targetX = x; targetY = y;
			
			
		}
	
		
	}

}