package gordon.control.interfaces
{
	/**
	 * 
	 */
	public interface ICommand
	{
		/**
		 * 命令执行
		 * @param params
		 */
		function execute(params:Object = null):void;
	}
}