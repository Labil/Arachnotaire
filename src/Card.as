package  
{
	import starling.text.TextField;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.HAlign;
	
	/*
	 *	Part of the card game Arachnotaire
	 *	written by Solveig Hansen, 2013
	 */
	public class Card extends Sprite
	{
		private var cardImage:Image; //Background with color
		private var textField:TextField; //Value display
		private var outline:Image;
		private var mType:String; //Heart, Spade, Club, Diamond
		private var mValue:int; //1,2,3,4... Value of card
		private var mbFlipped:Boolean; //Is the card on the table or in the stack?
		private var mbClickable:Boolean;
		private var mIsOnTop:Boolean;
		private var mRow:int;
		private const cardWidth:int = 65;
		private const cardHeight:int = 94;
		//private var cardWidth:int;
		//private var cardHeight:int;
		private const numberWidth:int = 25;
		private const numberHeight:int = 33;
		
		private var mCardAbove:Card;
		private var mCardBelow:Card;

		public function Card(_type:String, _value:int)
		{
			mType = _type;
			mValue = _value;
			SetCardGraphics();
			//SetClickable(true); //Sets to false when the card is being released from a move and until it is back in its place, so no double clicks to fuck up the movement
		}
		public function SetOnTop(b:Boolean):void { mIsOnTop = b; }
		public function GetOnTop():Boolean { return mIsOnTop; }
		public function SetRow(_row:int):void { mRow = _row; }
		public function GetRow():int { return mRow; }
		public function GetValue():int { return mValue; }
		public function GetType():String { return mType; }
		public function GetFlipped():Boolean { return mbFlipped; }
		
		public function SetCardBelow(c:Card):void { mCardBelow = c; }
		public function SetCardAbove(c:Card):void { mCardAbove = c; }
		
		public function FlipCard():void
		{
			if (mbFlipped) //Returns if already flipped (don't need to run SetCardGraphics)
				return;
			mbFlipped = true;
			SetCardGraphics();
		}
		public function UnflipCard():void
		{
			if (!mbFlipped)
				return;
			mbFlipped = false;
			SetCardGraphics();
		}
		public function GetCardBelow():Card
		{
			if(mCardBelow != null)
				return mCardBelow;
			else return null;
		}
		public function GetCardAbove():Card
		{
			if(mCardAbove != null)
				return mCardAbove;
			else return null;
		}
		
		public function SetCardGraphics():void
		{	
				if (this.mType == "Blank") //Graphics for the blank cards
				{
					cardImage = new Image(Assets.getAtlas().getTexture("Trilitaire_Card_Blank"));
					cardImage.width = cardWidth;
					cardImage.height = cardHeight;
					this.addChild(cardImage);
					
					return;
				}
				if (mbFlipped)
				{
					cardImage = new Image(Assets.getAtlas().getTexture("Trilitaire_Card_" + mType + "s"));
					cardImage.width = cardWidth;
					cardImage.height = cardHeight;
					this.addChild(cardImage);
					
					textField = new TextField(30, 30, String(mValue), "Arial", 20);
					textField.hAlign = HAlign.LEFT;
					textField.x = 7;
					textField.y = 5;
					this.addChild(textField);
					
					/*if (outline != null)
					{
						outline = new Image(Assets.getAtlas().getTexture("Trilitaire_Card_Outline"));
						outline.width = cardWidth;
						outline.height = cardHeight;
						this.addChild(outline);
						outline.visible = false;
					}*/
				}
				else
				{
					cardImage = new Image(Assets.getAtlas().getTexture("Trilitaire_Card_Background"));
					cardImage.width = cardWidth;
					cardImage.height = cardHeight;
					this.addChild(cardImage);
					
					/*outline = new Image(Assets.getAtlas().getTexture("Trilitaire_Card_Outline"));
					outline.width = cardWidth;
					outline.height = cardHeight;
					this.addChild(outline);
					outline.visible = false;*/
					
					if(textField != null)
						textField.visible = false;
				}
				
		}
		/*public function SetSelected(b:Boolean):void
		{
			if (!b)
				outline.visible = false;
			else
				outline.visible = true;
		}*/
		
		

	}
	
}

