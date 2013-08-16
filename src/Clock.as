package  
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public dynamic class Clock extends Sprite 
	{
		private var mTimer:Timer = new Timer(100);
		private var mCount:int = 0;
		private var mTextDisplay:TextField;
		
		public function Clock() 
		{
			mTextDisplay = new TextField(100, 50, "", "Arial", 20);
			this.addChild(mTextDisplay);
			
			mTimer.addEventListener(TimerEvent.TIMER, Tick);
			mTimer.start();
		}
		
		private function Tick(e:TimerEvent):void
		{
			mCount += 100;
			ConvertToTimeCode(mCount);
		}
		
		private function ConvertToTimeCode(ms:int):void
		{
			var time:Date = new Date(ms);
			
			var minutes:String = String(time.minutes);
			var seconds:String = String(time.seconds);
			var miliseconds:String = String(Math.round(time.milliseconds / 100));
			
			minutes = (minutes.length != 2) ? '0' + minutes : minutes;
			seconds = (minutes.length != 2) ? '0' + seconds : seconds;
			
			mTextDisplay.text = minutes + ":" + seconds;
		}
		public function GetTimePlayed():String
		{
			return mTextDisplay.text;
		}
		
	}

}