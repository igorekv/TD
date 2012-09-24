package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
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
	public class enemy extends buddy
	{
		

		
		
		private var checkpoint:int = 0;
		private var curX:Number;
		private var curY:Number;
		private var path:Array = new Array();
		private var dot:Sprite;
		private var deadCount:int = 5;
		public function enemy(_x:int, _y:int,_level:int)
		{
			
			
			animationSpeed = 100;//милисекунд между кадрами
			this.x = _x;
			this.y = _y*global.TILE_HEIGHT;
			life = global.skill[_level].life;
			damage = global.skill[_level].damage;
			speed = global.skill[_level].speed;
			rateofFire = global.skill[_level].fireRate;
			//tileHeight = 22;
			rangeofFire = 150;
			
			findNewPath();
			
			//tracePath();//дебаг показывать путь
			this.x = curX  = path[0].mapX;
			this.y = curY  = path[0].mapY;
			
			displayBitmapData = new BitmapData(tileWidth, tileHeight, true, 0xffffff);
			displayBitmap = new Bitmap(displayBitmapData); 
			blitRect = new Rectangle(0, 0, tileWidth, tileHeight);
			
			
			sprite.graphics.beginFill(0xCC3333,0.1);	
			sprite.graphics.drawRect(0, 0, 16, 16);
			sprite.graphics.endFill();
			sprite.visible = false;
			addChild(sprite);
			addChild(displayBitmap);
			//addEventListener(Event.ENTER_FRAME, draw);
			
			mainTimer = new Timer(20);
			mainTimer.start();
			
			mainTimer.addEventListener(TimerEvent.TIMER, draw);
			
			animationTimer = new Timer(animationSpeed);
			animationTimer.start();
			animationTimer.addEventListener(TimerEvent.TIMER, animateSprite);
			texture = global.soldierBitmap;
			
			statBar = new statusBar(life,100);
			addChild(statBar);
			statBar.setWidth(this.width);
			
		
		}
		public function distToFinish():int {
			//trace(this.x, path[path.length - 1].mapX);
			return global.destCalc(this.x,this.y,path[path.length-1].mapX,path[path.length-1].mapY,1);
			
		}
		private function tracePath():void {//debug
			trace(path);
			for (var i:int = 0; i < path.length; i++) {
				var dot = new Sprite();
				dot.graphics.beginFill(0xFFFF00,0.1);	
				dot.graphics.drawRect(path[i].mapX, path[i].mapY, 16, 16);
				dot.graphics.endFill();
				global.uiMenu.layer1.addChild(dot);
			}
			
		}
		public function hit(dmg:int):void
		{
			life -= dmg;
			statBar.draw(life);
			global.stat_bullHitCount++;
			global.stat_dmgCount += dmg;
			if (life < 0 && !this.toDelete)
			{
				dead();
			}
		}
		
		private function dead():void
		{
			//
			//parent.removeChild(this);
			global.score += 10;
			global.money += 5;
			global.uiMenu.updateUi = true;
			statBar.show("$"+5);
			this.toDelete = true;
		}
		
		
		
		
		
		public function findNewPath() {
			var tx:int = global.LEVEL_TARGET_X; var ty:int = global.LEVEL_TARGET_Y;
			if (global.ownBase && global.ownBase.builded) { global.ownBase.getPosition(); tx = global.ownBase.target_x; ty = global.ownBase.target_y; }
			//trace("new path");
			path = global.findPath(global.nodes[int(x/global.TILE_WIDTH)][int(y/global.TILE_HEIGHT)], global.nodes[tx][ty]);
			checkpoint = 0;
					
		}
		
		
		private function draw(e:TimerEvent):void
		{
			oldX = this.x;
			oldY = this.y;
			
			
			
			checkFire(global.myArmy);
			if (toDelete) {//действия при смерти
				if (deadCount < 0) { 
					//удаление обьекта
					this.toRemove = true; 
					mainTimer.stop();
					mainTimer.removeEventListener(TimerEvent.TIMER, draw);
					animationTimer.stop();
					animationTimer.removeEventListener(TimerEvent.TIMER, animateSprite);
					//this.removeEventListener(Event.ENTER_FRAME, draw);
					}
				deadCount--;
				
			}else{//если живой
				//trace(state);
				
				if (Math.abs(int(curX) - path[checkpoint].mapX) > 1 || Math.abs(int(curY) - path[checkpoint].mapY) > 1)
			{//если растояние до чекпойнта  больше 1 то двигаться
				
				
				var len:Number = destCalc(Math.abs(curX - path[checkpoint].mapX), Math.abs(curY - path[checkpoint].mapY));
				if (fireAnim < 1) { //если время выстрела закончилось то крутим по ходу движения
					angle = global.getAngle(curX - path[checkpoint].mapX, curY - path[checkpoint].mapY); 
					}else{fireAnim--;}
				state = WALK;
				curX += (path[checkpoint].mapX - curX) / (len / (speed/3));
				curY += (path[checkpoint].mapY - curY) / (len / (speed/3));
				
				
				}
				this.x = curX;
				this.y = curY;// -step;
			
			if (Math.abs(int(curX) - path[checkpoint].mapX) <= 1 && Math.abs(int(curY) - path[checkpoint].mapY) <= 1)
			{//если дошел до чекпойнта то следующий
				if (checkpoint < path.length-1){checkpoint++;}
			}
			;
			
			if (checkpoint == path.length-1) //если дошел до конца
			{
				
				if (Math.abs((this.x/global.TILE_WIDTH)-global.LEVEL_TARGET_X)<=1 && Math.abs((this.y/global.TILE_HEIGHT)-global.LEVEL_TARGET_Y)<=1  ) {//если дошел до финиша
					global.lives--;
					//trace("finish");
					this.toDelete = true;
					deadCount = 0;
					
					
				}else {//если стоит у базы
					//trace(int(this.x/global.TILE_WIDTH),int(this.y/global.TILE_HEIGHT));
					/*
					var tx:int = global.LEVEL_TARGET_X; var ty:int = global.LEVEL_TARGET_Y;
					if (global.ownBase && global.ownBase.builded) { tx = global.ownBase.target_x; ty = global.ownBase.target_y;}
					
					path = global.findPath(global.nodes[int(x / global.TILE_WIDTH)][int(y / global.TILE_HEIGHT)], global.nodes[tx][ty]);
					//checkpoint = 0;
					*/
				}
				
				
				
			}
		
			}
			
			
			
		}
	
	}

}