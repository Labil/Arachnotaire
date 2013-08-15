package  {
	import customEvents.NavigationEvent;
	import customEvents.RestartEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.events.Event;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	
	public class Deck extends Sprite
	{
		//Background
		private var bg:Image;
		
		private const CARDS_TOTAL:int = 104;
		private const CARDS_ON_TABLE:int = 54;
		private const CARDS_IN_DECK:int = 50;
		private const NUM_ROWS:int = 10; //Rows of cards on the table
		private const SPACING_Y:int = 30; //Spacing between the cards in Y-axis
		private const SPACING_Y_UNFLIPPED:int = 20; //Spacing for the cards that are laying face-down
		private const MARGIN_TOP:int = 20; //Spacing from top of stage to cards
		private const MARGIN_LEFT:int = 20;
		private const SPACING_X:int = 70;
		
		private var mCards:Vector.<Card> = new Vector.<Card>(CARDS_TOTAL, false);
		private var mCardsDeck:Vector.<Card> = new Vector.<Card>(CARDS_IN_DECK, false);
		private var mCardsTable:Vector.<Card> = new Vector.<Card>(CARDS_ON_TABLE, false);
		private var mTopCards:Vector.<Card> = new Vector.<Card>(NUM_ROWS, false);
		private var mBottomCards:Vector.<Card> = new Vector.<Card>(NUM_ROWS, true);
		
		private var mRow0:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow1:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow2:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow3:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow4:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow5:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow6:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow7:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow8:Vector.<Card> = new Vector.<Card>(0, false);
		private var mRow9:Vector.<Card> = new Vector.<Card>(0, false);
		
		private var mAllTableRows:Vector.<Vector.<Card>> = new Vector.<Vector.<Card>>(10, true);
		private var mMovableCards:Vector.<Card> = new Vector.<Card>(0, false); //Keeps track of the card stack we wanna move 
		
		
		private var mClickedCard:Card;
		
		private var mDifficulty:int;
		
		private var cooldownTimer:Timer;
		private var bMoveOnCooldown:Boolean = new Boolean(0);
		
		private var hasMoved:Boolean = false;
		private var savedCardPos:Point; //Saves the position of the selected card before moving it. Must be declared here because the eventListener keeps running over and over while moving the card 
		private var cardIsBlocked:Boolean;
		
		private var mOneColorType:String = "";
		
		//Undo
		private var mSaveMovesObject:SaveMovesObject;
		
		//Score
		private var mScoreMgr:ScoreManager;
		
		//Timecount
		private var mClock:Clock;
		
		//Ingame menu
		private var mIngameMenu:IngameMenu;
		
		
		//Ctor
		public function Deck(difficulty:int)
		{
			super();
			mDifficulty = difficulty;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
//			this.addEventListener(Event.REMOVED_FROM_STAGE, Cleanup);

			bg = new Image(Assets.getTexture("IngameBG"));
			this.addChild(bg);
			//AddInGameMenu();
			MakeDeck();
			ShuffleDeck(mCards);
			SeparateTableAndDeck();
			AddInvisibleCards();
			AddCardsToStage();
			LinkCards(mRow0);
			LinkCards(mRow1);
			LinkCards(mRow2);
			LinkCards(mRow3);
			LinkCards(mRow4);
			LinkCards(mRow5);
			LinkCards(mRow6);
			LinkCards(mRow7);
			LinkCards(mRow8);
			LinkCards(mRow9);
			PlaceDeckCards();
			
			mSaveMovesObject = new SaveMovesObject;
			
			mScoreMgr = new ScoreManager();
			mScoreMgr.x = 50;
			mScoreMgr.y = 400;
			this.addChild(mScoreMgr);
			
			mClock = new Clock();
			mClock.x = 200;
			mClock.y = 400;
			this.addChild(mClock);
			
			mIngameMenu = new IngameMenu();
			mIngameMenu.x = 50;
			mIngameMenu.y = this.stage.stageHeight/2 + this.stage.stageHeight/3;
			this.addChild(mIngameMenu);
			CheckIfMorePossibleUndos();
			
			SoundManager.instance.PlayRandomMusic();
		}
		
		public function Show():void
		{
			this.visible = true;
		}
		
		public function Hide():void
		{
			this.visible = false;
		}
		
		private function GenerateRandomType():String
		{
			var rand:Number = Math.random();
			
			if (rand <= 0.25) return "Spade";
			else if (rand <= 0.5) return "Heart";
			else if (rand <= 0.75) return "Diamond";
			else if (rand <= 1) return "Club";
			
			return "Spade";
		}
		private function MakeDeck():void
		{
			if(mDifficulty == 1)
			{
				mOneColorType = GenerateRandomType();

				for(var i:int = 0; i < CARDS_TOTAL; i++)
				{
					if(i<13) { mCards[i] = new Card(mOneColorType, i+1); }
					else if(i<26) { mCards[i] = new Card(mOneColorType, i-13+1); }
					else if(i<39) { mCards[i] = new Card(mOneColorType, i-26+1); }
					else if(i<52) { mCards[i] = new Card(mOneColorType, i-39+1); }
					else if(i<65) { mCards[i] = new Card(mOneColorType, i-52+1); }
					else if(i<78) { mCards[i] = new Card(mOneColorType, i-65+1); }
					else if(i < 91) { mCards[i] = new Card(mOneColorType, i-78+1); }
					else if(i < 104) { mCards[i] = new Card(mOneColorType, i-91+1); }
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
					else if(i < 104) { mCards[i] = new Card("Spade", i-91+1); }
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
					else if(i < 104) { mCards[i] = new Card("Diamond", i-91+1); }
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
		
		private function SeparateTableAndDeck():void
		{
			var i:int;
			for(i = 0; i < CARDS_ON_TABLE; i++)
			{
				mCardsTable[i] = mCards[i];
			}
			for(i = 0; i < CARDS_IN_DECK; i++)
			{
				mCardsDeck[i] = mCards[i+CARDS_ON_TABLE];
			}
		}
		private function PlaceCard(c:Card, _X:int, _Y:int):void
		{
			this.addChild(c);
			c.x = _X;
			c.y = _Y;
			
		}
		private function AddCardsToStage():void
		{
			var xPos:int;
			var yPos:int;
			
			for(var i:int = 0; i < mCardsTable.length; i++)
			{
				xPos = MARGIN_LEFT;
				yPos = MARGIN_TOP;
				if(i < 6)
				{
					mRow0.push(mCardsTable[i]);
					xPos += SPACING_X * 0;
					yPos += SPACING_Y_UNFLIPPED * i;
					mCardsTable[i].SetRow(0);
				}
				else if(i < 12)
				{
					mRow1.push(mCardsTable[i]);
					xPos += SPACING_X * 1;
					yPos += SPACING_Y_UNFLIPPED * (i - 6);
					mCardsTable[i].SetRow(1);
				}
				else if(i < 18)
				{
					mRow2.push(mCardsTable[i]);
					xPos += SPACING_X *2;
					yPos += SPACING_Y_UNFLIPPED * (i - 12);
					mCardsTable[i].SetRow(2);
				}
				else if(i < 24)
				{
					mRow3.push(mCardsTable[i]);
					xPos += SPACING_X *3;
					yPos += SPACING_Y_UNFLIPPED * (i - 18);
					mCardsTable[i].SetRow(3);
				}
				else if(i < 29)
				{
					mRow4.push(mCardsTable[i]);
					xPos += SPACING_X *4;
					yPos += SPACING_Y_UNFLIPPED * (i - 24);
					mCardsTable[i].SetRow(4);
				}
				else if(i < 34)
				{
					mRow5.push(mCardsTable[i]);
					xPos += SPACING_X *5;
					yPos += SPACING_Y_UNFLIPPED * (i - 29);
					mCardsTable[i].SetRow(5);
				}
				else if(i < 39)
				{
					mRow6.push(mCardsTable[i]);
					xPos += SPACING_X *6;
					yPos += SPACING_Y_UNFLIPPED * (i - 34);
					mCardsTable[i].SetRow(6);
				}
				else if(i < 44)
				{
					mRow7.push(mCardsTable[i]);
					xPos += SPACING_X * 7;
					yPos += SPACING_Y_UNFLIPPED * (i - 39);
					mCardsTable[i].SetRow(7);
				}
				else if(i < 49)
				{
					mRow8.push(mCardsTable[i]);
					xPos += SPACING_X * 8;
					yPos += SPACING_Y_UNFLIPPED * (i - 44);
					mCardsTable[i].SetRow(8);
				}
				else if(i < 54)
				{
					mRow9.push(mCardsTable[i]);
					xPos += SPACING_X * 9;
					yPos += SPACING_Y_UNFLIPPED * (i - 49);
					mCardsTable[i].SetRow(9);
				}
				PlaceCard(mCards[i], xPos, yPos);
				
				mCards[i].addEventListener(TouchEvent.TOUCH, OnTableCardClick);
				
			}
			mAllTableRows[0] = mRow0;
			mAllTableRows[1] = mRow1;
			mAllTableRows[2] = mRow2;
			mAllTableRows[3] = mRow3;
			mAllTableRows[4] = mRow4;
			mAllTableRows[5] = mRow5;
			mAllTableRows[6] = mRow6;
			mAllTableRows[7] = mRow7;
			mAllTableRows[8] = mRow8;
			mAllTableRows[9] = mRow9;
			
			for (i = 0; i < NUM_ROWS; i++)
			{
				mAllTableRows[i][mAllTableRows[i].length - 1].FlipCard();
				PopulateTopCards(mAllTableRows[i][mAllTableRows[i].length - 1], i);
			}
		}
		private function PopulateTopCards(topCard:Card, index:int):void
		{
			mTopCards[index] = topCard; //Adding the ten top cards to a vector to keep track of them as they'll be used in collision testing later
			topCard.SetOnTop(true);
		}
		
		private function AddInvisibleCards():void
		{
			for (var i:int = 0; i < NUM_ROWS; i++)
			{
				mBottomCards[i] = new Card("Blank", 0);
				mBottomCards[i].SetRow(i);
				PlaceCard(mBottomCards[i], MARGIN_LEFT + (SPACING_X * i), MARGIN_TOP);
			}
		}
		//Updates the mTopCards-vector, first by clearing the cards currently marked as top cards, then adding the fresh top cards in each row
		private function UpdateTopCards():void
		{
			for (var i:int = 0; i < mTopCards.length; i++)
			{
				mTopCards[i].SetOnTop(false);
			}
				
			mTopCards.length = 0;
			
			for (i = 0; i < NUM_ROWS; i++)	
			{
				if (mAllTableRows[i].length > 0)
				{
					mTopCards.push(mAllTableRows[i][mAllTableRows[i].length - 1]);
					mTopCards[mTopCards.length - 1].SetOnTop(true);
					mTopCards[mTopCards.length - 1].FlipCard();
					mTopCards[mTopCards.length - 1].SetCardAbove(null);
				}
			}
		}
		private function LinkCards(vec:Vector.<Card>):void
		{
			if (vec.length == 1)
			{
				vec[i].SetCardAbove(null);
				vec[i].SetCardBelow(null);
			}
			else
			{
				for(var i:int = 0; i < vec.length; i++)
				{
					if (i == 0)
					{
						vec[i].SetCardBelow(null);
						vec[i].SetCardAbove(vec[i + 1]);
					}
					else if (i == vec.length - 1)
					{
						vec[i].SetCardBelow(vec[i - 1]);
						vec[i].SetCardAbove(null);
					}
					else
					{
						vec[i].SetCardAbove(vec[i + 1]);
						vec[i].SetCardBelow(vec[i - 1]);
					}
				}
			}
			
		}
		//Places the cards in the deck in five stacks of 10
		public function PlaceDeckCards():void
		{
			for(var i:int = 0; i < mCardsDeck.length; i++)
			{
				var xPos:int = this.stage.stageWidth - 200; 
				if(i<10){ }
				else if(i<20){ xPos += 25 * 1; }
				else if(i<30){ xPos += 25 * 2; }
				else if(i<40){ xPos += 25 * 3; }
				else if (i < 50) { xPos += 25 * 4; }
				
				mCardsDeck[i].x = xPos;
				mCardsDeck[i].y = 25;
				
				this.addChild(mCardsDeck[i]);
				if(i == 9 || i == 19 || i == 29 || i == 39 || i == 49)
					mCardsDeck[i].addEventListener(TouchEvent.TOUCH, DealCards);
			}
		}
		
		//When the player clicks on the button, this event calls a function to add one batch of cards onto the table
		private function DealCards(te:TouchEvent):void
		{
			if (!bMoveOnCooldown)
			{
				if (te.getTouch(this) != null)
				{
					if (te.getTouch(this).phase == TouchPhase.BEGAN)
					{
						var cardFromDeck:Card;
							
						for (var i:int = 0; i < NUM_ROWS; i++)
						{
							cardFromDeck = mCardsDeck[mCardsDeck.length - 1]; //Gets the last card of the deck vector
							cardFromDeck.removeEventListener(TouchEvent.TOUCH, DealCards);
									
							MoveCardsFromDeckToTable(cardFromDeck, i);
							ClearSavedMoves();
							CheckIfMorePossibleUndos();
						}
						bMoveOnCooldown = true;
						SetCooldownTimer(700);
					}
				}
			}
			
		}
		
		private function ResetCooldown(e:TimerEvent):void
		{
			bMoveOnCooldown = false;
		}
		
		//Moves the cards in the deck stack to the table in groups of ten, one new card per row
		private function MoveCardsFromDeckToTable(card:Card, row:int):void
		{
			var cardBelow:Card; 
			if (mAllTableRows[row].length > 0)
				cardBelow = mAllTableRows[row][mAllTableRows[row].length - 1];
			else cardBelow = null;
			
			card.FlipCard();
			card.SetRow(row);
			mAllTableRows[row][mAllTableRows[row].length] = card;
			this.setChildIndex(card, numChildren - 1);
			UpdateTopCards();
			LinkCards(mAllTableRows[row]);
			mCardsDeck.pop();
			
			if (cardBelow != null) //If the row is not empty
				TweenLite.to(card, 0.7, { x:cardBelow.x, y:cardBelow.y + SPACING_Y, ease:Cubic.easeOut, onComplete:function():void{ card.addEventListener(TouchEvent.TOUCH, OnTableCardClick); if (mAllTableRows[row].length >= 18) ShrinkRow(row); } } );
			else
				TweenLite.to(card, 0.7, { x:SPACING_X * row + MARGIN_LEFT, y:MARGIN_TOP, ease:Cubic.easeOut, onComplete:function():void { card.addEventListener(TouchEvent.TOUCH, OnTableCardClick); } } );
			
			if (CheckRowForSorted(row))
			{
				RemoveSortedFromTable(row);
			}
			
				
		}
		
		private function MoveCardToRow(card:Card, row:int):void
		{
			var previousRow:int = card.GetRow();
			var previousRowOldLength:int = mAllTableRows[previousRow].length;
			var previousRowNewLength:int;
			var movePos:Point;
			
			for (var i:int = 0; i < mMovableCards.length; i++)
			{
				mAllTableRows[previousRow].pop(); 
			}
			mAllTableRows[previousRow].pop();//Removes the card from the row it used to be in
			
			previousRowNewLength = mAllTableRows[previousRow].length;
			
			SaveMove(card, previousRow);
			
			mAllTableRows[row].length > 0 ? movePos = new Point((SPACING_X * row) + MARGIN_LEFT, mAllTableRows[row][mAllTableRows[row].length - 1].y + SPACING_Y) : movePos = new Point((SPACING_X * row) + MARGIN_LEFT, MARGIN_TOP);
		
			card.SetRow(row);
			mAllTableRows[row].push(card);
			
			for (var j:int = 0; j < mMovableCards.length; j++)
			{
				mMovableCards[j].SetRow(row);
				mAllTableRows[row].push(mMovableCards[j]);
			}
			
			LinkCards(mAllTableRows[row]);
			LinkCards(mAllTableRows[previousRow]);
			
			UpdateTopCards();
			
			TweenLite.to(card, 0.1, { x:movePos.x, y:movePos.y, ease:Cubic.easeOut } );
			
			for (j = 0; j < mMovableCards.length; j++)
			{
				TweenLite.to(mMovableCards[j], 0.1, { x:movePos.x, y:movePos.y + (SPACING_Y * (j + 1)), ease:Cubic.easeOut } );
			}
			
			if (mAllTableRows[row].length >= 18)
				ShrinkRow(row);
			else if (previousRowOldLength >= 18 && previousRowNewLength < 18)
				UnShrinkRow(previousRow);
				
		}
		
		private function SaveMove(card:Card, prevRow:int):void
		{
			var cardBelowAlreadyFlipped:Boolean;
			mAllTableRows[prevRow].length > 0 ? cardBelowAlreadyFlipped = mAllTableRows[prevRow][mAllTableRows[prevRow].length - 1].GetFlipped() : cardBelowAlreadyFlipped = true; //Setter siste til true pga hvis det ikke var kort igjen i forrige kolonne så skal den ikke flippes tilbake uansett
			
			mMovableCards.length > 0 ? mSaveMovesObject.SaveLastMove(card, prevRow, cardBelowAlreadyFlipped , mMovableCards.slice(0, mMovableCards.length)) : mSaveMovesObject.SaveLastMove(card, prevRow, cardBelowAlreadyFlipped);
			
			CheckIfMorePossibleUndos();
		}
		
		private function ClearSavedMoves():void
		{
			mSaveMovesObject.ClearSaves();
		}
		
		public function Undo():void
		{
			var savedObject:Dictionary = new Dictionary();
			savedObject = mSaveMovesObject.LoadLastMove();
			if (savedObject != null)
			{
				MoveCardBack(savedObject);
				CheckIfMorePossibleUndos();
				mScoreMgr.UpdateScore(ScoreManager.SCORE_UNDO);
			}
			else trace("Saved object is null");
		}
		
		private function CheckIfMorePossibleUndos():void
		{
			if (mSaveMovesObject.GetSavedMovesLength() > 0)
				SetUndoButtonState(true);
			else
				SetUndoButtonState(false);
		}
		
		private function SetUndoButtonState(bEnabled:Boolean):void
		{
			mIngameMenu.SetButtonState("undo", bEnabled);
		}
		
		private function MoveCardBack(saved:Dictionary):void
		{
			var card:Card = saved["card"];
			var row:int = saved["col"];
			var cardBelowAlreadyFlipped:Boolean = saved["flipped"];
			var attatchedCards:Vector.<Card>;
			var previousRow:int = card.GetRow();
			var previousRowOldLength:int = mAllTableRows[previousRow].length;
			var previousRowNewLength:int;
			var movePos:Point;
			var spaceY:int;
			
			if (saved["cards"] != null)
				attatchedCards = saved["cards"].slice(0, saved["cards"].length);
			else
				attatchedCards = new Vector.<Card>(0, true);
			
			for (var i:int = 0; i < attatchedCards.length; i++)
			{
				mAllTableRows[previousRow].pop(); 
			}
			
			mAllTableRows[previousRow].pop();
			
			previousRowNewLength = mAllTableRows[previousRow].length;
			
			if (mAllTableRows[row].length > 0)
			{
				if (!cardBelowAlreadyFlipped)
				{
					mAllTableRows[row][mAllTableRows[row].length - 1].UnflipCard();
					spaceY = SPACING_Y_UNFLIPPED;
				}
				else spaceY = SPACING_Y;
				
				movePos = new Point((SPACING_X * row) + MARGIN_LEFT, mAllTableRows[row][mAllTableRows[row].length - 1].y + spaceY);
			}
			else
			{
				movePos = new Point((SPACING_X * row) + MARGIN_LEFT, MARGIN_TOP);
			}
				
			card.SetRow(row);
			mAllTableRows[row].push(card);
			
			for (var j:int = 0; j < attatchedCards.length; j++)
			{
				attatchedCards[j].SetRow(row);
				mAllTableRows[row].push(attatchedCards[j]);
			}
			
			LinkCards(mAllTableRows[row]);
			LinkCards(mAllTableRows[previousRow]);
			UpdateTopCards();
			
			this.setChildIndex(card, numChildren - 1);
			TweenLite.to(card, 0.1, { x:movePos.x, y:movePos.y, ease:Cubic.easeOut } );
			
			for (j = 0; j < attatchedCards.length; j++)
			{
				this.setChildIndex(attatchedCards[j], numChildren - 1);
				TweenLite.to(attatchedCards[j], 0.1, { x:movePos.x, y:movePos.y + (spaceY * (j + 1)), ease:Cubic.easeOut } );
			}
			
			if (mAllTableRows[row].length >= 18)
				ShrinkRow(row);
			else if (previousRowOldLength >= 18 && previousRowNewLength < 18)
				UnShrinkRow(previousRow);
				
		}
		
		private function ShrinkRow(row:int):void
		{
			for (var i:int = 0; i < mAllTableRows[row].length; i++)
			{
				TweenLite.to(mAllTableRows[row][i], 0.2, { x:(SPACING_X * row) + MARGIN_LEFT, y: MARGIN_TOP + (i * SPACING_Y_UNFLIPPED), ease:Cubic.easeOut } );
			}
		}
		private function UnShrinkRow(row:int):void
		{
			for (var i:int = 0; i < mAllTableRows[row].length; i++)
			{
				if(mAllTableRows[row][i].GetFlipped())
					TweenLite.to(mAllTableRows[row][i], 0.2, { x:(SPACING_X * row) + MARGIN_LEFT, y: MARGIN_TOP + (i * SPACING_Y), ease:Cubic.easeOut } );
			}
		}
		
		private function OnTableCardClick(te:TouchEvent):void
		{
			if (te.getTouch(this) != null && !bMoveOnCooldown)
			{
				mClickedCard = Card(te.currentTarget);
				
				if (te.getTouch(this).phase == TouchPhase.BEGAN)
				{ 
				}
				else if (te.getTouch(this).phase == TouchPhase.MOVED)
				{
					var touchPos:Point = te.getTouch(this).getLocation(this);
					
					if (mClickedCard.GetFlipped())
					{
						if (mClickedCard.GetOnTop())
						{
							if (!hasMoved)
							{	
								savedCardPos = new Point(mClickedCard.x, mClickedCard.y);
								hasMoved = true;
								this.setChildIndex(mClickedCard, numChildren - 1);
							}
							
							mClickedCard.x = touchPos.x - mClickedCard.width / 2;
							mClickedCard.y = touchPos.y - mClickedCard.height / 2;
						}
						else
						{
							if (!hasMoved)
							{
								CheckCardsAbove(mClickedCard);
								if (!cardIsBlocked)
								{
									savedCardPos = new Point(mClickedCard.x, mClickedCard.y);
									this.setChildIndex(mClickedCard, numChildren - 1);
									
									for (var i:int = 0; i < mMovableCards.length; i++)
									{
										this.setChildIndex(mMovableCards[i], numChildren - 1);
									}
								}
								else 
								{
									EmptyMovableCards();
								}
								hasMoved = true;
							}
							else 
							{
								if (!cardIsBlocked)
								{
									if (mMovableCards.length > 0)
									{
										mClickedCard.x = touchPos.x - mClickedCard.width / 2;
										mClickedCard.y = touchPos.y - mClickedCard.height / 2;
										
										for (i = 0; i < mMovableCards.length; ++i)
										{
											mMovableCards[i].x = mClickedCard.x;
											mMovableCards[i].y = mClickedCard.y + (SPACING_Y * (i+1));
										}
									}
								}
							}
						}
					}
				}
				else if (te.getTouch(this).phase == TouchPhase.ENDED)
				{
					if (hasMoved && !cardIsBlocked)
					{
						var cardBelow:Card = CheckCardMove();
						var emptyRow:int = CheckForEmptyRow();
						bMoveOnCooldown = true;
						
						//If the card is dropped ontop of one of the topmost cards and the value beneath is one higher than the clicked card value
						if (cardBelow != null && CheckForRightValue(cardBelow))
						{
							var row:int = cardBelow.GetRow();
						
							MoveCardToRow(mClickedCard, row);
							
							if (CheckRowForSorted(row))
							{
								RemoveSortedFromTable(row);
							}
					
						}
						//If the card is dropped in an empty row
						else if (emptyRow != -1 && mAllTableRows[emptyRow].length == 0)
						{
							MoveCardToRow(mClickedCard, emptyRow);
						}
						//If the card is let go over the wrong value card, or in thin air
						else
						{
							TweenLite.to(mClickedCard, 0.3, { x:savedCardPos.x, y:savedCardPos.y, ease:Cubic.easeOut } );
							
							if (mMovableCards.length > 0)
							{
								for (var j:int = 0; j < mMovableCards.length; j++)
								{
									TweenLite.to(mMovableCards[j], 0.3, { x:savedCardPos.x, y:savedCardPos.y + (SPACING_Y*(j+1)), ease:Cubic.easeOut } );
								}
							}
						}
					}
					hasMoved = false;
					cardIsBlocked = false;
					EmptyMovableCards();
					//Start a timer to cooldown the time until the player may click the cards again, to stop them from double clicking on a movable card thus ruining everythang
					SetCooldownTimer(300);
					
				}
			}
		}
		private function SetCooldownTimer(time:Number):void
		{
			cooldownTimer = new Timer(time, 1);
			cooldownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ResetCooldown);
			cooldownTimer.start();
		}
		private function CheckForEmptyRow():int
		{
			var currentCardRect:Rectangle = mClickedCard.getBounds(this); //this is to say that it's calculating the bounds in the space of the container it is in, and the cards are in the deck container, aka this
			
			for (var i:int = 0; i < mBottomCards.length; i++)
			{
				var bottomCardRect:Rectangle = mBottomCards[i].getBounds(this);
				
				if (bottomCardRect.intersects(currentCardRect))
						return mBottomCards[i].GetRow();
			}
			return -1;
		}
		
		private function EmptyMovableCards():void { mMovableCards.length = 0; }
		
		//Checks the cards laying on top of the clicked card if they form a continuous row of color and value, and if so are movable - put them in mMovableCards to be moved alongside the clicked card
		private function CheckCardsAbove(card:Card):void
		{
			var cardAbove:Card;
			cardAbove = card.GetCardAbove();
			if (cardAbove != null)
			{
				if (cardAbove.GetType() == card.GetType())
				{
					if (cardAbove.GetValue() == card.GetValue() - 1)
					{
						mMovableCards.push(cardAbove);
						CheckCardsAbove(cardAbove);
					}
					else cardIsBlocked = true;
				}
				else cardIsBlocked = true;
			}
		}
		
		private function CheckForRightValue(cardBelow:Card):Boolean
		{
				if (cardBelow.GetValue() == mClickedCard.GetValue() + 1)
					return true;
			return false;
		}
		
		//Checks if the card or cardstack being moved is dropped onto one of the topcards, and if so returns that card
		private function CheckCardMove():Card
		{
			var currentCardRect:Rectangle = mClickedCard.getBounds(this); //this is to say that it's calculating the bounds in the space of the container it is in, and the cards are in the deck container
			
			for (var i:int = 0; i < mTopCards.length; i++)
			{
				var foundMatch:Card = mClickedCard; //Sets it to the clicked card temporarily, just so the card will never get null, until it is checked in the mMovableCards for a match
				
				if (mMovableCards.length > 0)
				{
					for (var j:int = 0; j < mMovableCards.length; j++)
					{
						if (mTopCards[i] == mMovableCards[j])
						{
							foundMatch = mMovableCards[j];
							break; //There is only one topcard in whatever amount of cards from the same row
						}
					}
				}
				if(mTopCards[i] != mClickedCard && mTopCards[i] != foundMatch)
				{
					var topCardRect:Rectangle = mTopCards[i].getBounds(this);
			
					if (topCardRect.intersects(currentCardRect))
						return mTopCards[i];
				}
			}
			return null;
		}
		
		private function CheckRowForSorted(row:int):Boolean
		{
			var cardMatchNum:int = 0;
			
			for (var i:int = 0; i < mAllTableRows[row].length-1; i++)
			{
				
					if (mAllTableRows[row][mAllTableRows[row].length - (i+1)].GetValue() == mAllTableRows[row][mAllTableRows[row].length - (i+2)].GetValue() - 1 && mAllTableRows[row][mAllTableRows[row].length - (i+1)].GetType() ==mAllTableRows[row][mAllTableRows[row].length - (i+2)].GetType())
					{
						cardMatchNum++;
					}
					else break;
				
				
			}
			if (cardMatchNum >= 12)
				return true;
			else
				return false;
		}
		
		private function RemoveSortedFromTable(row:int):void
		{
			var prevLength:int = mAllTableRows[row].length;
			for (var i:int = 0; i < 13; i++ )
			{
				this.removeChild(mAllTableRows[row][mAllTableRows[row].length - 1]);
				mAllTableRows[row].pop();
				mCards.pop();
			}
			UpdateTopCards();
			
			if (prevLength >= 18 && mAllTableRows[row].length < 18)
				UnShrinkRow(row);
			
			mScoreMgr.UpdateScore(ScoreManager.SCORE_CLEAR);
			ClearSavedMoves();
			CheckIfMorePossibleUndos();
			CheckForWin();
		}
		
		private function CheckForWin():void
		{
			if (mCards.length == 0)
			{
				var winScreen:WinScreen = new WinScreen(mDifficulty, mOneColorType);
				this.addChild(winScreen);
			}
			
		}
		
	/*	public function Cleanup(e:Event):void
		{
			/*if (hintTimer != null && hintTimer.running)
				this.removeEventListener(TimerEvent.TIMER, functionWithParams);
			if (this.hasEventListener(Event.ENTER_FRAME)) 
				this.removeEventListener(Event.ENTER_FRAME, buttonAnimation);
			if(this.hasEventListener(Event.TRIGGERED))
				this.removeEventListener(Event.TRIGGERED, onButtonClick);
			this.removeChildren();*/
			/*Running timers must be stopped
			'enterFrame' event listeners must be removed
			Open network connections should be closed
			Any children added to the stage must be removed
			Stage event listeners must be removed
			BitmapData objects must be disposed
			Sound playing must be stopped*/
		//}

	}
	
}