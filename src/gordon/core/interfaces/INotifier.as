package gordon.core.interfaces
{
	public interface INotifier
	{
		/**
		 * 注册回调函数
		 **/
		function registerCallback(message:String, callback:Function):void;
		
		/**
		 * 注册命令
		 **/
		function registerCommand(message:String, command:Class):void;
		
		/**
		 * 发送通知
		 **/
		function sendNotification(message:String, ...contents):void;
		
		/**
		 *  移除指定观察者
		 **/
		function removeObserver(message:String):void;
		
		/**
		 *  移除 Callback
		 **/
		function removeCallback(message:String,callback:Function):void;
		
		/**
		 * 清除当前对象所有的callback notification
		 **/
		function cleanAllCallback():void;
		
		/**
		 *  移除 Command
		 **/
		function removeCommand(message:String, command:Class):void;
	}
}