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
		private var winScreen:WinScreen;
		
		
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
				case "win":
					ShowWinScreen(evt.params.time, evt.params.score);
					break;
				case "winclose":
					CloseWinScreen();
					break;
				default: break;
					
			}
		}
		private function StartGame():void
		{
			if (deck != null)
				this.removeChild(deck, true);
			else
				SoundManager.instance.PlayRandomMusic();
			if (mDifficulty != 1 && mDifficulty != 2 && mDifficulty != 3)
				mDifficulty = 1;
					
			deck = new Deck(mDifficulty);
			this.addChild(deck);
		}
		private function ShowWinScreen(time:String, score:int):void
		{
			var color:String = "";
			
			if (deck != null)
				color = deck.GetCardType()
				
			winScreen = new WinScreen(mDifficulty, color, time, score);
			this.addChild(winScreen);
			winScreen.Show();
		}
		private function CloseWinScreen():void
		{
			if(winScreen != null)
				this.removeChild(winScreen, true);
			if (deck != null)
				this.removeChild(deck, true);
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
				case "soundON":
					MusicOn();
					break;
				case "soundOFF":
					MusicOff();
					break;
				case "undo":
					deck.Undo();
					break;
				default: break;
					
			}
		}
		private function MusicOff():void
		{
			SoundManager.instance.PauseSoundtrack();
		}
		private function MusicOn():void
		{
			SoundManager.instance.PlayRandomMusic();
		}
		

	}
	
}
