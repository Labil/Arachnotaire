package  
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Solveig Hansen
	 */
	public class Assets 
	{
		[Embed(source = "../assets/Arachnotaire_bgs/Arachnotaire_Startmenu_bg.png")]
		private static const MainMenuBG:Class;
		
		/*[Embed(source = "../assets/Arachnotaire_bgs/Arachnotaire_Rules_Menu.png")]
		private static const RulesMenuBG:Class;
		
		[Embed(source = "../assets/Arachnotaire_bgs/Arachnotaire_About_Menu.png")]
		private static const AboutMenuBG:Class;
		
		[Embed(source = "../assets/Arachnotaire_bgs/Arachnotaire_Game_bg.png")]
		private static const GameBG:Class;*/
		
		/*[Embed(source = "../assets/Fonts/arialblack.ttf", embedAsCFF="false", fontFamily="Arial")]
		public static const ArialBlack:Class;*/
		
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source = "../assets/SpriteSheets/Arachnotaire_Atlas.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source = "../assets/SpriteSheets/Arachnotaire_Atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
	}

}