package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	
	import btn.Add;
	import btn.ObliqueText;
	import btn.kill;
	
	public class Main extends Sprite
	{
		private var _tp:MovieClip;
		private var _list:Vector.<String>;
		private var _turnplateCtrl:TurnplateCtrl;
		private var _btn:kill;
		private var _add:Add;
		private var _oblique:ObliqueText;
		private var tf:TextField;
		
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
			addChild( _tp );
			stopAllChildren( _tp );
			_turnplateCtrl = new TurnplateCtrl( _tp, _list, fire, show );
			
			_tp.x = 100;
			
			initBtns();
			
			obliqueText();
			
			clickTextField();
		}
		
		private function clickTextField():void
		{
			tf = new TextField()
			tf.htmlText = "<font color='#FF0000'><a href='event:hello'>xxx</a>位图字体htmlText无效</font>";
			tf.addEventListener( TextEvent.LINK, onTextClick );
			addChild( tf );
		}
		
		protected function onTextClick( e:TextEvent):void
		{
			trace( e, "kkkkkkkkkkkkkkkkkkkkk" );
		}
		/**
		 *最好的循环方式 
		 */		
		private function bestLoop():void
		{
			var l:uint = _list.length;
			while ( --l > 0 )
			{
				
			}
		}
		private function obliqueText():void
		{
			_oblique = new ObliqueText();
			addChild( _oblique );
			_oblique.x = 400;
			_oblique.y = 275;
			_oblique.tf.htmlText = "<font color='#FF0000'>位图字体htmlText无效</font>";
			
			_oblique.tf.filters = [];
			
			_oblique.tf.embedFonts = true;
			_oblique.tf.antiAliasType = AntiAliasType.ADVANCED;
			_oblique.tf.gridFitType = GridFitType.PIXEL;
			_oblique.tf.thickness = 200;
			
			_oblique.tf.text = "位图字体";
		}
		private function initBtns():void
		{
			_btn = new kill();
			addChild( _btn );
			_btn.x = 350;
			_btn.y = 175;
			_btn.addEventListener( MouseEvent.CLICK, run );
			_btn.buttonMode = true;
			_btn.stop();
			
			_add = new Add();
			addChild( _add );
			_add.x = 400;
			_add.y = 175;
			_add.addEventListener( MouseEvent.CLICK, add );
			_add.buttonMode = true;
			_add.stop();
		}
		
		protected function add(e:MouseEvent):void
		{
			_turnplateCtrl.add( "太盛" );
			_turnplateCtrl.start();
		}
		protected function run(e:MouseEvent):void
		{
			_turnplateCtrl.start();
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