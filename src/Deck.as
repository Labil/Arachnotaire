package  {
	import customEvents.NavigationEvent;
	import customEvents.RestartEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		
		private var mMovableCards:Vector.<Card> = new Vector.<Card>(0, false); //Keeps track of the cards we wanna move 
		
		private var SUPERNUM:int = 1;
		
		private var mClickedCard:Card;
		private var lastObj:Card;
		private var lastTopCard:Card;
		
		private var lastCardPosition:Point;
		private var lastCardRow:int;
		
		private var mDifficulty:int;
		private var mDealCardsButton:Button;
		
		private var cooldownTimer:Timer;
		private var dealOnCooldown:Boolean;
		
		private var hasMoved:Boolean = false;
		private var savedCardPos:Point; //Saves the position of the selected card before moving it. Must be declared here because the eventListener keeps running over and over while moving the card 
		private var cardIsBlocked:Boolean;

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
			//trace("W/H: " + this.stage.stageWidth +" " + this.stage.stageHeight);
			//AddInGameMenu();
			MakeDeck();
			ShuffleDeck(mCards);
			SeparateTableAndDeck();
			//AddDealButton();
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
		}
		public function MakeDeck():void
		{
			if(mDifficulty == 1)
			{
				for(var i:int = 0; i < CARDS_TOTAL; i++)
				{
					if(i<13) { mCards[i] = new Card("Spade", i+1); }
					else if(i<26) { mCards[i] = new Card("Spade", i-13+1); }
					else if(i<39) { mCards[i] = new Card("Spade", i-26+1); }
					else if(i<52) { mCards[i] = new Card("Spade", i-39+1); }
					else if(i<65) { mCards[i] = new Card("Spade", i-52+1); }
					else if(i<78) { mCards[i] = new Card("Spade", i-65+1); }
					else if(i < 91) { mCards[i] = new Card("Spade", i-78+1); }
					else if(i < 104) { mCards[i] = new Card("Spade", i-91+1); }
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
		//The button to click when dealing cards from the deck
		/*private function AddDealButton():void
		{
			mDealCardsButton = new Button(Assets.getAtlas().getTexture("Trilitaire_Card_Background"));
			mDealCardsButton.width = 83;
			mDealCardsButton.height = 120;
			this.addChild(mDealCardsButton);
			mDealCardsButton.x = 220;
			mDealCardsButton.y = 470;
			textField = new TextField(80, 40, "", "Arial",30, Color.WHITE);
			textField.x = mDealCardsButton.width / 2;
			textField.y = 150 ;
			mDealCardsButton.addChild(textField);
			mDealCardsButton.addEventListener(TouchEvent.TOUCH, DealCards);
		}*/
		public function ShuffleDeck(vec:Vector.<Card>):void
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
		
		public function SeparateTableAndDeck():void
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
			c.SetCardGraphics();
			
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
				
				/*else
				{
					mCards[i].SetClickable(true);
					mCardStack.push(mCards[i]);
				}*/
				
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
		
		//Updates the mTopCards-vector, by replacing the old top card with the new. Also calls the function SetTopCard(boolean) on the respective cards and links the cards together
		private function UpdateTopCards(newTopCard:Card, oldTopCard:Card = null):void
		{
			if (oldTopCard != null) //If card is not placed in an empty row
			{
				for (var i:int = 0; i < mTopCards.length; i++)
				{
					if (mTopCards[i] == oldTopCard)
					{
						oldTopCard.SetOnTop(false);
						//oldTopCard.SetCardAbove(newTopCard);
						//newTopCard.SetCardBelow(oldTopCard);
						
						mTopCards[i] = newTopCard; //Viktig at denne settes til newTopCard etter at man er ferdig med oldTopCard, ellers blir linkinga feil
						newTopCard.SetOnTop(true);
					
						//newTopCard.SetCardAbove(null);
					}
				}
			}
			//If card is placed in an empty row
			else
			{
				//mTopCards[mTopCards.length] = newTopCard;
				mTopCards.push(newTopCard);
				newTopCard.SetOnTop(true);
				//newTopCard.SetCardBelow(null);
				//newTopCard.SetCardAbove(null);
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
			if (!dealOnCooldown)
			{
				if (te.getTouch(this) != null)
				{
					if (te.getTouch(this).phase == TouchPhase.BEGAN)
					{
						if (mCardsDeck.length >= NUM_ROWS) //Checks that there is still cards left in the deck
						{
							var cardFromDeck:Card;
							
							for (var i:int = 0; i < NUM_ROWS; i++)
							{
								cardFromDeck = mCardsDeck[mCardsDeck.length - 1]; //Gets the last card of the deck vector
								cardFromDeck.removeEventListener(TouchEvent.TOUCH, DealCards);
									
								MoveCardsFromDeckToTable(cardFromDeck, i);
							}
							dealOnCooldown = true;
							cooldownTimer = new Timer(2000, 1);
							cooldownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ResetDealCooldown);
							cooldownTimer.start();
						}
					}
				}
			}
			
		}
		private function ResetDealCooldown(e:TimerEvent):void
		{
			dealOnCooldown = false;
		}
		
		private function MoveCardsFromDeckToTable(card:Card, row:int):void
		{
			var cardBelow:Card = mAllTableRows[row][mAllTableRows[row].length - 1];
			card.FlipCard();
			card.SetRow(row);
			
			mAllTableRows[row][mAllTableRows[row].length] = card;
			this.setChildIndex(card, numChildren - 1);
			
			if (cardBelow != null) //If the row is not empty
			{
				UpdateTopCards(card, cardBelow);
				TweenLite.to(card, 0.7, { x:cardBelow.x, y:cardBelow.y + SPACING_Y, ease:Cubic.easeOut, onComplete:function():void{ card.addEventListener(TouchEvent.TOUCH, OnTableCardClick); } } );
			}
			else
			{
				UpdateTopCards(card);
				TweenLite.to(card, 0.7, { x:SPACING_X * row + MARGIN_LEFT, y:SPACING_Y * mAllTableRows[row].length + MARGIN_TOP, ease:Cubic.easeOut, onComplete:function():void{ card.addEventListener(TouchEvent.TOUCH, OnTableCardClick); } } );
			}
			//mCardsTable.push(mAllDeckStacks[currentStack][i]);
			LinkCards(mAllTableRows[row]);
			mCardsDeck.pop();
		}
		
		private function MoveCardToRow(card:Card, row:int):void
		{
			var newCardBelow:Card;
			var prevCardBelow:Card;
			var previousRow:int = card.GetRow();
			var movePos:Point;
		
			for (var i:int = 0; i < mMovableCards.length; i++)
			{
				mAllTableRows[previousRow].pop(); 
			}
			mAllTableRows[previousRow].pop();//Removes the card from the row it used to be in
		
			//Sets the newly freed card that is now on top of the old stack to be the top card, and flips it if needed
			if (mAllTableRows[previousRow].length > 0)
			{
				prevCardBelow = mAllTableRows[previousRow][mAllTableRows[previousRow].length -1];
				UpdateTopCards(prevCardBelow, card); //Removes the moved card from the topCards-vector, and replaces it with the card that was below the moved card
				if (!prevCardBelow.GetFlipped())
					prevCardBelow.FlipCard();
			}
			if (mAllTableRows[row].length > 0)
			{
				newCardBelow = mAllTableRows[row][mAllTableRows[row].length - 1];
				UpdateTopCards(card, newCardBelow); //Sets the card as a topCard, and removing the card that's now underneath in the new row from the vector.
				movePos = new Point(newCardBelow.x, newCardBelow.y + SPACING_Y);
			}
			else
			{
				UpdateTopCards(card);
				movePos = new Point(SPACING_X * row + MARGIN_LEFT,(SPACING_Y * mAllTableRows[row].length) + MARGIN_TOP);
			}
			card.SetRow(row);
			//mAllTableRows[row][mAllTableRows[row].length] = card;
			mAllTableRows[row].push(card);
			
			for (var j:int = 0; j < mMovableCards.length; j++)
			{
				newCardBelow = mAllTableRows[row][mAllTableRows[row].length - 1]; //This is now the last card that was moved
				UpdateTopCards(mMovableCards[j], newCardBelow);
				mMovableCards[j].SetRow(row);
				//mAllTableRows[row][mAllTableRows[row].length] = mMovableCards[j];
				mAllTableRows[row].push(mMovableCards[j]);
			}
			//LinkCards(mAllTableRows[row]);
			//LinkCards(mAllTableRows[previousRow]);
			
			TweenLite.to(card, 0.1, { x:movePos.x, y:movePos.y, ease:Cubic.easeOut } );
			
			for (var j:int = 0; j < mMovableCards.length; j++)
			{
				TweenLite.to(mMovableCards[j], 0.1, { x:movePos.x, y:movePos.y + (SPACING_Y * (j+1)), ease:Cubic.easeOut } );
			}
			
		}
		
		private function OnTableCardClick(te:TouchEvent):void
		{
			if (te.getTouch(this) != null)
			{
				mClickedCard = Card(te.currentTarget);
				
				if (te.getTouch(this).phase == TouchPhase.BEGAN)
				{ 
					trace("This cards row num is: " + mClickedCard.GetRow());
					trace("This card is on top: " + mClickedCard.GetOnTop());
					if(mClickedCard.GetCardAbove())
						trace("This cards cardAbove is: " + mClickedCard.GetCardAbove() + " and it belongs to the row: " + mClickedCard.GetCardAbove().GetRow());
					if(mClickedCard.GetCardBelow())
						trace("This cards cardBelow is: " + mClickedCard.GetCardBelow() + " and it belongs to the row: " + mClickedCard.GetCardBelow().GetRow());
				
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
										
										for (var i:int = 0; i < mMovableCards.length; ++i)
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
						var lastRow:int = mClickedCard.GetRow();
						hasMoved = false;
					    cardIsBlocked = false;
						
						if (cardBelow != null && CheckForRightColorAndValue(cardBelow))
						{
							//if (CheckForRightColorAndValue(cardBelow))
							//{
								var row:int = cardBelow.GetRow();
							
								//trace("The row that was hit is: " + row);
								MoveCardToRow(mClickedCard, row);
								
								LinkCards(mAllTableRows[row]);
								LinkCards(mAllTableRows[lastRow]);
						//	}
							
							
						}
						//TODO: Add else if(card touch emtpy space)
						else
						{
							TweenLite.to(mClickedCard, 0.3, { x:savedCardPos.x, y:savedCardPos.y, ease:Cubic.easeOut } );
							
							if (mMovableCards.length > 0)
							{
								for (var i:int = 0; i < mMovableCards.length; i++)
								{
									TweenLite.to(mMovableCards[i], 0.3, { x:savedCardPos.x, y:savedCardPos.y + (SPACING_Y*(i+1)), ease:Cubic.easeOut } );
								}
							}
						}
						
						
					}
					EmptyMovableCards();
					
				}
			}
		}
		private function EmptyMovableCards():void { mMovableCards.length = 0; }
		
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
						//trace("Movable cards length: " + mMovableCards.length);
						CheckCardsAbove(cardAbove);
					}
					else cardIsBlocked = true;
				}
				else cardIsBlocked = true;
			}
		}
		
		private function CheckForRightColorAndValue(cardBelow:Card):Boolean
		{
			//if (cardBelow.GetType() == mClickedCard.GetType())
			trace("TRY TO CHECK COLOR");
		//	{
				if (cardBelow.GetValue() == mClickedCard.GetValue() + 1)
				{
					trace("TYPE IS RIGHT");
					return true;
				}
		//	}
			return false;
		}
		private function CheckCardMove():Card
		{
			var currentCardRect:Rectangle = mClickedCard.getBounds(this); //this is to say that it's calculating the bounds in the space of the container it is in, and the cards are in the deck container
			for (var i:int = 0; i < mTopCards.length; i++)
			{
				if (mClickedCard != mTopCards[i])
				{
					var topCardRect:Rectangle = mTopCards[i].getBounds(this);
					
					if (topCardRect.intersects(currentCardRect))
					{
						trace("INTERSECTS");
						return mTopCards[i];
					}
				}
			}
			return null;
		}
		/*public function onMousePress(e:MouseEvent):void
		{
			updateTopCards();
			_startCoords = null;
			_siblingsStartCoords = null;
			_cardStack.length = 0;
			for(var coords:Object in _siblingsStartCoords)
			{
				delete _siblingsStartCoords[coords];
			}
			obj = Card(e.currentTarget);
			if(obj.isOnTop())
			{
				_startCoords = new Point(obj.getX(), obj.getY());
				m_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
				m_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
				
				m_stage.addChild(obj);  //For at kortet skal havne øverst i displaylista
				obj.startDrag();
			}
			else if(obj.isClickable())
			{
				_startCoords = new Point(obj.getX(), obj.getY());
				m_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
				m_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
				
				var nxt:Card = obj.getNext();
				if(nxt != null)
				{
					
					addCardsToArray(nxt);
					for(var p:int = 0; p < _cardStack.length; p++)
					{
						if(_cardStack[p].getValue() != obj.getValue()-1-p)
						{
							trace("ikke riktig tall");
							m_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
							m_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
							return;
						}
						if(_cardStack[p].getType() != obj.getType())  //Til endelig versjon av spill
						{
							trace("ikke samme farge");
							m_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
							m_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
							return;
						}
					}
					m_stage.addChild(obj);  //For at kortet skal havne øverst i displaylista
					_siblingsStartCoords = new Dictionary(true);
					for(var i:int = 0; i < _cardStack.length; i++)
					{
						_siblingsStartCoords[_cardStack[i]] = new Point(_cardStack[i].getX(), _cardStack[i].getY());
						m_stage.addChild(_cardStack[i]);
					}
					
					
				}
				obj.startDrag();
			}
		}*/
		
		/*public function onMouseRelease(e:MouseEvent):void
		{
			m_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
			m_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
			obj.stopDrag();
			
			for(var i:int = 0; i < m_topCards.length; i++)
			{
				if(obj.hitTestObject(m_topCards[i]) && obj != m_topCards[i])
				{
					if(m_topCards[i].getValue() == obj.getValue()+1 || m_topCards[i].getValue() == 15)
					{
						obj.setX(m_topCards[i].getX());
						obj.setY(m_topCards[i].getY() + spacing);
						var prev:Card = obj.getPrev();
						
						saveLastMove(obj, m_topCards[i], _startCoords);

						if(prev != null)
						{
							prev.setOnTop(true);
							prev.setNext(null);
							if(!prev.isClickable())
							{
								prev.flipCard();
							}
						}
						else
						{
							for(var g:int = 0; g < m_CardsTable.length; g++)
							{
								if(m_CardsTable[g].getX() == _startCoords.x) //Trenger bare x, for rekka er i teorien tom
								{
									m_CardsTable[g].setOnTop(true);
								}
							}
							//Her kan det opprettes en tom plass der alle kort kan legges
							/*var empty:Card = new Card("Empty", 14, true);
							m_stage.addChild(empty);
							empty.x = _startCoords.x;
							empty.y = _startCoords.y;
							empty.flipCard();*/
							
					/*	}
						m_topCards[i].setOnTop(false);
						m_topCards[i].setNext(obj);
						obj.setPrev(m_topCards[i]);
						if(_cardStack.length > 0)
						{
							
							moveSiblings();
							for(var j:int = 0; j < _cardStack.length; j++)
							{
								_cardStack[j].setX(obj.getX());
								_cardStack[j].setY(obj.getY()+((j+1)*spacing));
								
							}
						}
						testForWin();
						return;
					}
				}
			}
			obj.x = _startCoords.x;
			obj.y = _startCoords.y;
			if(_cardStack.length > 0)
			{
				moveSiblings();
			}
		}*/
		
		/*public function onMoveMouse(e:MouseEvent):void
		{
			
			if(_cardStack.length > 0)
			{
				moveSiblings();
			}
		}
		private function moveSiblings():void
		{
			var xDiff:Number = obj.x - _startCoords.x;
			var yDiff:Number = obj.y - _startCoords.y;
			
			for(var u:int = 0; u < _cardStack.length; u++)
			{
				_cardStack[u].x = _siblingsStartCoords[_cardStack[u]].x + xDiff;
				_cardStack[u].y = _siblingsStartCoords[_cardStack[u]].y + yDiff;
			}
			
		}
		public function addCardsToArray(card:Card):void
		{
			_cardStack.push(card);
			if(!card.isOnTop())
			{
				addCardsToArray(card.getNext());
			}
			
		}
		
		public function setSortedFalse():void
		{
			for(var i:int = 0; i < m_CardsTable.length; i++)
			{
				m_CardsTable[i].setSorted(false);
			}
		}
		
		public function updateTopCards():void
		{
			m_topCards.length = 0;
			for(var i:int = 0; i < m_CardsTable.length; i++)
			{
				if(m_CardsTable[i].isOnTop())
				{
					m_topCards.push(m_CardsTable[i]);
				}
			}
		}
		
		public function testForWin():void
		{
			for(var i:int = 0; i < m_CardsTable.length; i++)
			{
				if(m_CardsTable[i].isClickable() && m_CardsTable[i].getNext() != null)
				{
					setSortedFalse();
					testColor(m_CardsTable[i]);
				}
				SUPERNUM = 1;
				
			}
			
		}
		public function testColor(c:Card):void
		{
			
			var nxt:Card = c.getNext();
			if(nxt != null)
			{
				if(c.getValue()-1 == nxt.getValue())
				{
					c.setSorted(true);
					c.getNext().setSorted(true);
					testColor(nxt);
					SUPERNUM++;
					if(SUPERNUM == 13)
					{
						trace("WIN");
						removeSorted();
					}
				}
				
			
			}
			
		}
		public function removeSorted():void
		{
			for(var i:int = 0; i < m_CardsTable.length; i++)
			{
				if(m_CardsTable[i].checkSorted())
				{
					var prev:Card = m_CardsTable[i].getPrev();
					m_stage.removeChild(m_CardsTable[i]);
					if(prev != null && !prev.checkSorted())
					{
						prev.setOnTop(true);
						prev.setNext(null);
						if(!prev.isClickable())
						{
							prev.flipCard();
						}
					}
					else if(prev == null)
					{
						for(var h:int = 0; h < m_CardsTable.length; h++)
						{
							if(m_CardsTable[h].getX() == m_CardsTable[i].getX())
							{
								m_CardsTable[h].setOnTop(true);
							}
						}
					}
					
				}
			}
			deleteSorted();
		}
		public function deleteSorted():void
		{
			for(var i:int = 0; i < m_CardsTable.length; i++)
			{
				if(m_CardsTable[i].checkSorted())
				{
					m_CardsTable.splice(i, 1);
				}
			}
		}
		
		public function saveLastMove(o:Card, p:Card, pos:Point):void
		{
			lastObj = o;
			lastTopCard = p;
			_lastStartCoords = pos;
			
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