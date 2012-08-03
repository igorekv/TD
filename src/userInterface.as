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
			
			btn0 = new button(button.BUILD);
			btn0.y = menuPos_y;
			
			
			layer2.addChild(score);
			layer2.addChild(lives);
			layer2.addChild(time);
			layer2.addChild(money);
			layer2.addChild(btn0);
			addChild(uiMenu);
			this.name = "userInterface";
		}
		
		private function numToStr(value:int, len:int):String {
			
			return String("0000000000".substr(0, len - String(value).length) + String(value));
			
		}
		
		public function update():void {
			
			score.text ="score:"+numToStr(global.score, 6);
			money.text = "money:" + numToStr(global.money, 5);
			lives.text= "lives:"+numToStr(global.lives, 2);
			if(!global.lastWave){time.text= "Next Wave:"+numToStr(global.time, 3);}else{time.text= "Last Wave:"+numToStr(global.time, 3);}
		}
		
	}

}