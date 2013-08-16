package  
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class ScoreManager extends Sprite 
	{
		private var mScore:int;
		private var mScoreText:TextField;
		//Score values
		public static const SCORE_CLEAR:int = 100;
		public static const SCORE_UNDO:int = -5;
		public static const SCORE_TIME:int = -1;
		
		public function ScoreManager() 
		{
			mScore = 0;
			MakeScoreboard();
		}
		public function UpdateScore(score:int):void
		{
			if (mScore + score >= 0)
				mScore += score;
			else
				mScore = 0;
			UpdateScoreboard();
		}
		private function MakeScoreboard():void
		{
			mScoreText = new TextField(100, 50, "Score: " + String(mScore), "Arial", 20);
			this.addChild(mScoreText);
		}
		private function UpdateScoreboard():void
		{
			mScoreText.text = "Score: " + String(mScore);
		}
		public function GetCurrentScore():int
		{
			return mScore;
		}
		
	}

}