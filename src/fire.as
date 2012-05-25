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
		private var spark:Shape = new Shape();
		private var rsp:int = 1;
		private var type:int = 0;
		
		public function fire(rx:int, ry:int, rs:Number,ra:int,rsp:int,type:int)
		{
			this.rsp = rsp; this.type = type;
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xffAA00, 0xffAA00];
			//var alphas:Array = [1, 0];
			//var ratios:Array = [0, 255];
			//var matrix:Matrix = new Matrix();
			//var gradRotation:Number = 90 / 180 * Math.PI;
			//matrix.createGradientBox(10, 10, 0, 0, 0);
			//var spreadMethod:String = SpreadMethod.PAD;
			
			//spark.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);
			
			if (type == global.FIRE) { spark.graphics.beginFill(0xFFDD00); }
			if(type==global.SMOKE){spark.graphics.beginFill(0xDDDDDD);}
			spark.graphics.drawCircle(5,5, 5);
			spark.graphics.endFill();
			
			spark.x = rx -4*rs + Math.random() * 4 * rs;
			spark.y = ry -4*rs + Math.random() * 4 * rs;
			spark.alpha = 0.5 + (Math.random() / 2);
			spark.scaleX = spark.scaleY = (rs / 10) + (Math.random() / 4);
			spark.visible = 0;
			//spark.rotation = ra;
			addChild(spark);
			
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame); //событие на каждый кадр
		}
		
		private function onEnterFrame(e:Event):void
		{
			
			if (frame == 3)
			{
				spark.visible = 1;
			}
			if (frame > 3)
			{
			spark.scaleX = frame / 10; 
			spark.scaleY = frame /10;
			
				
			}
			
			var colorInfo:ColorTransform = this.transform.colorTransform;
			if (type == global.FIRE) { colorInfo.color = colorInfo.color - 0x1100; }
			if (type == global.SMOKE) { 
				colorInfo.color = colorInfo.color - 0x111111; 
				}
			colorInfo.alphaOffset = -10 * frame;
			this.transform.colorTransform = colorInfo;
			
			frame++;
			if (frame > 15)
			{
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				parent.removeChild(this);
			}
		}
	
	}

}