package  
{
	
	import starling.display.Sprite;
	import starling.events.Event;
	import customEvents.NavigationEvent;
	import customEvents.RestartEvent;
	
	public class Game extends Sprite
	{
		private var deck:Deck;
		private var startMenu:StartMenu;
		private var difficultyMenu:DifficultyMenu;
		private var mDifficulty:int;
		
		public function Game() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, OnChangeScreen);
			this.addEventListener(RestartEvent.RESTART_GAME, OnRestartGame);
			
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
				/*case "ingameRules":
					ingameRules.Show();
					deck.Hide();
					break;
				case "backToGame":
					ingameRules.Hide();
					deck.Show();
					break;*/
				default: break;
					
			}
		}
		private function StartGame():void
		{
			deck = new Deck(mDifficulty);
			this.addChild(deck);
		}
		private function OnRestartGame(evt:RestartEvent):void
		{
			trace("On restart game");
			this.removeChild(deck, true);
			
			deck = new Deck(1);
			deck.Show();
			this.addChild(deck);
			
		}
		

	}
	
}
