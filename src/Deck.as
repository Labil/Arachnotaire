package  {
	import customEvents.NavigationEvent;
	import customEvents.RestartEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.events.Event;
	
	public class Deck extends Sprite
	{
		private const CARDS_ON_TABLE:int = 54;
		private const CARDS_TOTAL:int = 104;
		private const CARDS_IN_DECK:int = 50;
		private const NUM_ROWS:int = 10;
		private const SPACING:int = 20;
		
		private var mCards:Vector.<Card> = new Vector.<Card>(CARDS_TOTAL, false);
		private var mCardsDeck:Vector.<Card> = new Vector.<Card>(CARDS_IN_DECK, false);
		private var mCardsTable:Vector.<Card> = new Vector.<Card>(CARDS_ON_TABLE, false);
		private var mTopCards:Vector.<Card> = new Vector.<Card>(20);
		
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
		
		/*private var mDeckCards1:Vector.<Card> = new Vector.<Card>(0, false);
		private var mDeckCards2:Vector.<Card> = new Vector.<Card>(0, false);
		private var mDeckCards3:Vector.<Card> = new Vector.<Card>(0, false);
		private var mDeckCards4:Vector.<Card> = new Vector.<Card>(0, false);
		private var mDeckCards5:Vector.<Card> = new Vector.<Card>(0, false);*/
		
		//private var mAllDeckStacks:Vector.<Vector.<Card>> = new Vector.<Vector.<Card>>(5, true);
		private var mAllTableRows:Vector.<Vector.<Card>> = new Vector.<Vector.<Card>>(10, true);
		
		private var SUPERNUM:int = 1;
		
		private var mCurrentSelection:Card;
		private var lastObj:Card;
		private var lastTopCard:Card;
		
		//private var _lastStartCoords:Point = null;
		
		private var mDifficulty:int;
		private var mDealCardsButton:Button;
		

		public function Deck(difficulty)
		{
			super();
			mDifficulty = difficulty;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
//			this.addEventListener(Event.REMOVED_FROM_STAGE, Cleanup);
			
			//AddInGameMenu();
			MakeDeck();
			ShuffleDeck(mCards);
			SeparateTableAndDeck();
			AddDealButton();
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
			//DisplayNumberOfCardsInDeck();
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
					//mCards[i].addEventListener(MouseEvent.MOUSE_DOWN, onMousePress);
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
					//mCards[i].addEventListener(MouseEvent.MOUSE_DOWN, onMousePress);
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
					//mCards[i].addEventListener(MouseEvent.MOUSE_DOWN, onMousePress);
				}
			}
			
			
		}
		//The button to click when dealing cards from the deck
		private function AddDealButton():void
		{
			mDealCardsButton = new Button(Assets.getAtlas().getTexture("Trilitaire_Card_Background"));
			mDealCardsButton.width = 83;
			mDealCardsButton.height = 120;
			this.addChild(mDealCardsButton);
			mDealCardsButton.x = 220;
			mDealCardsButton.y = 470;
/*			textField = new TextField(80, 40, "", "Arial",30, Color.WHITE);
			textField.x = mDealCardsButton.width / 2;
			textField.y = 150 ;*/
			//mDealCardsButton.addChild(textField);
			mDealCardsButton.addEventListener(TouchEvent.TOUCH, DealCards);
		}
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
			var yPos:int = 40;
			var stageHW:int = 320 - 83;
			
			for(var i:int = 0; i < mCardsTable.length; i++)
			{
				if(i < 6)
				{
					mRow0.push(mCardsTable[i]);
					xPos = 20;
					yPos += SPACING * i;
				}
				else if(i < 12)
				{
					mRow1.push(mCardsTable[i]);
					xPos = 60;
					yPos = SPACING * (i-6);
				}
				else if(i < 18)
				{
					mRow2.push(mCardsTable[i]);
					xPos = 100;
					yPos = SPACING * (i-12);
				}
				else if(i < 24)
				{
					mRow3.push(mCardsTable[i]);
					xPos = 140;
					yPos = SPACING * (i-18);
				}
				else if(i < 29)
				{
					mRow4.push(mCardsTable[i]);
					xPos = 180;
					yPos = SPACING * (i-24);
				}
				else if(i < 34)
				{
					mRow5.push(mCardsTable[i]);
					xPos = 220;
					yPos = SPACING * (i-29);
				}
				else if(i < 39)
				{
					mRow6.push(mCardsTable[i]);
					xPos = 260;
					yPos = SPACING * (i-34);
				}
				else if(i < 44)
				{
					mRow7.push(mCardsTable[i]);
					xPos = 300;
					yPos = SPACING * (i-39);
				}
				else if(i < 49)
				{
					mRow8.push(mCardsTable[i]);
					xPos = 340;
					yPos = SPACING * (i-44);
				}
				else if(i < 54)
				{
					mRow9.push(mCardsTable[i]);
					xPos = 380;
					yPos = SPACING * (i-49);
				}
				PlaceCard(mCards[i], xPos, yPos);
				
				//mCards[i].addEventListener(TouchEvent.TOUCH, OnTableCardClick);
				
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
		}
		private function LinkCards(vec:Vector.<Card>):void
		{
			for(var i:int = 0; i < vec.length; i++)
			{
				if(i == 0)
					vec[i].SetCardAbove(vec[i + 1]);
				else if (i == vec.length - 1)
					vec[i].SetCardBelow(vec[i - 1]);
				else
				{
					vec[i].SetCardAbove(vec[i + 1]);
					vec[i].SetCardBelow(vec[i - 1]);
				}
			}
		}
		//Makes the card stacks that the player may click on to deal a row of cards
		public function PlaceDeckCards():void
		{
			for(var i:int = 0; i < mCardsDeck.length; i++)
			{
				if(i<10)
				{
					mCardsDeck[i].x = 25;
					mCardsDeck[i].y = 25;
					//mDeckCards1.push(vec[i]);
					//vec[i].SetRow(0);
				}
				else if(i<20)
				{
					mCardsDeck[i].x = 75;
					mCardsDeck[i].y = 25;
					//mDeckCards2.push(vec[i]);
					//vec[i].SetRow(1);
				}
				else if(i<30)
				{
					mCardsDeck[i].x = 125;
					mCardsDeck[i].y = 25;
					//mDeckCards3.push(vec[i]);
					//vec[i].SetRow(2);
				}
				else if(i<40)
				{
					mCardsDeck[i].x = 175;
					mCardsDeck[i].y = 25;
					//mDeckCards4.push(vec[i]);
					//vec[i].SetRow(3);
				}
				else if(i<50)
				{
					mCardsDeck[i].x = 225;
					mCardsDeck[i].y = 25;
					//mDeckCards5.push(vec[i]);
					//vec[i].SetRow(4);
				}
				this.addChild(mCardsDeck[i]);
			}
			/*mDeckCards1[mDeckCards1.length - 1].addEventListener(TouchEvent.TOUCH, OnDeckClick);
			mDeckCards2[mDeckCards2.length - 1].addEventListener(TouchEvent.TOUCH, OnDeckClick);
			mDeckCards3[mDeckCards3.length - 1].addEventListener(TouchEvent.TOUCH, OnDeckClick);
			mDeckCards4[mDeckCards4.length - 1].addEventListener(TouchEvent.TOUCH, OnDeckClick);
			mDeckCards5[mDeckCards5.length - 1].addEventListener(TouchEvent.TOUCH, OnDeckClick);*/
			
		/*	mAllDeckStacks[0] = mDeckCards1;
			mAllDeckStacks[1] = mDeckCards2;
			mAllDeckStacks[2] = mDeckCards3;
			mAllDeckStacks[3] = mDeckCards4;
			mAllDeckStacks[4] = mDeckCards5;*/
		
		}
		
		private function DealCards(te:TouchEvent):void
		{
			if (te.getTouch(this) != null)
			{
				if (te.getTouch(this).phase == TouchPhase.BEGAN)
				{
					//mCurrentSelection = Card(te.currentTarget);
					//mCurrentSelection.removeEventListener(TouchEvent.TOUCH, OnDeckClick);
					//var currentStack:int = mCurrentSelection.GetRow();
					
					if (mCardsDeck.length >= 10) //Sjekker at det er igjen nok kort i stacken til å dele ut en runde til
					{
						var cardFromDeck:Card;
						var topCardInRow:Card;
						for (var i:int = 0; i < 10; i++)
						{
							cardFromDeck = mCardsDeck[mCardsDeck.length - 1];
							topCardInRow = mAllTableRows[i][mAllTableRows[i].length - 1];
							trace(topCardInRow);
							mAllTableRows[i][mAllTableRows[i].length-1].SetOnTop(false); //Sets the old top card in this row to no longer be on top, before adding the new card from the deck
							mAllTableRows[i][mAllTableRows[i].length] = cardFromDeck;
							mCardsDeck.pop();
							mAllTableRows[i][mAllTableRows[i].length - 1].FlipCard();
							mAllTableRows[i][mAllTableRows[i].length - 1].SetClickable(true);
							mAllTableRows[i][mAllTableRows[i].length - 1].SetCardBelow(mAllTableRows[i][mAllTableRows[i].length - 2]);
							mAllTableRows[i][mAllTableRows[i].length - 2].SetCardAbove(mAllTableRows[i][mAllTableRows[i].length - 1]);
							mAllTableRows[i][mAllTableRows[i].length-1].SetOnTop(true); //Sets the newly added card 
							//mCardsTable.push(mAllDeckStacks[currentStack][i]);
							//CHANGE POSITION
							trace("Adding cards from stack to table");
						}
					}
					
				/*	for(var i:int = 0; i < mCardsDeck.length; i++)
					{
						if(m_CardsDeck[i].getX() == xPos)
						{
							m_CardsDeck[i].setDealt(true);
							c = m_CardsDeck[i];
							m_CardsTable.push(c);
							m_stage.removeChild(m_CardsDeck[i]);
							for(var j:int = 0; j < m_CardsTable.length; j++)
							{
								if(m_CardsTable[j].isOnTop())
								{
									m_CardsTable[j].setOnTop(false);
									m_CardsTable[j].setNext(c);
									c.setPrev(m_CardsTable[j]);
									c.flipCard();
									m_stage.addChild(c);
									c.x = m_CardsTable[j].getX();
									c.y = m_CardsTable[j].getY()+ spacing;
									break;
								}
							}
						}*/
					
					}
				}
			}
			//deleteDealtCardsFromDeck();
			
		//}
		
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
		public function deleteDealtCardsFromDeck():void
		{
			for(var i:int = 0; i < m_CardsDeck.length; i++)
			{
				if(m_CardsDeck[i].checkDealt())
				{
					m_CardsDeck.splice(i, 1);
				}
			}
		}
		
		public function saveLastMove(o:Card, p:Card, pos:Point):void
		{
			lastObj = o;
			lastTopCard = p;
			_lastStartCoords = pos;
			
		}
		public function makeGrid():void
		{
			m_grid = new Array(GRID_COLUMNS);
			for(var i:int = 0; i < GRID_COLUMNS; i++)
			{
				m_grid[i] = new Array(GRID_ROWS);
			}
			for(var c:int = 0; c < GRID_COLUMNS; c++)
			{
				for(var r:int = 0; r <GRID_ROWS; r++)
				{
					m_grid[c][r] = new MovieClip();
					m_stage.addChild(m_grid[c][r]);
					m_grid[c][r].x = (c+0.25)*100;
					m_grid[c][r].y = (r+8)*spacing;
				}
			}
			
		}
		public function makeEmptySlots():void
		{
			for(var i:int = 0; i < 10; i++)
			{
				m_emptyPlaces[i] = new Card("Blank", 15, false);
			}
		}*/
		
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