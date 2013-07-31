package  {
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flashx.textLayout.formats.BackgroundColor;
	
	public class Intro extends MovieClip{

		
		private var _intro:IntroBackground;
		private var _background:StartSkjerm;
		private var _dameknapp:Dameknapp;
		private var _kaninknapp:Kaninknapp;
		private var _v:Vanskelighetsgrad;
		private var _lett:Lett;
		private var _middels:Middels;
		private var _vanskelig:Vanskelig;
		private var _finished:Boolean = false;
		private var _illustrasjon:String;
		private var _vanskelighetsgrad:int;
		public const ANIMATION_COMPLETE:String = "animation_complete";
		private var m_stage:Stage;
		
		public function Intro(_stage:Stage) 
		{
			_intro = new IntroBackground();
			_intro.x = 0;
			_intro.y = 0;
			m_stage = _stage;
			m_stage.addChild(_intro);
			m_stage.addEventListener(Event.ENTER_FRAME, onEnter);
			addEventListener(ANIMATION_COMPLETE, onLastFrame);
			//_intro.addEventListener(MouseEvent.CLICK, onMouseClick);
			// constructor code
		}
		private function onEnter(e:Event):void
		{
			trace("enter");
			if(_intro.currentFrame == _intro.totalFrames)
			{
				_intro.gotoAndStop(140);
				var evt:Event = new Event(ANIMATION_COMPLETE);
				dispatchEvent(evt);
				m_stage.removeEventListener(Event.ENTER_FRAME, onEnter);
				trace("kek");
			}
		}
		private function onLastFrame(e:Event):void
		{
			m_stage.removeChild(_intro);
			_background = new StartSkjerm();
			m_stage.addChild(_background);
			_kaninknapp = new Kaninknapp();
			_kaninknapp.x = 245;
			_kaninknapp.y = 580;
			m_stage.addChild(_kaninknapp);
			_kaninknapp.addEventListener(MouseEvent.CLICK, onKaninknapp);
			_dameknapp = new Dameknapp();
			_dameknapp.x = 710;
			_dameknapp.y = 580;
			m_stage.addChild(_dameknapp);
			_dameknapp.addEventListener(MouseEvent.CLICK, onDameknapp);
			
		}
		public function getDifficulty():int
		{
			return _vanskelighetsgrad;
		}
		public function getIllustration():String
		{
			return _illustrasjon;
		}
		private function onKaninknapp(e:MouseEvent):void
		{
			_illustrasjon = "kanin";
			removeButtons();
			addNextChoice();
		}
		private function onDameknapp(e:MouseEvent):void
		{
			_illustrasjon = "damer";
			removeButtons();
			addNextChoice();
		}
		private function addNextChoice():void
		{
			_v = new Vanskelighetsgrad();
			_v.x = 187;
			_v.y = 550;
			m_stage.addChild(_v);
			
			_lett = new Lett();
			_lett.x = 187;
			_lett.y = 643;
			m_stage.addChild(_lett);
			_lett.addEventListener(MouseEvent.CLICK, onLett);
			
			_middels = new Middels();
			_middels.x = 532;
			_middels.y = 643;
			m_stage.addChild(_middels);
			_middels.addEventListener(MouseEvent.CLICK, onMiddels);
			
			_vanskelig = new Vanskelig();
			_vanskelig.x = 848;
			_vanskelig.y = 643;
			m_stage.addChild(_vanskelig);
			_vanskelig.addEventListener(MouseEvent.CLICK, onVanskelig);
			
		}
		private function onLett(e:MouseEvent):void
		{
			_vanskelighetsgrad = 1;
			clearLevel();
		}
		private function onMiddels(e:MouseEvent):void
		{
			_vanskelighetsgrad = 2;
			clearLevel();
		}
		private function onVanskelig(e:MouseEvent):void
		{
			_vanskelighetsgrad = 3;
			clearLevel();
			
		}
		private function clearLevel():void
		{
			m_stage.removeChild(_v);
			m_stage.removeChild(_lett);
			m_stage.removeChild(_middels);
			m_stage.removeChild(_vanskelig);
			m_stage.removeChild(_background);
			_finished = true;
		}
		private function removeButtons():void
		{
			_kaninknapp.removeEventListener(MouseEvent.CLICK, onKaninknapp);
			_dameknapp.removeEventListener(MouseEvent.CLICK, onDameknapp);
			m_stage.removeChild(_kaninknapp);
			m_stage.removeChild(_dameknapp);
		}
		/*private function onMouseClick(ev:MouseEvent):void
		{
			_finished = true;
		}*/
		public function isFinished():Boolean
		{
			return _finished;
		}

	}
	
}
