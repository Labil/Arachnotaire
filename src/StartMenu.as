package  
{
	import customEvents.NavigationEvent;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class StartMenu extends Sprite 
	{
		private var bg:Image;
		private var playBtn:Button;
		private var rulesBtn:Button;
		private var aboutBtn:Button;
		
		public function StartMenu() 
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
			if (buttonClicked == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"play" }, true));
			}
			else if (buttonClicked == aboutBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"about" }, true));
			}
			else if (buttonClicked == rulesBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"rules" }, true));
			}
		}
		private function DrawScreen():void
		{
			bg = new Image(Assets.getTexture("MainMenuBG"));
			this.addChild(bg);
			
			playBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_Play_Btn"));
			rulesBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_Rules_Btn"));
			aboutBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_About_Btn"));
			
			playBtn.x = stage.width/2 - playBtn.width/2;
			playBtn.y = stage.height/2 - playBtn.height;
			this.addChild(playBtn);
			
			rulesBtn.x = stage.width/2 - 40;
			rulesBtn.y = stage.height/2 + 5;
			this.addChild(rulesBtn);
			
			aboutBtn.x = stage.width/2 - aboutBtn.width/2;
			aboutBtn.y = stage.height/2 + 50;
			this.addChild(aboutBtn);
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		public function Show():void
		{
			this.visible = true;
			
			this.addEventListener(Event.ENTER_FRAME, buttonAnimation);
		}
		
		public function Hide():void
		{
			this.visible = false;
			
			if (this.hasEventListener(Event.ENTER_FRAME)) 
				this.removeEventListener(Event.ENTER_FRAME, buttonAnimation);
		}
		
		private function buttonAnimation(evt:Event):void
		{
			var currentDate:Date = new Date();
			playBtn.y = stage.height/2 - playBtn.height + (Math.cos(currentDate.getTime() * 0.002) * 1);
		}
		
	}

}