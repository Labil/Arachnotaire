package  
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class SavedCard 
	{
		private var mDictionary:Dictionary;
		
		public function SavedCard(c:Card, col:int, flipped:Boolean, cards:Vector.<Card> = null) 
		{
			mDictionary = new Dictionary();
			mDictionary["card"] = c;
			mDictionary["col"] = col;
			mDictionary["flipped"] = flipped;
			if (cards != null)
				mDictionary["cards"] = cards;
			else
				mDictionary["cards"] = null;
		}
		public function GetSavedCardDictionary():Dictionary
		{
			return mDictionary;
		}
		
	}

}