package  
{
	import flash.events.IOErrorEvent;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import starling.display.Sprite;
	import flash.media.Sound;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	
	public class SoundManager extends Sprite 
	{
		public static var instance:SoundManager = new SoundManager();
		
		private var mSounds:Array = [];
		private static var mSoundChannel:SoundChannel = new SoundChannel();
		private var mSoundPausePos:int = 0;
		private var mCurrentSound:Sound;
		
		public function SoundManager() 
		{
		}
		
		/*private function OnLoadComplete(evt:Event):void
		{
			var sound:Sound = evt.target as Sound;
			sound.play();
		}*/
		
		private function OnIOError(evt:IOErrorEvent):void
		{
			trace("The sound could not be loaded: " + evt.text);
		}
		
		public function PlaySoundtrack(name:String):void
		{
			mCurrentSound = mSounds[name] as Sound;
		
			if (!mCurrentSound)
			{
				var url:String = "http://plainbrain.net/Lefsa/Applications/Apps/" + name + ".mp3";
				mCurrentSound = new Sound(new URLRequest(url));
				mSounds[name] = mCurrentSound;
				//sound.addEventListener(Event.COMPLETE, OnLoadComplete);
				mCurrentSound.addEventListener(IOErrorEvent.IO_ERROR, OnIOError);
			}
			
			mSoundChannel = mCurrentSound.play();
			mSoundChannel.addEventListener(Event.SOUND_COMPLETE, OnSoundFinished);
		}
		
		public function PlayRandomMusic():void
		{
			if (mSoundPausePos != 0)
			{
				trace("Sound already playing in this channel");
				mSoundChannel = mCurrentSound.play(mSoundPausePos);
				mSoundChannel.addEventListener(Event.SOUND_COMPLETE, OnSoundFinished);
				trace(mSoundChannel.hasEventListener(Event.SOUND_COMPLETE));
				return;
			}
				
			var num:Number = Math.floor (Math.random() * MusicEnums.MUSIC.length); 
			
			PlaySoundtrack(MusicEnums.MUSIC[num]);
		}
		
		public function PauseSoundtrack():void
		{
			mSoundPausePos = mSoundChannel.position;
			mSoundChannel.removeEventListener(Event.SOUND_COMPLETE, OnSoundFinished);
			mSoundChannel.stop();
		}
		
		private function OnSoundFinished(evt:Event):void
		{
			trace("Sound finished");
			mSoundPausePos = 0;
			mSoundChannel.removeEventListener(Event.SOUND_COMPLETE, OnSoundFinished);
			PlayRandomMusic();
		}
	}

}