package  
{
	import customEvents.NavigationEvent;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import customEvents.MenuEvent;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class IngameMenu extends Sprite 
	{
		private var mainMenuBtn:Button;
		private var restartBtn:Button;
		private var soundBtnON:Button;
		private var soundBtnOFF:Button;
		private var undoBtn:Button;
		private var bIsPlaying:Boolean = true;
		
		public function IngameMenu() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
		}
		
		private function OnAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
			
			CreateButtons();
		}
		
		private function OnMenuButtonsClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			
			if (buttonClicked == mainMenuBtn)
			{
				this.dispatchEvent(new MenuEvent(MenuEvent.BUTTON_CLICK, { id:"menu" }, true));
			}
			else if (buttonClicked == restartBtn)
			{
				this.dispatchEvent(new MenuEvent(MenuEvent.BUTTON_CLICK, { id:"restart" }, true));
			}
			else if (buttonClicked == soundBtnON)
			{
				this.dispatchEvent(new MenuEvent(MenuEvent.BUTTON_CLICK, { id:"soundOFF" }, true));
				
				soundBtnON.visible = false;
				soundBtnOFF.visible = true;
			}
			else if (buttonClicked == soundBtnOFF)
			{
				this.dispatchEvent(new MenuEvent(MenuEvent.BUTTON_CLICK, { id:"soundON" }, true));
				
				soundBtnON.visible = true;
				soundBtnOFF.visible = false;
			}
			else if (buttonClicked == undoBtn)
			{
				this.dispatchEvent(new MenuEvent(MenuEvent.BUTTON_CLICK, { id:"undo" }, true));
			}
			
		}
		
		private function CreateButtons():void
		{
			mainMenuBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_BackToMenu"));
			mainMenuBtn.width /= 1.5;
			mainMenuBtn.height /= 1.5;
			this.addChild(mainMenuBtn);
			
			undoBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_Undo"));
			undoBtn.x = mainMenuBtn.width + 50;
			undoBtn.width /= 1.5;
			undoBtn.height /= 1.5;
			this.addChild(undoBtn);
			
			restartBtn = new Button(Assets.getAtlas().getTexture("Arachnotaire_Restart"));
			restartBtn.x = undoBtn.x + undoBtn.width + 50;
			restartBtn.width /= 1.5;
			restartBtn.height /= 1.5;
			this.addChild(restartBtn);
			
			soundBtnON = new Button(Assets.getAtlas().getTexture("Arachnotaire_SoundOn"));
			soundBtnON.x = this.stage.stageWidth - (soundBtnON.width*3);
			soundBtnON.width /= 1.5;
			soundBtnON.height /= 1.5;
			this.addChild(soundBtnON);
			
			soundBtnOFF = new Button(Assets.getAtlas().getTexture("Arachnotaire_SoundOff"));
			soundBtnOFF.x = soundBtnON.x;
			soundBtnOFF.width /= 1.5;
			soundBtnOFF.height /= 1.5;
			this.addChild(soundBtnOFF);
			soundBtnOFF.visible = false;
			
			this.addEventListener(Event.TRIGGERED, OnMenuButtonsClick);
		}
		public function SetButtonState(btnName:String, bEnabled:Boolean):void
		{
			switch(btnName)
			{
				case "menu": trace("disabling menu btn"); mainMenuBtn.enabled = bEnabled; break;
				case "undo": trace("disabling menu btn"); undoBtn.enabled = bEnabled; break;
				case "restart": trace("disabling menu btn"); restartBtn.enabled = bEnabled; break;
				default: break;
			}
		}
	}

}