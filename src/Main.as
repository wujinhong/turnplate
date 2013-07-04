package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		private var _tp:MovieClip;
		private var _list:Vector.<String>;
		private var _turnplateCtrl:TurnplateCtrl;
		public function Main()
		{
			_tp = new turnplate();
			_list = new Vector.<String>();
			_list.push( "1糜马","2吕孟","3廖刘" );
			
			_list.push( "4黄严", "5张徐","6袁孙","7陆曹","8周钟","9邓蒋","10杨司","11郭董","12颜文" );
//			_list.push( "13纪侯","14华高","15公关","16陶田","17沮貂","18庞祝杜","19诸兀郝","20王典朱","21韩潘" );
//			_list.push( "22淩夏","23阚鲁","24姜魏","许祢太","26程甘赵","27芳岱","蒙达化","29封权","30良谡","31苞晃","绍术策","33逊植仓" );
//			_list.push( "34丕会","35艾干","36修嘉","37尚卓","38盖备","39丑灵","40成雄","41顺兴" );
//			_list.push( "42平索","43表谦","44丰授","45禅角","46梁宝","47统操","48获融","49绩昭","50瑜预","51仁真","52谌葛","53突忠","双允韦","55承然","56当钦","57璋坚" );
//			_list.push( "58泽肃","59维延","60褚衡","61郃朗","62辽史","63普盛","64宁泰","65超云","66飞羽","67布懿香","68瓒师炎","69瞻骨","70亮渊","71敦慈" );
			
			_turnplateCtrl = new TurnplateCtrl( _tp, _list, fire, show );
			addChild( _tp );
			_tp.x = 100;
		}
		private function fire(idx:int):void
		{
			trace( "单击挑战按钮了！", idx );
		}
		private function show(idx:int):void
		{
			trace( "转盘停止了，显示怪物！", idx );
		}
	}
}