package 
{
	import net.hires.debug.Stats;
	import starling.core.Starling;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.Event;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	[SWF(width="960", height="640", frameRate="60", backgroundColor="#ffffff")]
	public class Main extends Sprite 
	{
		private var mStarling:Starling;
		//private var stats:Stats;
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			mStarling = new Starling(Game, stage);
			mStarling.antiAliasing = 1;
			mStarling.start();
			
			//stats = new Stats();
			//this.addChild(stats);
		}
		
	}
	
}