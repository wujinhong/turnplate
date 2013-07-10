package gordon.core
{
	import gordon.core.interfaces.INotifier;
	
	/**
	 * 通知者，框架核心。 所有继承Notifier 的类都可以发送和接受信息。 信息驱动的基础
	 */
	public class Notifier implements INotifier
	{
		/**
		 * 信息管理器
		 */
		protected var _notification_manager:NoteObserver = NoteObserver.getInstance();
		
		/**
		 * 消息记录器
		 */
		protected var _notification_record:Object = {};  // 用于记录当前对象所注册的 callback notification. 以便清除
		
		/**
		 * 命令记录器
		 */
		protected var _command_record:Object = {};  // 用于记录当前对象所注册的 callback notification. 以便清除
		
		/**
		 * 显示调试信息
		 */
		protected var _debug:Boolean=true;
		
		/**
		 * 注册回调函数
		 * @param message
		 * @param callback
		 */
		public function registerCallback(message:String,callback:Function):void
		{
			if (hasRegisterCallback(message))
			{
				throw new Error('回调函数已被同名的message "'+message+' "注册过');
				return ;
			}
			_notification_manager.registerCallback(message,callback);
			this._notification_record[message] = callback;
		}
		
		/**
		 * 是否有callback
		 * @param message 消息名字
		 * @return 有或者没有
		 **/
		public function hasRegisterCallback(message:String):Boolean
		{
			return _notification_record[message] != null;
		}
		/**
		 * 注册命令
		 * @param message 消息名字
		 * @param command 命令类
		 */
		public function registerCommand(message:String,command:Class):void
		{
			_notification_manager.registerCommand(message,command);
			this._notification_record[message] = command;
		}
		
		/**
		 * 发送通知
		 * @param message 消息名字
		 * @param contents 参数
		 */
		public function sendNotification(message:String, ...contents):void
		{
			_notification_manager.sendNotificationByArray(message,contents);
		}
		
		
		/**
		 * 移除指定观察者
		 * @param message
		 */
		public function removeObserver(message:String):void
		{
			this._notification_record[message]=null;
			delete this._notification_record[message];
			_notification_manager.removeObserver(message);
		}
		
		
		/**
		 * 移除回调函数
		 * @param message
		 * @param callback
		 */
		public function removeCallback(message:String, callback:Function):void
		{
			this._notification_record[message]=null;
			delete this._notification_record[message];
			_notification_manager.removeCallback(message,callback);
		}
		
		/**
		 * 清除当前对象所有的callback notification
		 */
		public function cleanAllCallback():void 
		{
			for(var i:String in this._notification_record)
			{
				if(this._notification_record[i] is Function)
					_notification_manager.removeCallback(i,this._notification_record[i]);
				else if(this._notification_record[i] is Class)
					_notification_manager.removeCommand(i,this._notification_record[i]);
			}
			this._notification_record=null;
		}
		
		/**
		 * 移除命令
		 * @param message
		 * @param command
		 */
		public function removeCommand(message:String, command:Class):void
		{
			this._notification_record[message]=null;
			delete this._notification_record[message];
			_notification_manager.removeCommand(message,command);
		}
		
		/**
		 * @param obj
		 */
		public function printf(obj:Object):void
		{
			if (this._debug)
			{
				trace(obj);
			}
		}
	}
}