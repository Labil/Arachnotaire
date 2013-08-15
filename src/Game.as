package  
{
	
	import starling.display.Sprite;
	import starling.events.Event;
	import customEvents.NavigationEvent;
	import customEvents.MenuEvent;
	
	public class Game extends Sprite
	{
		private var deck:Deck;
		private var startMenu:StartMenu;
		private var difficultyMenu:DifficultyMenu;
		private var mDifficulty:int;
		private var bPlayMusic:Boolean = true; //Defaults to true, because sound initializes at start
		
		public function Game() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, OnChangeScreen);
			this.addEventListener(MenuEvent.BUTTON_CLICK, OnIngameMenuClick);
			
			startMenu = new StartMenu();
			this.addChild(startMenu);
			startMenu.Show();
			
			difficultyMenu = new DifficultyMenu();
			this.addChild(difficultyMenu);
			difficultyMenu.Hide();
			
		}
		private function OnChangeScreen(evt:NavigationEvent):void
		{
			trace("OnchangeScreen running");
			switch(evt.params.id)
			{
				case "play":
					startMenu.Hide();
					difficultyMenu.Show();
					break;
				case "easy":
					mDifficulty = 1;
					StartGame();
					difficultyMenu.Hide();
					break;
				case "normal":
					mDifficulty = 2;
					StartGame();
					difficultyMenu.Hide();
					break;
				case "hard":
					mDifficulty = 3;
					StartGame();
					difficultyMenu.Hide();
					break;
				default: break;
					
			}
		}
		private function StartGame():void
		{
			if (deck != null)
				this.removeChild(deck, true);
			if (mDifficulty != 1 && mDifficulty != 2 && mDifficulty != 3)
				mDifficulty = 1;
					
			deck = new Deck(mDifficulty);
			this.addChild(deck);
		}
		
		private function OnIngameMenuClick(evt:MenuEvent):void
		{
			trace("IngameMenu  running");
			switch(evt.params.id)
			{
				case "menu":
					deck.Hide();
					difficultyMenu.Show();
					break;
				case "restart":
					StartGame();
					break;
				case "sound":
					MusicOnOff();
					break;
				case "undo":
					deck.Undo();
					break;
				default: break;
					
			}
		}
		private function MusicOnOff():void
		{
			if (bPlayMusic)
			{
				SoundManager.instance.PauseSoundtrack();
				bPlayMusic = false;
			}
			else
			{
				SoundManager.instance.PlayRandomMusic();
			}
				
			
		}
		

	}
	
}
