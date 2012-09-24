package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author igorek
	 */
	public class myBase extends basicObject
	{
		
		public var builded:Boolean = false;
		public var target_x:int;
		public var target_y:int;
		public var health:int = 100;
		private var flashCount:int = 16;
		private var color:int = 0x00FF00;
		
		//private var cnter:int = 0;
		public function myBase() 
		{
			sprite = new Sprite();	
			draw();
				sprite.x = sprite.y = 32;
				addChild(sprite);
				life = 5000;
		}
		
		public function build():void {//строит базу на карте, срабатывает по клику
			
			global.getSector(this.x+global.HALF_SECTOR, this.y+global.HALF_SECTOR).deploy()
			
			builded = true;
			changeNodes(true);
			
			getPosition();
			oldX = this.x;
			oldY = this.y;
			
			global.money -= 100;
			global.myArmy.push(this);//список всех наших юнитов и построек
			// после постройки враги бросаются на базу
			for (var i:int  = 0; i < global.foeArmy.length; i++) {
			var toFinish:int=global.foeArmy[i].distToFinish();//до финиша
			var toBase:int = global.destCalc(this.x, this.y, global.foeArmy[i].x, global.foeArmy[i].y, 2);//до базы
			if(toBase<toFinish){global.foeArmy[i].findNewPath();}//если до базы ближе чем до финиша то изменить маршрут
				
			}
			//target_x = int((this.x+(this.width/2)) / global.TILE_WIDTH);
			//target_y = int((this.y +(this.height / 2)) / global.TILE_HEIGHT);
			
		}
		public function flash():void {//запускает мигание красным если базу нельзя поставить
			addEventListener(Event.ENTER_FRAME, changeColor);
			}
		
			private function changeColor(e:Event):void {//мигание цвета когда нельзя строить фция на каждый кадр
			flashCount--;
			if(flashCount==0 || flashCount==5 || flashCount==10 || flashCount==15) {
			if(color==0x00FF00){color=0xFF0000}else{color=0x00FF00}
			
			draw(color); 
			}
			if (flashCount < 0) { flashCount = 16;removeEventListener(Event.ENTER_FRAME, changeColor);}
				
			}
			
			private function draw(color:int=0x00FF00):void {//рисует базу
				sprite.graphics.clear();
				sprite.graphics.beginFill(color, 1);
				sprite.graphics.moveTo(32, 0);
				sprite.graphics.lineTo(32, 16);
				sprite.graphics.lineTo(0, 32);
				sprite.graphics.lineTo( -32, 16);
				sprite.graphics.lineTo(-32,-16);
				sprite.graphics.lineTo(0, -32);
				sprite.graphics.lineTo(32, -16);
				//sprite.graphics.drawRect(0, 0, global.SECTOR_WIDTH , global.SECTOR_HEIGHT);
				sprite.graphics.endFill();
			}
			
			
		private function dead():void {//действия после того как базу уничтожат
			this.toDelete = true;
			this.toRemove = true;
			builded = false;
			changeNodes(false);
			for (var i:int  = 0; i < global.foeArmy.length; i++) {
			global.foeArmy[i].findNewPath();
			}
		}
		
		public function hit(dmg:int):void//действие на столкновение с пулей
		{
			life -= dmg;
			//statBar.draw(life);
			//global.stat_bullHitCount++;
			//global.stat_dmgCount += dmg;
			//trace(life);
			if (life < 0 && !this.toDelete)
			{
				dead();
			}
		}
		
		private function changeNodes(setup:Boolean):void {// изменяет карту так чтобы проложить путь сквозь базу было дорого
			
			for (var i:int = 0; i < global.NODES_PER_SECTOR; i++) {
				for (var j:int = 0; j < global.NODES_PER_SECTOR; j++) {
				//trace(i + x / global.TILE_WIDTH, j + y / global.TILE_HEIGHT);
					if (setup) { global.nodes[i+x/global.TILE_WIDTH][j+y/global.TILE_HEIGHT].k += 100;}else{global.nodes[i][j].k -= 100}
				}
			}
			
			
		}
		
		public function getPosition():void {//возвращает координаты вокруг базы для врагов
			
			//cnter++;
			//trace((target_x < 0 || target_x > global.LEVEL_WIDTH) && (target_y < 0 && target_y > global.LEVEL_HEIGHT));
			var i:Boolean = true;
			while(i){
			var angle:int = Math.random()*360;
			
			target_x=(x+8+global.SECTOR_WIDTH/2+(Math.cos((angle +90)* global.degree) * global.SECTOR_WIDTH*1))/global.TILE_WIDTH;
			target_y=(y+8+global.SECTOR_HEIGHT/2+(Math.sin((angle+90) * global.degree) * global.SECTOR_HEIGHT*1))/global.TILE_HEIGHT;
			//trace(target_x, target_y);
			if ((target_x > 0 && target_x < global.LEVEL_WIDTH) && (target_y > 0 && target_y < global.LEVEL_HEIGHT)) { i = false;}
			}
			//trace("final",target_x, target_y);
			//if (cnter == 10) { builded = false; global.foeBase.findNewPath();}
			
		}
		
	}

}