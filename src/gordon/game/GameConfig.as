﻿package com.fanhougame.game
{
	import com.fanhougame.framework.core.AssetObj;
	import com.fanhougame.framework.core.SoundManager;
	import flash.utils.Dictionary;
	
	public class GameConfig
	{
		//本地测试时使用，校友必须改成否：是否开启不需要session
		public var debug:Boolean = true;
		
		//版本号
		public var version:String='家园框架 0.1 beta ';
		
		private var _asset_obj_config:Dictionary = new Dictionary(true);
		private var _game:Game = Game.getInstance();
		private static var _instance:GameConfig; // 游戏配置单例
		
		private var _temp_paramsObj:Object;
		//普通的资源版本
		private var flash_version:Array = ['ui_big_frame'];
		//活动的资源版本
		private var activity_version:Array = ['xmas_1'];
		 
		
		public function GameConfig(singleton:SingletonEnforce=null)
		{
			if (singleton == null)
				throw new Error('Game Singleton Error');
			init();
		}
		/**
		 *单例
		 */
		public static function getInstance():GameConfig
		{
			if (_instance == null)
			{
				_instance=new GameConfig(new SingletonEnforce());
			}
			return _instance;
		}
		public function init():void
		{
			if(_game.status !='initial_game')
			{
				throw new Error('顺序出错');
			}
			initParameter();
		}
		
		public function initResource():void
		{
			initAssetObj();
		}
		
		/**
		 * 初始化参数
		 */
		private function initParameter():void
		{
			var loaderInfo:Object = _game.loaderInfo;
			//使用下载后
			if (loaderInfo)
			{
				_temp_paramsObj = loaderInfo.parameters;
			}
			else
			{
				_temp_paramsObj = 
				{
					'skey': 'key_5',

					'platform': 'xiaoyou',//'xiaoyou'

					'gateway':'http://192.168.0.10/facebook/trunk/gateway.php',
//					'gateway':'http://192.168.0.6/new_ui/gateway.php',
					
					'info':'0',
					
					'effect_mute':'0',
					
					'music_mute':'0'
				}
			}
		}
		/**
		 * 游戏资源地址
		 **/
		public function get resource_url():String
		{
				return 'http://127.0.0.1/demo/';
		}
		
		/**
		 * 初始化游戏资源路径
		 **/ 
		private function initAssetObj():void
		{
			addAssetObj('ship',flash_path + 's_15.swf',200867);
			addAssetObj('bullet',flash_path + 'bullet.swf',200867);
			addAssetObj('tower',flash_path + 'tower.swf',200867);
			addAssetObj('ship_ui',flash_path + 'ship_ui.swf',2538496);
		}
		
		private function addAssetObj(type:String,path:String,size:int):void
		{
			if(getVersion(type) !='')
			{
				path += '?v='+getVersion(type);
			}
			var asset_obj:AssetObj = new AssetObj(type,path,size);
			if (!_asset_obj_config[type])
			{
				_asset_obj_config[type] = asset_obj;
			}
			else
			{
				throw new Error('重复注册assetObj:'+type);
			}
		}
		
		public function getAssetObj(type:String):AssetObj
		{
			if ( _asset_obj_config[type])
				return  _asset_obj_config[type]
			else
				throw new Error('没有找到资源obj : '+type);
		}
		
		/**
		 * flash *.swf资源路径
		 **/
		public function get flash_path():String
		{
			return this.resource_url;
		}
		/**
		 * 服务器交互路径
		 * 多平台不同路径
		 **/
		public function get service_gateway_url():String
		{
				return this._temp_paramsObj.gateway;
		}
		
		/**
		 *加载introduction的语言控制开关 
		 */
		public function get language_contoler():String
		{
			return 'zh-cn';
		}
		
		public function get skey():String
		{
			return this._temp_paramsObj['skey'];
		}
		
		public function get platform():String
		{
			return this._temp_paramsObj['platform'];
		}
		/**
		 * @return
		 */
		public function get center_x():Number
		{
			return _game.width / 2;
		}
		/**
		 * @return
		 */
		public function get center_y():Number
		{
			return _game.height / 2;
		}
		
		public function get temp_paramsObj():Object
		{
			return this._temp_paramsObj;
		}
		
		//获得版本号
		public function getVersion(type:String):String
		{
			return '';
		}
	
	}
}
internal class SingletonEnforce
{
}