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
		private var score:TextField;
		private var scoreShadow:TextField;
		private var money:TextField;
		private var moneyShadow:TextField;
		public function userInterface(){
			uiMenu.addChild(layer1);
			uiMenu.addChild(layer2);
			uiMenu.addChild(layer3);
			score = global.prepText("score:" + numToStr(global.score, 6), 14, 0xFFFFFF);
			scoreShadow = global.prepText("score:" + numToStr(global.score, 6), 14, 0x222222);
			scoreShadow.x += 1;
			scoreShadow.y += 1;
			money = global.prepText("money:"+numToStr(global.money, 5),14,0xFFFFFF);
			moneyShadow = global.prepText("money:" + numToStr(global.money, 5), 14, 0x222222);
			moneyShadow.x += 151;
			moneyShadow.y += 1;
			money.x = 150;
			layer2.addChild(scoreShadow);
			layer2.addChild(score);
			layer2.addChild(moneyShadow);
			layer2.addChild(money);
			addChild(uiMenu);
		}
		
		private function numToStr(value:int, len:int):String {
			
			return String("0000000000".substr(0, len - String(value).length) + String(value));
			
		}
		
		public function update() {
			global.score++;
			score.text ="score:"+numToStr(global.score, 6);
			money.text= "money:"+numToStr(global.money, 5);
			
		}
		
	}

}