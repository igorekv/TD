package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author igorek
	 */
	public class userInterface extends Sprite
	{
		
		private var uiMenu:Sprite = new Sprite();
		public var layer1:Sprite = new Sprite();
		private var layer2:Sprite = new Sprite();
		private var layer3:Sprite = new Sprite();
		public var updateUi:Boolean = false;
		private var buttons:Vector.<button>=new Vector.<button>;
		private var fontSize:int = 14;
		private var time:TextField;
		private var score:TextField;
		private var money:TextField;
		private var lives:TextField;
		private var btn0:button;
		private var menuPos_y:int = global.MAP_HEIGHT+global.TOPMENU_HEIGHT;
		public function userInterface(){
			
			uiMenu.addChild(layer1);
			uiMenu.addChild(layer2);	
			uiMenu.addChild(layer3);
			score = global.prepText("score:" + numToStr(global.score, 6), fontSize, 0xFFFFFF);
			
			money = global.prepText("money:"+numToStr(global.money, 5),fontSize,0xFFFFFF);
			money.x = 240;
			
			time = global.prepText("next wave:"+numToStr(global.time, 3),fontSize,0xFFFFFF);
			time.x = 120;
			
			lives = global.prepText("lives:"+numToStr(global.lives, 2),fontSize,0xFFFFFF);
			lives.x = 360;
			
			btn0 = new button(button.BUILD,100);
			btn0.y = menuPos_y; btn0.x = 0;
			buttons.push(btn0);
			btn0 = new button(button.SOLDIER,20);
			btn0.y = menuPos_y;btn0.x = 50;
			buttons.push(btn0);
			btn0 = new button(button.SOLDIER,20);
			btn0.y = menuPos_y;btn0.x = 100;
			buttons.push(btn0);
			layer2.addChild(score);
			layer2.addChild(lives);
			layer2.addChild(time);
			layer2.addChild(money);
			for (var i:int = 0; i <buttons.length ; i++) //вывод кнопок на интерфейс
			{
				layer2.addChild(buttons[i]);
			}
			addChild(uiMenu);
			this.name = "userInterface";
			
			//drawGrid();
			
		}
		
		private function drawGrid():void {
			for (var i:int = 0; i <10 ; i++) 
			{
				for (var j:int = 0; j <9 ; j++) 
				{
					var sprite:Sprite = new Sprite();	
				//sprite.graphics.beginFill(0x00FF00, 0.2);
				
				sprite.graphics.lineStyle(1, 0xFFFFFF, 0.1);
				//sprite.graphics.drawCircle(0, 0, 32);
				sprite.graphics.moveTo(32, 0);
				sprite.graphics.lineTo(32, 16);
				sprite.graphics.lineTo(0, 32);
				sprite.graphics.lineTo( -32, 16);
				sprite.graphics.lineTo(-32,-16);
				sprite.graphics.lineTo(0, -32);
				sprite.graphics.lineTo(32, -16);
				//sprite.graphics.drawRect(0, 0, global.SECTOR_WIDTH , global.SECTOR_HEIGHT);
				//sprite.graphics.endFill();
				
				sprite.x =global.HALF_SECTOR+i*global.SECTOR_WIDTH+global.HALF_SECTOR*(j%2)
				sprite.y =global.HALF_SECTOR+ j*48;
				layer3.addChild(sprite);
					
					
				}
			}
		}
		
		private function numToStr(value:int, len:int):String {
			
			return String("0000000000".substr(0, len - String(value).length) + String(value));
			
		}
		
		public function update():void {
			//trace("interface update");
			for (var i:int = 0; i <buttons.length ; i++) 
			{
				buttons[i].update();
			}
			updateUi = false;
			score.text ="score:"+numToStr(global.score, 6);
			money.text = "money:" + numToStr(global.money, 5);
			lives.text= "lives:"+numToStr(global.lives, 2);
			if(!global.lastWave){time.text= "Next Wave:"+numToStr(global.time, 3);}else{time.text= "Last Wave:"+numToStr(global.time, 3);}
		}
		
	}

}