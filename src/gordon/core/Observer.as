package gordon.core
{
	import gordon.control.Command;
		
	/**
	 * 观察者，当有信息MESSAGE发出时，会自动响应已经注册了的函数
	 * @author 
	 */
	public class Observer
	{
		private static var _notification:Observer; // 存储信息管理器对象
				
		private var _notification_manager:Object = {}; // 消息列表
		
		private var _command_manager:Object = {}; // 命令列表

		/**
		 * 
		 * @param singleton
		 * @throws Error
		 */
		public function Observer(singleton:SingletonEnforce = null)
		{	
			if(singleton==null)
				throw new Error('Notification Singleton Error!!');
		}
		
		
		
		/**
		 * 获取信息管理器对象单例
		 * @return NotificationObserver单例
		 */
		public static function getInstance():Observer
		{
			if(_notification==null)
				_notification = new Observer(new SingletonEnforce());
			
			return _notification;
		}

		/**
		 * 注册回调函数
		 * @param message 消息名字
		 * @param callback 回调函数
		 */
		public function registerCallback(message:String, callback:Function):void
		{
			if(this._notification_manager[message])  
			{
				this._notification_manager[message].push(callback);
			}
			else
			{
				this._notification_manager[message] = [];
				this._notification_manager[message].push(callback);
			}
		}
		
		/**
		 * 注册命令
		 * @param message 消息名字
		 * @param command 命令
		 */
		public function registerCommand(message:String, command:Class):void
		{
			if(this._notification_manager[message])
			{
				this._notification_manager[message].push(command);
			}
			else
			{
				this._notification_manager[message] = [];
				this._notification_manager[message].push(command);
			}
		}
		
		/**
		 * 执行Notification
		 * @param message 消息名字
		 * @param contents 参数，可以无限多个
		 */
		public function sendNotification(message:String, ...contents):void
		{
			this.sendNotificationByArray(message,contents);
		}
		
		/**
		 * 执行Notification， 参数以数组形式传递。
		 * @param message 消息名字
		 * @param contents 参数，可以无限多个
		 */
		public function sendNotificationByArray(message:String,contents:Array):void
		{
			if(!this._notification_manager[message])  // 如果指定 message 没有注册
			{
				return;
			}
			
			var temp_observer:Array = (this._notification_manager[message] as Array).concat();
			
			for each (var obj:Object in temp_observer)
			{
				if(obj is Class)
				{
					var command:Command = new obj() as Command;
					command.execute(contents[0]);
				}
				else if(obj is Function)
				{
					var func:Function = obj as Function;		
					func.apply(null,contents);
				}
				else
				{
					throw new Error('Notification Error! error on type!');
				}
			}
		}
		
		/**
		 * 删除指定观察者
		 * @param message 消息名字
		 */
		public function removeObserver(message:String):void
		{
			this._notification_manager[message]=null;
			delete this._notification_manager[message];
		}
		
		/**
		 * 移除 Callback，监听到message的时候不在处罚callback
		 * @param message 消息名字
		 * @param callback 回调
		 */
		public function removeCallback(message:String,callback:Function):void
		{
			if(this._notification_manager[message])
			{
				var callback_index:int = _notification_manager[message].indexOf(callback);
				if(callback_index>=0)
				{
					this._notification_manager[message].splice(callback_index,1);
					if(this._notification_manager[message].length<=0)
					{
						this._notification_manager[message]=null;
						delete this._notification_manager[message];
					}
				}
			}
		}
		
		/**
		 * 移除 Callback，监听到message的时候不在触发command
		 * @param message 消息名字
		 * @param command 回调命令
		 */
		public function removeCommand(message:String, command:Class):void
		{
			if(this._notification_manager[message])
			{
				var command_index:int = _notification_manager[message].indexOf(command);
				if(command_index>=0)
				{
					this._notification_manager[message].splice(command_index,1);
					if(this._notification_manager[message].length<=0)
					{
						this._notification_manager[message]=null;
						delete this._notification_manager[message];
					}
				}
			}
		}
		
		/**
		 *  调试 检查 Notification
		 * 	指定message时 检查指定message触发的callback数
		 *  否则 显示所有的 Notification
		 * @param message 信息名字
		 */
		public function dump(message:String=null):void
		{
			trace('------------------NotificationObserver Dump---------------------');
			if(message)
			{
				if(this._notification_manager[message])
				{
					trace(message+': has '+this._notification_manager[message].length+' callbacks.');
				}
			}
			else
			{
				for(var j:String in this._notification_manager)
				{
					trace(j+': has '+this._notification_manager[j].length+' callbacks.');
				}
			}
			trace('--------------------------Dump End-----------------------------');
		}
	}
}

internal class SingletonEnforce{}