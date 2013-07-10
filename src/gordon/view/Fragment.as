package gordon.view
{
	import flash.display.DisplayObjectContainer;
	import gordon.view.manage.SoundManager;

	/**
	 * 片段， 片段可以由多个演员一起演出，场景可以有多个片段。
	 *  
	 **/
	public class Fragment extends Show
	{
		public function Fragment(fragement_name:String)
		{
			super(fragement_name);
		}
		
		public function play(scene:DisplayObjectContainer, x:Number, y:Number):void
		{
			scene.addChild(this._stage);
			this._stage.x = x;
			this._stage.y = y;
		}
		public function set visible(value:Boolean):void
		{
			this._stage.visible = value;
		}
		/**
		 * 播放声音...
		 **/ 
		public function playSound(link_name:String,volume:Number=1,start_time:Number=0,loop:int=0):void
		{
			var sound_manager:SoundManager = SoundManager.getInstance(); 
			sound_manager.addLibrarySound(link_name);
			sound_manager.playSound(link_name,volume,start_time,loop);			
		}
	}
}