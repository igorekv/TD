package  
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.Event;
	import flash.display.Shape;
	/**
	 * ...
	 * @author igorek
	 */
	public class fire extends Sprite
	{
		private var frame:int = 0;
		public function fire(rx,ry,rs) 
		{
			
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xffAA00, 0xffAA00];
			var alphas:Array = [1, 0];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			//var gradRotation:Number = 90 / 180 * Math.PI;
			matrix.createGradientBox(10, 10, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;

				var spark:Shape = new Shape();	
				this.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);
				this.graphics.drawCircle(5,5,5);
				this.graphics.endFill();
			this.x +=rx+Math.random() * 3*rs;
			this.y +=ry+Math.random() * 3*rs;
			this.alpha = 0.5 + (Math.random() / 2);
			this.scaleX = this.scaleY = (rs/2)+(Math.random()/2);
			//addChild(this);
			
 
			addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
		}
		
		private function onEnterFrame(e:Event):void {
			
			if (frame < 5) {			
				this.scaleX += (this.scaleX / 10);
				
			}
				this.x += 1;
				var colorInfo:ColorTransform = this.transform.colorTransform;
				colorInfo.color = colorInfo.color - 0x0800; 
				colorInfo.alphaOffset = -5*frame;
				this.transform.colorTransform = colorInfo; 
			
			frame++;
			if (frame > 30) { this.removeEventListener(Event.ENTER_FRAME, onEnterFrame); parent.removeChild(this); }
		}
		
		
		
	}

}