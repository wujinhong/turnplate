package gordon.model
{
	import gordon.core.Notifier;

	/**
	 * 模型
	 * @author 
	 */
	public class Model extends Notifier
	{
		/**
		 * 模型名
		 * @default 
		 */
		protected var _model_name:String;  // 当前模型的名称
		
		/**
		 * 数据绑定观察者
		 * @default 
		 */
		protected var _binder:Array = [];  // 
		
		/**
		 * 初始化时必要的属性
		 * @default 
		 */
		protected var _requested_property:Array = []; // 
		
		/**
		 * 用于判断是否初始化成功
		 * @default 
		 */
		protected var _initialized:Boolean = false;  // 
		
		/**
		 * 初始化模型,并简单检测数据完整性
		 * @param name 
		 * @param data 
		 * @throws InitializeModelError 
		 */
		public function Model(name:String, data:Object=null)
		{
			this._model_name = name;
			
			var request_num:uint = this._requested_property.length;
			
			for(var i:String in data)
			{
				if(this.hasOwnProperty(i))
				{
					this[i] = data[i];
					if(this._requested_property.indexOf(i) >= 0)
					{
						request_num--;
					}
				}
			}
			
			if(request_num >0)
			{
				trace( 'Error in '+this._model_name+' model: Missing '+request_num+' requested properties!');
			}
			
			this._initialized = true;
			
		}
 
		/**
		 * 获取模型的名字
		 **/
		public function get Name():String
		{
			return this._model_name;
		}
		
		/**
		 * 为模型注射入新的数据
		 **/
		public function inject(data:Object):void
		{
			for(var i:String in data)
			{
				if(this.hasOwnProperty(i))
				{
					this[i] = data[i];
					this._refreshBindObj(i);
				}
			}
		}
		
		/**
		 * 绑定数据源
		 **/
		public function bind(property:String,func:Function):void
		{
			if(this._binder[property])
			{
				this._binder[property].push(func);
			}
			else
			{
				this._binder[property] = [];
				this._binder[property].push(func);
			}
		}
		
		/**
		 * 解除数据源的绑定
		 **/
		public function unbind(property:String,func:Function):void
		{
			if(this._binder[property])
			{
				var index:int = this._binder[property].indexOf(func);
				if(index >=0)
				{
					this._binder[property].splice(index,1);
					if(this._binder[property].length<=0)
					{
						this._binder[property] = null;
						delete this._binder[property];
					}
				}
			}
		}
		
		/**
		 * 刷新被绑定的对象
		 **/
		protected function _refreshBindObj(property:String):void
		{ 
			if(this._binder[property])
			{
				for(var i:uint=0; i<_binder[property].length; i++)
				{
					var func:Function = this._binder[property][i] as Function;
					func(this[property]);
				}
			}
		}
		
		
		protected function clear():void
		{
			
		}

		/**
		 * 析构函数
		 */
		public function cleanUp():void
		{
			this.cleanAllCallback();
		}
	}
}