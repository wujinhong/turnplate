package gordon.game
{
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import gordon.core.Notifier;
	import gordon.model.Model;
	import gordon.view.Interface.ICurtain;
	
	/**
	 * 入口
	 * @author 
	 */
	public class Gateway extends Notifier
	{
		
		/**
		 * 初始化完成
		 * @default 
		 */
		public static const INIT_GAME_DONE:String= 'init_game_done';
		
		public static const CURTAIN:String = 'CurtainScene';
		
        /**
         * 对象注册器
         * @default 
         */
        protected var _objects:Dictionary = new Dictionary(true); // 
        
        /**
         * 游戏舞台
         * @default 
         */
        protected var _stage:Sprite = new Sprite();  // 
		
		/**
		 * 舞台层次
		 **/
		protected var _stage_layer:Object = {};	// 
		
		/**
		 * 场景注册器
		 **/
		protected var _scenes_list:Object = {};
		
		/**
		 * 幕布
		 **/
		protected var _curtain:Scene;
		
		
        
        /**
         * 单一场景控制器
         * @default 
         */
        protected var _scene:Scene;  // 
        
        
        public function Gateway()
        {
			// 初始化舞台
			this._stage_layer['BackStage'] = new Sprite();
			this._stage_layer['Stage'] = new Sprite();
			this._stage_layer['Curtain'] = new Sprite();
			
			this._stage.addChild(this._stage_layer['BackStage']);
			this._stage.addChild(this._stage_layer['Stage']);
			this._stage.addChild(this._stage_layer['Curtain']);
        }
        
        /**
         * 初始化 游戏资源
         * @param stage
         */
        public function init(stage:Sprite):void
        {
        	//
        	stage.addChild(this._stage);
        	this._initScenes();
        	this._initCommand();
        }
        
        /**
         * 
         */
        protected function _initScenes():void
        {
        	
        }
        
        /**
         * 
         */
        protected function _initCommand():void
        {
        	
        }
		
		/**
		 * 注册场景
		 **/
		public function registerScene(name:String, scene:Class):void
		{
			this._scenes_list[name] = scene;
		}
        
        /**
         * 进入场景
         * @param scene
         */
        public function changeScene(name:String):void
        {
			if(!this._scenes_list[name])
			{
				throw new Error('Change Scene Exception: '+name+' never register!');
			}
			
			if(this._scenes_list[CURTAIN])		// 初始化 幕布 如果有幕布存在，则落下幕布，然后再清除原场景
			{
				if(!this._curtain)
				{
					this._curtain = new this._scenes_list[CURTAIN]();
					if(!this._curtain is ICurtain)
					{
						throw new Error('Error in Curtian Init! It should implament ICurtain');
					}
					this._curtain.action(this._stage_layer['Curtain']);
				}
				(this._curtain as ICurtain).drop();
			}
			
        	if(_scene != null)
        	{
        		_scene.cleanUp();
				_scene = null;
        	}
			
        	_scene = new this._scenes_list[name]();
        	_scene.action(this._stage_layer['Stage']);
			
			if(this._curtain)		// 开幕
			{
				(this._curtain as ICurtain).open();
			}
        }
        
        /**
         *  注册新对象
         **/
        public function registerObj(obj_name:String,obj:Object):void
        {
        	if(!this._objects[obj_name])
        	{
        		this._objects[obj_name] = obj;
        	}
        	else
        	{
        		throw new Error('Error: "'+obj_name+'" 重复注册');
        	}
        }
         
        /**
         *  重写对象
         *  如果指定obj已经存在,且对象是Notifier,则清空Notifier内注册的所有 Notification
         **/
        public function rewriteObj(obj_name:String, obj:Object):void
        {
        	this.removeObj(obj_name);       	
        	this._objects[obj_name] = obj;
        }
        
        /**
         *  获取对象
         **/
        public function getObj(obj_name:String):Object
        {
        	if (this._objects[obj_name]==null)
        	{
        		return null;
        	}
        	return this._objects[obj_name];
        }
         
        /**
         * 移除对象
         **/
        public function removeObj(obj_name:String):void
        {
        	if(this._objects[obj_name])
        	{
        		// 如果这个对象是Notifier 则清空内部所有 Notification
//        		trace('移除对象'+obj_name)
				if(this._objects[obj_name] is Notifier) 
        		{
        			(this._objects[obj_name] as Notifier).cleanAllCallback();
        		}
        		
        		if(this._objects[obj_name] is Model) 
        		{
        			(this._objects[obj_name] as Model).cleanUp();
        		}
        		this._objects[obj_name] = null;
        	}
        }
    }
}