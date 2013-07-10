package com.fanhougame.framework.helper
{
	public class Alarm
	{
		private var _type:String;
		
		private var _time:int;
		
		private var _callback:Function;
		
		private var _complete_callback:Function;
		
		private var _params:Array=[];
		
		private var _active:Boolean = false;
		
		private var _clock:Clock = Clock.getInstance();
		
		/**
		 *  初始化闹钟，交由CLOCK来建立。
		 * @param type
		 * @param time
		 * @param callback
		 * @param complete_callback
		 * @param params
		 */
		public function Alarm(type:String, time:int, callback:Function, complete_callback:Function=null, params:Array=null)
		{
			this._type = type;
			this._time = time;
			this._callback = callback;
			this._complete_callback = complete_callback == null? callback : complete_callback;
			this._params = params;
			this._active = true;
		}

		/**
		 * 闹钟停止
		 **/
		public function stop():void
		{
			if(this._active)
			{
				this._clock.removeAlarm(this);
				this._active = false;
			}
		}
		
		/**
		 * 重设闹钟时间
		 **/
		public function resetTime(time:int):void
		{
			this._clock.resetAlarm(this,time);
			this.active = true;
		}
		
		
		/**
		 * 
		 * @param value
		 */
		public function set active(value:Boolean):void
		{
			this._active = value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get active():Boolean
		{
			return this._active;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get type():String
		{
			return this._type;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set time(value:int):void
		{
			this._time = value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get time():int
		{
			return this._time;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get callback():Function
		{
			return this._callback;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get complete_callback():Function
		{
			return this._complete_callback;
		}

		/**
		 * 
		 * @return 
		 */
		public function get params():Array
		{
			return this._params;
		}
	}
}