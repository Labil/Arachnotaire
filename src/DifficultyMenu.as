package  
{
	import customEvents.NavigationEvent;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class DifficultyMenu extends Sprite 
	{
		private var easyBtn:Button;
		private var normalBtn:Button;
		private var hardBtn:Button;
		
		private var difficulty:Image;
		
		public function DifficultyMenu() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			DrawScreen();
		}
		private function onMainMenuClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			
			if (buttonClicked == easyBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"easy" }, true));
			}
			else if (buttonClicked == normalBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"normal" }, true));
			}
			else if (buttonClicked == hardBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"hard" }, true));
			}
		}
		private function DrawScreen():void
		{
			difficulty = new Image(Assets.getAtlas().getTexture("Arachnotaire_Difficulty"));
			difficulty.x = stage.width / 2 - difficulty.width / 2;
			difficulty.y = stage.height / 2 - 80;
			this.addChild(difficulty);
			
			easyBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_easy"));
			normalBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_normal"));
			hardBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_hard"));
			
			easyBtn.x = stage.width/3 - easyBtn.width;
			easyBtn.y = stage.height/2;
			this.addChild(easyBtn);
			
			normalBtn.x = stage.width/2 - normalBtn.width/2;
			normalBtn.y = stage.height/2;
			this.addChild(normalBtn);
			
			hardBtn.x = stage.width/2 + hardBtn.width;
			hardBtn.y = stage.height/2;
			this.addChild(hardBtn);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		public function Show():void
		{
			this.visible = true;
			
		}
		
		public function Hide():void
		{
			this.visible = false;
		}
		
	}

}