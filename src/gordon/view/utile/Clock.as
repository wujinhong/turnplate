package com.fanhougame.framework.helper
{
	import com.fanhougame.framework.helper.DateFormatter;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 精确时钟 精确到秒
	 */
	public class Clock
	{
		private static var _instance:Clock;  // 时钟单例
		
		private var _pre_time:int;			// 时钟初始化前的时间
		
		private var _start_time:int;		// 游戏开始时间
		
		private var _clock:Timer;			// 闹钟
		
		private var _clock_time:int;		// 闹钟时间
		
		private var _alarm_list:Object = {};  // 闹钟事件列表
		
		private var _timer_list:Array = [];		// 计时器事件
		
		private var _checker:int=0;				// 时间偏移判断
		
		private var _frequence:int = 0;			// 时间器频率控制
		
		/**
		 * 时钟
		 * @param start_time 初始化的时间
		 * @param singletonEnfoce 单例
		 * @throws Error
		 */
		public function Clock(start_time:int, singletonEnfoce:SingletonEnforce = null)
		{
			if(singletonEnfoce == null)
				throw new Error('Clock Singleton Error');
				
			this._clock_time = this._start_time = start_time;
			
			this._checker = this._pre_time = getTimer();
			
			this._clock = new Timer(500);
			this._clock.addEventListener(TimerEvent.TIMER, _runAlarm);
			this._clock.start();
		}
		
		/**
		 * 初始化时间， 时钟的单例构造函数
		 **/
		public static function initialClock(start_time:int):void
		{
			_instance = new Clock(start_time,new SingletonEnforce());
		}
		
		/**
		 * 获取时钟单例
		 **/
		public static function getInstance():Clock
		{
			if(_instance == null)
				throw new Error('Clock did not initial yet!');
			return _instance;
		}
		
		/**
		 * 析构
		 **/
		public function destroy():void
		{
			this._clock.stop();
			this._clock = null;
			this._alarm_list = {};
		}
		
		/**
		 * 添加闹钟事件
		 * @param time 闹钟结束时间，timestamp 格式， 如果需要实现5秒后则 addAlarm(_clock.current_time+5, testfunction);
		 * @param callback 回调
		 * @param params 参数 可以无数个
		 * @return 
		 */
		public function addAlarm(time:int, callback:Function, ...params):Alarm
		{
			var alarm:Alarm;
			if(this._alarm_list[time])
			{
				alarm = new Alarm('alarm',time,callback,null,params);
				if(this._clock_time == time)  // 正好是当前时间， 则立刻执行。
				{
					alarm.complete_callback.apply(null,params);
					alarm.active = false;
				}
				else
				{
					this._alarm_list[time].push(alarm);
				}
			}
			else
			{
				alarm = new Alarm('alarm',time,callback,null,params);
				
				if(this._clock_time == time)  // 正好是当前时间， 则立刻执行。
				{
					alarm.complete_callback.apply(null,params);
					alarm.active = false;
				}
				else
				{
					this._alarm_list[time] = [];
					this._alarm_list[time].push(alarm);
				}
			}
			return alarm;
		}
		
		/**
		 * 添加计时器，在时间结束以前，每秒执行一次 timer_callback, 
		 * 结束时，执行 complete_callback, complete_callback 
		 * 为空时默认执行timer_callback
		 * 
		 * @param time 时钟结束时间
		 * @param timer_callback 每秒回调
		 * @param complete_callback 完成回调
		 * @return 
		 */
		public function addTimer(time:int, timer_callback:Function, complete_callback:Function=null):Alarm
		{
			var alarm:Alarm = new Alarm('timer',time,timer_callback,complete_callback);
			
			if(this._clock_time == time)
			{
				alarm.complete_callback.apply(null);
				alarm.active = false;
			}
			else
			{
				this._timer_list.push(alarm);
			}
			
			return alarm;
		}
		
		/**
		 * 闹钟运行
		 **/
		private function _runAlarm(event:TimerEvent):void
		{
			this._checker += 500;
			
			var diff:int = getTimer()-this._checker;
			
			if(diff >= 500)  // 时间偏移量纠正, 修正量为0.5秒
			{
				this._checker += 500;
				this._frequence++;
			}
			else if(diff <= -500)
			{
				this._checker -= 500;
				this._frequence--;
			}
			
			this._frequence++;
			
			// 累计2次，也就是 1秒 往下执行一次, 
			if(this._frequence<2)	return;	
			
			this._frequence -= 2;
			this._clock_time++;

			if(this._alarm_list[this._clock_time])		// 闹钟判断
			{
				for each(var alarm:Alarm in this._alarm_list[this._clock_time])
				{
					alarm.active = false;
					alarm.complete_callback.apply(null,alarm.params);
				}
				this._alarm_list[this._clock_time] = null;
				delete this._alarm_list[this._clock_time];
			}
			
			if(this._timer_list.length>0)		// 计时器判断
			{
				var temp_timer_list:Array = this._timer_list.concat();	// 复制一个临时timer列表，以便array 删除操作
				
				for each(var timer:Alarm in temp_timer_list)
				{
					if(timer.time <= this._clock_time)
					{
						timer.active = false;
						timer.complete_callback.apply(null);
						this._timer_list.splice(this._timer_list.indexOf(timer),1);
					}
					else
					{
						timer.callback.apply(null);
					}
				}
			}
		}
		
		/**
		 * 关闭指定Alarm
		 **/
		public function removeAlarm(alarm_handle:Alarm):void
		{
			if(alarm_handle.active)
			{
				if(alarm_handle.type=='alarm')
				{
					var index:int = (this._alarm_list[alarm_handle.time] as Array).indexOf(alarm_handle);
					if(index>=0)
					{
						this._alarm_list[alarm_handle.time].splice(index,1);
						if(this._alarm_list[alarm_handle.time].length<=0)
						{
							this._alarm_list[alarm_handle.time] = null;
							delete this._alarm_list[alarm_handle.time];
						}
					}
				}
				else
				{
					var timer_index:int = (this._timer_list as Array).indexOf(alarm_handle);
					this._timer_list.splice(timer_index,1);
				}
				alarm_handle.active = false;
			}
		}
		
		/**
		 * 为Alarm 重设时间
		 **/
		public function resetAlarm(alarm_handle:Alarm, newTime:int):void
		{
			if(alarm_handle.type=='alarm')
			{
				if(alarm_handle.active && this._alarm_list[alarm_handle.time])  // 如果指定闹钟还在活动，则关闭先前闹钟
				{
					var index:int = (this._alarm_list[alarm_handle.time] as Array).indexOf(alarm_handle);
					this._alarm_list[alarm_handle.time].splice(index,1);
					if(this._alarm_list[alarm_handle.time].length<=0)
					{
						this._alarm_list[alarm_handle.time] = null;
						delete this._alarm_list[alarm_handle.time];
					}
				}
				
				// 加入新闹钟
				if(this._alarm_list[newTime])
				{
					alarm_handle.time = newTime;
					this._alarm_list[newTime].push(alarm_handle);
				}
				else
				{
					this._alarm_list[newTime] = [];
					alarm_handle.time = newTime;
					this._alarm_list[newTime].push(alarm_handle);
				}
			}
			else
			{
				if(alarm_handle.active)
				{
					alarm_handle.time = newTime;
				}
				else
				{
					alarm_handle.time = newTime;
					this._timer_list.push(alarm_handle);
				}
			}
		}
		
//--------------------------------------------------------------------------		
		/**
		 * 获取开始时间
		 **/
		public function get start_time():int
		{
			return this._start_time;
		}
		
		/**
		 * 获取当前时间
		 **/
		public function get current_time():int
		{
			if(this._clock_time)
			{
				return this._clock_time;
			}
			else
			{
				return this._start_time+Math.floor((getTimer() - this._pre_time)*0.001);
			}
		}
		
		/**
		 * 转化timestamp成日期字符
		 * @param timeStamp
		 * @param formatString
		 * @return 
		 */
		public static function TimeStampToDateString(timeStamp:int,formatString:String="jj:nn (mm/dd/yy)"):String
		{
			var aDate:Date=new Date(timeStamp*1000);
			return DateFormatter.formatTo(aDate,formatString);
		}
		
		/**
		 * 转换时间
		 * @param total_sec 总秒数
		 * @param need_sec 精确到秒吗？
		 * @param shot_mode 短格式
		 * @return 
		 */
		public static function convert(total_sec:int,need_sec:Boolean=true,shot_mode:Boolean=false):String
		{

			var str:String='';
			var day:int;
			var day_:String = '';
			var hour:int;
			var hour_:String ='';
			var min:int;
			var min_:String = '';
			var sec:int;
			var sec_:String = ''
			// 一天 。。。
			if (total_sec>86400)
			{
				day = Math.floor(total_sec / 86400);
				total_sec = total_sec%86400;				 
				str+=day+day_;
				if(shot_mode)
				{
					return str + '';
				}
			}
			//一小时。。
			if (total_sec>3600)
			{
				hour = Math.floor(total_sec / 3600);
				total_sec = total_sec%3600;		
				str+=hour+hour_	;
				if (shot_mode)
				{
					return str + '';
				}
			}
			//一分钟。。
			if (total_sec>60)
			{
				min = Math.floor(total_sec / 60);
				total_sec = total_sec%60;
				if (shot_mode)
				{
					return str+=min+'' + '';
				}
				str+=min + min_;
				
			}
			else
			{
				if (shot_mode)
				{
					return '';
				}
			}
			//一份中内...	
			if (total_sec>0)
			{
				if (need_sec)
				{
					str+=total_sec + sec_;
				}
				if(str =='')
				{
					str+=total_sec + sec_;
				}
				if (shot_mode)
				{
					return str;
				}
			}
			
			return str;
		}
	}
}

internal class SingletonEnforce{}