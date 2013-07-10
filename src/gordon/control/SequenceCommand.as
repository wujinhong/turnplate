package gordon.control
{
	import gordon.core.Notifier;

	/**
	 * 序列命令
	 * @author 
	 */
	public class SequenceCommand extends Notifier
	{
		/**
		 * 
		 * @default 
		 */
		protected var _command_seq:Array=[];
		
		private var _seq_name:String = 'sequence_command';
		
		/**
		 * 顺序命令，一个接一个的执行
		 * @param seq_name
		 */
		public function SequenceCommand(seq_name:String = null)
		{
			if(seq_name != null)
			{
				_seq_name = seq_name;
			}
			this.registerCallback(_seq_name,execute);
		}
		 
		/**
		 * 在COMMAND队列后增加一个COMMAND
		 * @param command Class 
		 */
		public function addCommand(command:Class):void
		{
			this._command_seq.push(command);
		}
		
		/**
		 * 获取下一个Command
		 * @return Command
		 */
		private function getNextCommand():Command
		{
			if(_command_seq.length>0)
			{
				var command:Class = _command_seq.shift() as Class;
				return new command();
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 执行 Command
		 */
		public function execute():void
		{
			var command:Command = this.getNextCommand();
			if(command!=null)
			{
				command.execute();
			}
			else
			{
				this.removeObserver(this._seq_name);
				this.end();
			}
		}
		
		/**
		 * 结束
		 */
		protected function end():void
		{
		}
	}
}