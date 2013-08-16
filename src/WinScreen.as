package  
{
	import customEvents.NavigationEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Button;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.display.Image;
	import starling.display.Sprite;
	import flash.geom.Point;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class WinScreen extends Sprite 
	{
		private var bg:Image;
		private const CARDS_TOTAL:int = 105;
		private var mCards:Vector.<Card> = new Vector.<Card>(CARDS_TOTAL, true);
		private var mDifficulty:int;
		private var oneColorType:String;
		private var mTimer:Timer;
		private var gameTime:String;
		private var gameScore:int;
		private var mScoreField:TextField;
		private var mTimeField:TextField;
		private var mWinField:TextField;
		private var mBackBtn:Button;
		
		public function WinScreen(difficulty:int, type:String, time:String, score:int)
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
			oneColorType = type;
			mDifficulty = difficulty;
			gameTime = time;
			gameScore = score;
			
		}
		private function OnAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
			
			bg = new Image(Assets.getTexture("IngameBG"));
			this.addChild(bg);
			
			mBackBtn = new Button(Assets.getAtlas().getTexture("Trilitaire_Back_Button"));
			mBackBtn.x = this.stage.stageWidth / 2 - mBackBtn.width / 2;
			mBackBtn.y = this.stage.stageHeight - mBackBtn.height - 30;
			this.addChild(mBackBtn);
			mBackBtn.addEventListener(Event.TRIGGERED, ClickToClose);
			
			mWinField = new TextField(450, 70, "YOU WON!", "Arial", 36);
			mWinField.x = this.stage.stageWidth / 2 - mWinField.width/2;
			mWinField.y = this.stage.stageHeight / 3 - mWinField.height - 10;
			this.addChild(mWinField);
			
			mTimeField = new TextField(300, 50, "Your time: " + gameTime, "Arial", 28);
			mTimeField.x = this.stage.stageWidth / 2 - mTimeField.width/2;
			mTimeField.y = this.stage.stageHeight / 2 - mTimeField.height - 10;
			this.addChild(mTimeField);
			
			mScoreField = new TextField(300, 50, "Your score: " + gameScore, "Arial", 28);
			mScoreField.x = this.stage.stageWidth / 2 - mScoreField.width/2;
			mScoreField.y = this.stage.stageHeight / 2;
			this.addChild(mScoreField);
			
			MakeDeck();
			ShuffleDeck(mCards);
			AddCardsToStage();
			
			mTimer = new Timer(200, 105);
			mTimer.addEventListener(TimerEvent.TIMER, RemoveCard);
			
		}
		
		public function Show():void
		{
			this.visible = true;
			mTimer.start();
		}
		
		public function Hide():void
		{
			this.visible = false;
		}
		private function MakeDeck():void
		{
			if(mDifficulty == 1)
			{
				if(oneColorType == "")
				{
					oneColorType = "Spade";
				}
				for(var i:int = 0; i < CARDS_TOTAL; i++)
				{
					if(i<13) { mCards[i] = new Card(oneColorType, i+1); }
					else if(i<26) { mCards[i] = new Card(oneColorType, i-13+1); }
					else if(i<39) { mCards[i] = new Card(oneColorType, i-26+1); }
					else if(i<52) { mCards[i] = new Card(oneColorType, i-39+1); }
					else if(i<65) { mCards[i] = new Card(oneColorType, i-52+1); }
					else if(i<78) { mCards[i] = new Card(oneColorType, i-65+1); }
					else if(i < 91) { mCards[i] = new Card(oneColorType, i-78+1); }
					else if(i < 104) { mCards[i] = new Card(oneColorType, i - 91 + 1); }
					else if(i < 105) { mCards[i] = new Card(oneColorType, 1); }
				}
			}
			else if(mDifficulty == 2)
			{
				for(i = 0; i < CARDS_TOTAL; i++)
				{
					if(i<13) { mCards[i] = new Card("Heart", i+1); }
					else if(i<26){ mCards[i] = new Card("Spade", i-13+1); }
					else if(i<39) { mCards[i] = new Card("Heart", i-26+1); }
					else if(i<52) { mCards[i] = new Card("Spade", i-39+1); }
					else if(i<65) { mCards[i] = new Card("Heart", i-52+1); }
					else if(i<78) { mCards[i] = new Card("Spade", i-65+1); }
					else if(i < 91) { mCards[i] = new Card("Heart", i-78+1); }
					else if (i < 104) { mCards[i] = new Card("Spade", i - 91 + 1); }
					else if(i < 105) { mCards[i] = new Card("Heart", 1); }
				}
				
			}
			else if(mDifficulty == 3)
			{
				for(i = 0; i < CARDS_TOTAL; i++)
				{
					if(i<13) { mCards[i] = new Card("Heart", i+1); }
					else if(i<26) { mCards[i] = new Card("Spade", i-13+1); }
					else if(i<39) { mCards[i] = new Card("Club", i-26+1); }
					else if(i<52) { mCards[i] = new Card("Diamond", i-39+1); }
					else if(i<65) { mCards[i] = new Card("Heart", i-52+1); }
					else if(i<78) { mCards[i] = new Card("Spade", i-65+1); }
					else if(i < 91) { mCards[i] = new Card("Club", i-78+1); }
					else if (i < 104) { mCards[i] = new Card("Diamond", i - 91 + 1); }
					else if(i < 105) { mCards[i] = new Card("Diamond", 1); }
				}
			}
			
			
		}
		private function ShuffleDeck(vec:Vector.<Card>):void
		{
			var i:int = vec.length;
			while(i > 0)
			{
				var j:int = Math.floor(Math.random() * i);
				i--;
				var temp:* = vec[i];
				vec[i] = vec[j];
				vec[j] = temp;
			}
		}
		private function AddCardsToStage():void
		{
			var spacing:int = -6; 
			
			for (var i:int = 0; i < mCards.length; i++)
			{
				if (i < 15)
				{
					mCards[i].x = spacing + (i * mCards[i].width);
					mCards[i].y = spacing;
				}
				else if (i < 30)
				{
					mCards[i].x = spacing + ((i - 15) * mCards[i].width);
					mCards[i].y = spacing + mCards[i].height;
				}
				else if (i < 45)
				{
					mCards[i].x = spacing + ((i - 30) * mCards[i].width);
					mCards[i].y = spacing + mCards[i].height * 2;
				}
				else if (i < 60)
				{
					mCards[i].x = spacing + ((i - 45) * mCards[i].width);
					mCards[i].y = spacing + mCards[i].height * 3;
				}
				else if (i < 75)
				{
					mCards[i].x = spacing + ((i - 60) * mCards[i].width);
					mCards[i].y = spacing + mCards[i].height * 4;
				}
				else if (i < 90)
				{
					mCards[i].x = spacing + ((i - 75) * mCards[i].width);
					mCards[i].y = spacing + mCards[i].height * 5;
				}
				else if (i < 105)
				{
					mCards[i].x = spacing + ((i - 90) * mCards[i].width);
					mCards[i].y = spacing + mCards[i].height * 6;
				}
				if(i != 52)
					mCards[i].FlipCard();
				this.addChild(mCards[i]);
			}
		}
		private function RemoveCard(te:TimerEvent):void
		{
			var rand:Number = Math.floor(Math.random() * mCards.length-1);
			
			if (mCards.length > 0)
			{
				if (rand > 0 && rand < mCards.length)
				{
				}
				else if(rand < 0)
					rand = 0;
				else if ( rand > mCards.length - 1)
					rand = 1;
				
				this.removeChild(mCards[rand]);
				mCards.splice(rand, 1);
			}
		}
		private function ClickToClose(e:Event):void
		{
			trace("Click to close");
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"winclose" }, true));
		}
	}

}