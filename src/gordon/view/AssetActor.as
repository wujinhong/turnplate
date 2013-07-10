package com.fanhougame.framework.view
{
	import com.fanhougame.framework.core.AssetManager;
	import com.fanhougame.framework.core.SoundManager;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	public class AssetActor extends Actor
	{
		private var _pixels:BitmapData;
		private var _link_name:String;
		
		public function AssetActor(actor_name:String,link_name:String)
		{
			super(actor_name);
			_link_name = link_name;
			if(_link_name !='')
			{
				var asset_manager:AssetManager= AssetManager.getInstance();
				var ComponentClass:Class = asset_manager.GetAsset(link_name);
				if(ComponentClass)
				{
	 				this._body = new ComponentClass() as MovieClip;
				}
				else
				{
					ComponentClass = asset_manager.GetAsset('null_pic');
					if(ComponentClass)
					{
						this._body = new ComponentClass() as MovieClip;
					}
					else
					{
						this._body = new MovieClip();
					}
				}
			}
			else
			{
				this._body = new MovieClip();
			}
			this._width = this._body.width;
			this._height = this._body.height;
		}
		/**
		 * 直接加载资源
		 * @param link_name
		 * @return MovieClip
		 */
		public function addAsset(link_name:String):MovieClip
		{
			var asset_manager:AssetManager= AssetManager.getInstance();
			var ComponentClass:Class = asset_manager.GetAsset(link_name);
			return new ComponentClass() as MovieClip;
		}
		/**
		 * 播放声音...
		 **/ 
		public function playSound(link_name:String,volume:Number=1,start_time:Number=0,loop:int=0,category:String=''):void
		{
			//先判断资源里面有没有该声音文件
			var sound_manager:SoundManager = SoundManager.getInstance(); 
			if (sound_manager.addLibrarySound(link_name,true))
			{
				sound_manager.playSound(link_name,volume,start_time,loop,category);
			}
		}
		/**
		 * 停止播放声音...
		 **/ 
		public function stopSound(link_name:String):void
		{
			var sound_manager:SoundManager = SoundManager.getInstance(); 
			sound_manager.stopSound(link_name);
		}
		public function get link_name():String
		{
			return _link_name;
		}
	}
}