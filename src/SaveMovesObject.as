package  
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class SaveMovesObject 
	{
		private var mSavedCards:Vector.<SavedCard> = new Vector.<SavedCard>(0, false);
		
		public function SaveMovesObject() 
		{
			
		}
		//When player addds a new row of cards from the deck stack, the previously saved moves are cleared
		public function ClearSaves():void
		{
			mSavedCards.length = 0;
		}
		public function SaveLastMove(card:Card, col:int, unflip:Boolean, cards:Vector.<Card> = null):void
		{
			mSavedCards[mSavedCards.length] = new SavedCard(card, col, unflip, cards);
		}
		public function LoadLastMove():Dictionary
		{
			if (mSavedCards.length > 0)
			{
				var dictionary:Dictionary = mSavedCards[mSavedCards.length - 1].GetSavedCardDictionary();
				mSavedCards.pop();
				
				return dictionary;
			}
			return null;
		}
		public function GetSavedMovesLength():int
		{
			return mSavedCards.length;
		}
	}

}