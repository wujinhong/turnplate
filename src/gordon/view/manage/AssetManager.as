package gordon.view.manage
{
	import flash.events.Event;
	
	import gordon.core.NoteObserver;

	/**
	 * AssetManager 是一个资源加载类，开始会从GAME单例里面获得要加载的路径，再逐个去加载
	 * 加载完毕会发出通知。
	 * 可以通过本类获得资源
	 * @author David-Cai
	 */
	public class AssetManager
	{
		/**
		 * 加载完成
		 * @default 
		 */
		public static const ASSET_LOAD_DONE:String = 'asset_load_done';
		/**
		 * 
		 * @default 
		 */
		public static const ASSET_LOAD_START:String = 'asset_load_start';
		/**
		 * 加载中
		 * @default 
		 */
		public static const ASSET_LOADING:String = 'asset_loading';
		
	    private var AssetClass:Class;
	    
	    private var _notification_manager:NoteObserver = NoteObserver.getInstance();
	    
	    private static var asset_manager:AssetManager;  // 资源管理器 单例管理
	    
	    private var _loader:BulkLoader;
	    
	    private var _all_loader:Array =[]; // 11个文件的loader 
	    private var _all_class:Array = []; //文件的CLASS链接..
	    
		private var _all_asset_objs:Array = [] // 所有资源地址,需要加载的
		private var _all_asset_path:Array = []
			
	   	private var _done_callbacks:Array = [];//所有回調函數
		
	   	private var _init:Boolean = false;
		private var _show_progress:Boolean = true;
		private var _total_bytes:int = 0;
		private var _pre_precentage:int = 0;
		/**
	     * 资源管理器
		 * @param singleton 
		 * @throws Error
		 */
		public function AssetManager(singleton:SingletonEnforce = null)
		{
			if(singleton == null)
				throw new Error('AssetManager Singleton Error!!');
		}
		public function init(paths:Array):void
		{
			if (!_init)
			{
				_loader = new BulkLoader('asset');
				for (var i:int=0; i<paths.length; i++)
				{
					trace('地址:'+paths[i].path);
					addAsset(paths[i]);
				}
				_loader.addEventListener(BulkLoader.COMPLETE, AssetLoadDone,false,0,true);
				_loader.addEventListener(BulkLoader.PROGRESS,AssetLoading,false,0,true);
				_notification_manager.sendNotification(ASSET_LOAD_START);//消息接收、發送
				_loader.start();
			}
			else
			{
				throw new Error('AssetManager init already!');
			}
			_init = true;
		}
		public function get initilized():Boolean
		{
			return _init;
		}
		/**
		 * 
		 * @param path
		 */
		private function addAsset(assetObj:AssetObj):Boolean
		{
			if (_all_asset_objs.indexOf(assetObj) == -1)
			{
				trace('path:'+assetObj.path)
				_all_asset_objs.push(assetObj);
				_all_asset_path.push(assetObj.path);
				_loader.add(assetObj.path);
				this._total_bytes += assetObj.size;
				return true;
			}
			else
			{
				return false;
			}
		}
		public function has_asset(assetObj:AssetObj):Boolean
		{
			if (_loader.get(assetObj.path)!=null)
			{

				if (_all_loader.indexOf(_loader.get(assetObj.path)) != -1)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
			
		}
		public function has_loading_asset(assetObj:AssetObj):Boolean
		{
			if (_all_asset_path.indexOf(assetObj.path) != -1)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		public function has_asset_by_path(path:String):Boolean
		{
			return (_loader.get(path)!=null);
		}
		/**
		 * show_progress 是否显示进度条
		 **/ 
		public function addNewAssets(assetObjs:Array,done:Function,show_progress:Boolean = true):void
		{
			_show_progress = show_progress;
			var done_amount:int = 0;
			
//			Debuger.dump(_all_asset_objs);
			
			for each(var assetObj:AssetObj in assetObjs)
			{
				if (has_asset_by_path(assetObj.path))
				{
					throw new Error('资源重复加载！');
				}
				if (_all_asset_objs.indexOf(assetObj)==-1)
				{
					_all_asset_objs.push(assetObj);
					_all_asset_path.push(assetObj.path);
					_loader.add(assetObj.path);
					this._total_bytes += assetObj.size;
					_done_callbacks.push(done);
				}
				else
				{
					done_amount ++;
				}
			}
			if (done_amount == assetObjs.length)
			{
				if (_done_callbacks.indexOf(done) != -1)
				{
					_done_callbacks.splice(_done_callbacks.indexOf(done),1);
				}
				done();
			}
			else
			{
				_notification_manager.sendNotification(ASSET_LOAD_START);
			}
		}
		/**
		 * 
		 * @param path
		 * @param done
		 */
		public function addNewAsset(assetObj:AssetObj,done:Function,show_progress:Boolean = true):void
		{
			_show_progress = show_progress;
			if (!this.has_asset( assetObj))
			{
				_all_asset_objs.push(assetObj);
				_all_asset_path.push(assetObj.path);
				_loader.add(assetObj.path);
				_done_callbacks.push(done);
				_notification_manager.sendNotification(ASSET_LOAD_START);
			}
			else
			{
				_notification_manager.sendNotification(ASSET_LOAD_DONE);
				if (_done_callbacks.indexOf(done) != -1)
				{
					_done_callbacks.splice(_done_callbacks.indexOf(done),1);
				}
				if (done != null)
				done();
			}
		}
		
		/**
		 * 加载中. 监控
		 * @param e BulkProgressEvent事件对象
		 */
		private function AssetLoading(e:BulkProgressEvent):void
		{
			var total:int = 0;
			
			if (_show_progress)
			{
				if (e.bytesTotal == 0)
				{
					total = _total_bytes;
				}
				var precentage:Number = e.bytesLoaded / _total_bytes;
				//trace('precentage'+int(precentage*100));
				_notification_manager.sendNotification(ASSET_LOADING,Math.min(100,int(precentage*100)));
			}
		}
		/**
		 * 资源获取完毕 回调
		 * @param e Event
		 */
		private function AssetLoadDone(e:Event):void
		{
			for (var i:int=0; i<_all_asset_objs.length ; i++)
			{
				if (_all_loader.indexOf(_loader.get(_all_asset_objs[i].path))==-1)
				{
					this._all_loader.push(_loader.get(_all_asset_objs[i].path));
					trace('loading done path:' +_all_asset_objs[i].path+' byte:'+_loader.get(_all_asset_objs[i].path).bytesTotal);
				}
			}
			_total_bytes = 0;
			_notification_manager.sendNotification(ASSET_LOAD_DONE);
			if (this._done_callbacks.length >0 )
			{
				for each (var done:Function in _done_callbacks)
				{
					if (done!=null)
					{
						done();
					}
				}
				_done_callbacks = [];
			}
			
		}
		
		/**
		 * 获取资源管理器单例
		 * @return AssetManager 全局单例
		 */
		public static function getInstance():AssetManager
		{
			if(asset_manager==null)
				asset_manager = new AssetManager(new SingletonEnforce());
			return asset_manager;
		}
		
		/**
		 * 获取资源
		 * @param AssetName 类名
		 * @return  资源类
		 */
		public function GetAsset(AssetName:String):Class
		{
			if (_all_class[AssetName]!=null)
			{
				return _all_class[AssetName] as Class;
			}
			else
			{
				for each(var loader:Object in  _all_loader)
				{
					if (loader.getDefinition(AssetName))
					{
						//trace((loader.loader as Loader).contentLoaderInfo.url);
						_all_class[AssetName] = loader.getDefinition(AssetName) as Class;
						return _all_class[AssetName];
					}
				}
			}
			return null;
		}
		
		public function get show_progress():Boolean
		{
			return this._show_progress;
		}
	}
}
internal class SingletonEnforce{}