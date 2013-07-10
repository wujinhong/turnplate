package com.fanhougame.game
{
	import com.fanhougame.framework.Gateway;
	import com.fanhougame.framework.core.AssetManager;
	import com.fanhougame.framework.core.LoopManager;
	import com.fanhougame.framework.core.PreloadManager;
	import com.fanhougame.framework.helper.Clock;
	import com.fanhougame.game.controller.InitGameCommand;
	import com.fanhougame.game.view.Scene.HomeScene;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * @author David-Cai
	 **/
	public class Game extends Gateway
	{
		private static var _instance:Game;  // 游戏单例
		
		public  const CURRENT_SCENE:String="current_scene";
		
		public static const DATA_LOAD_START:String = 'START_DATA_LOADING';

		public static const DATA_LOAD_FINISHED:String = 'DATA_LOAD_FINISHED'
		/**
		 * 游戏初始化 done
		 */
		public static const INIT_GAME_DONE:String='init_game_done';

		private var _status:String; // 游戏状态

		private var _key:int; // 游戏钥匙

		private var _data:Object;

		private var _true_stage:Stage;//舞台

		private var _loop:LoopManager = LoopManager.getInstance();
		
		private var _preloader_controler:Object // preloader 控制器
		
		private var _game_config:GameConfig;
		
		/*
		 * @param singleton
		 * @throws Error
		 */
		public function Game(singleton:SingletonEnforce=null)
		{
			if (singleton == null)
				throw new Error('Game Singleton Error');
		}

		public function get loaderInfo():Object
		{
			if ((_data)&&(_data.vars))
			return this._data.vars;
			else
			return null;
		}

		public static function getInstance():Game
		{
			if (_instance == null)
			{
				_instance=new Game(new SingletonEnforce());
			}
			return _instance;
		}
		
		private function addToStage(e:Event):void
		{
			this._status = 'initial_game';
			this._game_config= GameConfig.getInstance();
			
			this._initScenes();
			this._initCommand();
			this._initCallback();
			//鼠标右键
			this._initMouseRightClickMenu();
			//
			_loop.run(this._stage);
			Clock.initialClock(new Date().time);
		}
		/**
		 * 初始化...
		 **/
		override public function init(stage:Sprite):void
		{
			//初始化 游戏资源
			stage.addEventListener(Event.ADDED_TO_STAGE,addToStage,false,0,true);
			stage.addChild(this._stage);
		}
		/**
		 * 开始游戏
		 **/
		public function start():void
		{
			//看消耗
//			this._stage.addChild(new FPSCounter());
			
			this._stage.stage.frameRate = 25;
			this._stage.stage.scaleMode = 'noScale';
			this._stage.stage.align = StageAlign.TOP_LEFT;
//			this._stage.stage.stageWidth = 750;
//			this._stage.stage.stageHeight = 550;
			this._status='start_game';
			
			this.changeScene(HomeScene.NAME);
			
			this.removeObserver(Game.INIT_GAME_DONE);
			
			//进入主场景后无需再显示与preloader相关
			this.removeCallback(AssetManager.ASSET_LOAD_START,assetLoadingStart);
			this.removeCallback(AssetManager.ASSET_LOADING,assetLoading);
			this.removeCallback(AssetManager.ASSET_LOAD_DONE,assetLoadDone);
		}

		private function _initMouseRightClickMenu():void
		{
			var myContextMenu:ContextMenu=new ContextMenu();
			var GoUrl:ContextMenuItem=new ContextMenuItem(this.version);
			var FlashPlayer:ContextMenuItem=new ContextMenuItem(this.flash_player_version);
			myContextMenu.customItems.push(GoUrl);
			myContextMenu.customItems.push(FlashPlayer);
			myContextMenu.hideBuiltInItems();
			myContextMenu.builtInItems.print=false;
			this._stage.contextMenu=myContextMenu;
		}

		/**
		 * 检查falsh player 版本
		 **/
		public function checkVersion():Boolean
		{
			var verstr:String=Capabilities.version;
			var verary:Array=verstr.split(/[,\ ]/);
			var major:Number=Number(verary[1]);
			var rev:Number=Number(verary[3]);

			if (major == 10 && rev >= 40)
				return true

			return false;
		}

		/**
		 * 初始化场景
		 **/
		override protected function _initScenes():void
		{
			this.registerScene(HomeScene.NAME, HomeScene);
		}
		
		/**
		 * 初始化命令
		 **/
		override protected function _initCommand():void
		{
			var init_game:InitGameCommand=new InitGameCommand();
			init_game.execute();
		}

		/**
		 * 
		 */
		private function _initCallback():void
		{
			//preloader 的消息监听
			//进度条
			this.registerCallback(AssetManager.ASSET_LOAD_START,assetLoadingStart);
			this.registerCallback(AssetManager.ASSET_LOADING,assetLoading);
			this.registerCallback(AssetManager.ASSET_LOAD_DONE,assetLoadDone);
			this.registerCallback(Game.DATA_LOAD_START,dataLoadStart);
			this.registerCallback(Game.DATA_LOAD_FINISHED,dataLoadFinished);
			this.registerCallback(Game.INIT_GAME_DONE,preparationDone);
		}
		/**
		 * 资源加载开始
		 */
		private function assetLoadingStart():void
		{
		}
		/**
		 * 数据加载开始
		 */
		private function dataLoadStart():void
		{
		}
		/**
		 * 数据加载完成
		 */
		private function dataLoadFinished():void
		{
		}
		/**
		 * 资源加载完成
		 */
		private function assetLoadDone():void
		{
		}
		/**
		 * 游戏准备就绪，开始进入主界面
		 * 如果没有发现preloader，直接进入，否则交给preloader来控制进入
		 */
		private function preparationDone():void
		{
				this.start();
		}
		
		/**
		 * 
		 * @param precentage
		 */
		private function assetLoading(precentage:int):void
		{
		}
		
		/**
		 * 版本
		 * @return
		 */
		public function get flash_player_version():String
		{
			return flash.system.Capabilities.version;
		}

		/**
		 * session key
		 * @param value
		 */
		public function set key(value:int):void
		{
			this._key=value;
		}

		/**
		 * session key
		 * @return
		 */
		public function get key():int
		{
			return this._key;
		}

		/**
		 * 版本
		 * @return
		 */
		public function get version():String
		{
			return _game_config.version + _game_config.platform;
		}
		
		/**
		 * 状态
		 * @param value
		 */
		public function set status(value:String):void
		{
			this._status=value;
		}

		/**
		 * 状态
		 * @return
		 */
		public function get status():String
		{
			return this._status;
		}
		
		/**
		 * return
		 * */
		public function get center_x():Number
		{
			return this.width / 2;
		}

		/**
		 *
		 * @return
		 */
		public function get width():Number
		{
			return 760;
		}

		/**
		 *
		 * @return
		 */
		public function get height():Number
		{
			return 570;
		}

		/**
		 * 
		 * @return
		 */
		public function get preloader_controler():Object
		{
			return this._preloader_controler;
		}
 
		/**
		 * @return 舞台
		 */		
		public function get getStage():Stage
		{
			return this._true_stage;
		}
	}
}

internal class SingletonEnforce//单例模式  单态模式
{
}