package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.utils.getTimer;
	
	public class TurnplateCtrl
	{
		public var mc:MovieClip;
		/**中间大扇形对应的字符串位置，从0开始，转动时动态 +1 或者 —1 变化**/
		private var idx:int = 0;
		/**转盘指针，从0开始**/
		private var _p:int = 0;
		/**玩家最高第几战，从1开始**/
		private var _top:int = 0;
		/**每次旋转，扇形旋转次数，从1开始**/
		private var time:int = 0;
		private var _list:Vector.<String>;
		private var leng:uint;
		private var _lastBtn:MovieClip;
		/**单击挑战按钮执行的方法，此方法要有一个int参数**/
		private var _func:Function;
		/** 转盘停止时执行的方法，此方法要有一个int参数**/
		private var _show:Function;
		/** 转盘停止时执行的方法**/
		private var _hide:Function;
		private var _point:Point;
		private var _passGeneral:Vector.<Boolean>;
		/** 蓝色：代表已经击杀过的怪物 **/
		private var _killedColor:uint;
		/** 红：代表现在不可以挑战的怪物；绿：代表现在可以挑战的最高层怪物；蓝：代表已经击杀过的怪物。 0xFF0000, 0x00FF00, 0x0000FF **/
		private var _colors:Vector.<uint>;
		/**怪物上限**/
		private var _openUpperGeneral:uint = 100;
		/**
		 * @param tp
		 * 	转盘swf
		 * @param list
		 *  转盘内的名字
		 * @param func
		 * 	挑战按钮执行方法
		 * @param show
		 *  转盘停止时执行的方法
		 * @param hide
		 *  挑战按钮特效隐藏的方法
		 */
		public function TurnplateCtrl( tp:MovieClip, list:Vector.<String>, pass:Vector.<Boolean>,
									   colors:Vector.<uint>, func:Function, show:Function, hide:Function )
		{
			mc = tp;
			_list = list;
			_passGeneral = pass;
			_colors = colors;
			_func = func;
			_show = show;
			_hide = hide;
			_point = new Point(0, 0);
			init();
			renew();
		}
		private function init():void
		{
			setColor();
			
			leng = _list.length;
			_top = leng - 2;
			
			if ( _passGeneral.length == _openUpperGeneral && _passGeneral[ _openUpperGeneral - 2 ] == false )//正在挑战倒数第二层的战将时
			{
				addGeneralName( " ", false );
			}
			else if ( _passGeneral.length == _openUpperGeneral && _passGeneral[ _openUpperGeneral - 2 ] == true )//倒数第二层的战将已挑战通过时
			{
				addGeneralName( " ", false );
				addGeneralName( " ", false );
			}
			
			setIndex();
			
			mc.addFrameScript( 9, down, mc.totalFrames - 1, up );
			
			initBtn();
			mouseEnabled();
		}
		/**
		 * 注释 修改 转盘原字体颜色
		 * @author 吴金鸿 Jul 17, 2013
		 */
		public function setColor():void
		{
			_killedColor = _colors[ 2 ];
			mc.btns.btn.tf.filters = [];
			mc.btns.btn.tf.antiAliasType = AntiAliasType.ADVANCED;
			mc.btns.btn.tf.thickness = 200;
			
			var i:int = 0;
			
			while ( i < 6 )//上面按钮层 
			{
				mc.btns[ "btn" + i ].tf.filters = [];
				mc.btns[ "btn" + i ].tf.cacheAsBitmap = true;
				mc.btns[ "btn" + i ].tf.antiAliasType = AntiAliasType.ADVANCED;
				mc.btns[ "btn" + i ].tf.thickness = 200;
				mc.btns[ "btn" + i ].tf.textColor = _colors[ 2 ];
				i++;
			}
			mc.btns.btn0.tf.textColor = _colors[ 1 ];//返回按钮
			
			i = 0;
			while ( i < 10 )//底部动画层
			{
				mc.circle[ "mc" + i ].tf.filters = [];
				mc.circle[ "mc" + i ].tf.antiAliasType = AntiAliasType.ADVANCED;
				mc.circle[ "mc" + i ].tf.thickness = 200;
				mc.circle[ "mc" + i ].tf.textColor = _colors[ 2 ];
				i++;
			}
			
			//三个大扇形的文本
			i = 0;
			while ( i < 3 )
			{
				mc.frame[ "angle" + i ].tf.filters = [];
				mc.frame[ "angle" + i ].tf.cacheAsBitmap = true;
				mc.frame[ "angle" + i ].tf.antiAliasType = AntiAliasType.ADVANCED;
				mc.frame[ "angle" + i ].tf.thickness = 200;
				mc.frame[ "angle" + i ].tf.textColor = _colors[ 2 ];
				i++;
			}
		}
		private function setIndex():void
		{
			if ( _top > 7 ) 
			{
				idx = _p = _top - 7;
			}
			else
			{
				idx = _p = 0;
			}
		}
		/**
		 *旋转当前最高七个转盘
		 */
		public function renew():void
		{
			setIndex();
			initTF();
			start( _top - 1 );
			if ( _top == 1 )
			{
				_show( idx + 1 );
			}
		}
		/**
		 * 正向转动，默认从0开始，转至 i
		 *  @param i 停止位置
		 */		
		private function start( i:int = 0 ):void
		{
			if ( head( i ) )
			{
				setup( i );
				mc.play();
			}
		}
		/**
		 *反向转动，从0开始
		 * @param i 停止位置
		 */	
		private function end( i:int ):void
		{
			if ( back( i ) )
			{
				setup( i );
				mc.gotoAndPlay( 11 );
			}
		}
		/**
		 * 判断能否正向转动
		 * @param i
		 * @return 
		 */		
		private function head(i:int):Boolean
		{
			if ( i < _top && i > _p )
			{
				trace( _top );
				time = i - _p;
				return true;
			}
			return false;
		}
		/**
		 * 判断能否正向转动
		 * @param i
		 * @return
		 */		
		private function back(i:int):Boolean
		{
			if ( i >= 0 && _p > i )
			{
				time = _p - i;
				return true;
			}
			return false;
		}
		private function setup(i:int):void
		{
			_p = i;
			initAnimateTF();
			mc.btns.visible = false;
			initTF();
			mouseEnabled();
			_hide();
		}
		/**
		 *击杀新怪物，更新“杀”字的状态
		 */		
		public function updateKill(i:int):void
		{
			if ( i < _top )
			{
				_passGeneral[ i ] = true;
			}
			if ( i == idx && !mc.isPlaying )
			{
				mc.btns.btn.kill.visible = true;
			}
		}
		/**
		 *添加名字
		 */
		public function addGeneralName( s:String, b:Boolean ):void
		{
			_list.push( s );
			_passGeneral.push( b );
			leng++;
			_top++;
			
			if ( _top > _openUpperGeneral )
			{
				_top =  _openUpperGeneral;
			}
		}
		public function firstBtn(s:String):void
		{
			mc.btns.btn0.tf.text = s + _top;
		}
		/**
		 *单击按钮面板的六个可单击状态
		 */
		private function mouseEnabled():void
		{
			if ( _p + 2 >= _top )
			{
				mc.btns.btn1.mouseEnabled = false;
				mc.btns.btn1.gotoAndStop( 1 );
			}
			else
			{
				mc.btns.btn1.mouseEnabled = true;
				mc.btns.btn1.gotoAndStop( 2 );
			}
			if ( _p + 1 >= _top )
			{
				mc.btns.btn2.mouseEnabled = false;
				mc.btns.btn2.gotoAndStop( 1 );
			}
			else
			{
				mc.btns.btn2.mouseEnabled = true;
				mc.btns.btn2.gotoAndStop( 2 );
			}
			if ( _p <= 0 ) 
			{
				mc.btns.btn3.mouseEnabled = false;
				mc.btns.btn3.gotoAndStop( 1 );
			}
			else
			{
				mc.btns.btn3.mouseEnabled = true;
				mc.btns.btn3.gotoAndStop( 2 );
			}
			
			if ( _p <= 1)
			{
				mc.btns.btn4.mouseEnabled =  false;
				mc.btns.btn4.gotoAndStop( 1 );
			}
			else
			{
				mc.btns.btn4.mouseEnabled = true;
				mc.btns.btn4.gotoAndStop( 2 );
			}
			
			if ( _p <= 2)
			{
				mc.btns.btn5.mouseEnabled =  false;
				mc.btns.btn5.gotoAndStop( 1 );
			}
			else
			{
				mc.btns.btn5.mouseEnabled = true;
				mc.btns.btn5.gotoAndStop( 2 );
			}
		}
		private function run(e:MouseEvent):void
		{
			if ( _lastBtn == null )
			{
				return;
			}
			
			switch( _lastBtn.name )
			{
				case "btn0":
				{
					start( _top - 1 );
					break;
				}
				case "btn1":
				{
					start( _p + 2 );
					break;
				}
				case "btn2":
				{
					start( _p + 1 );
					break;
				}
				case "btn3":
				{
					end( _p - 1 );
					break;
				}
				case "btn4":
				{
					end( _p - 2 );
					break;
				}
				case "btn5":
				{
					end( _p - 3 );
					break;
				}
			}
		}
		
		/**
		 * 发光状态
		 * @param mc
		 */		
		private function state(mc:MovieClip):void
		{
			switch( mc.name )
			{
				case "btn0":
				{
					mc.gotoAndStop( 3 );
					break;
				}
				case "btn1":
				{
					if ( _p + 2 < _top )
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn2":
				{
					if ( _p + 1 < _top )
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn3":
				{
					if ( _p > 0 ) 
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn4":
				{
					if ( _p > 1)
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn5":
				{
					if ( _p > 2)
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
			}
		}
		/**
		 * 还原原来按钮状态
		 * @param mc
		 */		
		private function state2(mc:MovieClip):void
		{
			switch( mc.name )
			{
				case "btn0":
				{
					mc.gotoAndStop( 2 );
					break;
				}
				case "btn1":
				{
					if ( _p + 2 < _top )
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn2":
				{
					if ( _p + 1 < _top )
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn3":
				{
					if ( _p > 0 ) 
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn4":
				{
					if ( _p > 1)
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn5":
				{
					if ( _p > 2)
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
			}
		}
		/**
		 *单击按钮面板的六个文本，以及一个大扇形的文本
		 */
		private function initTF():void
		{
			var rank:String = "";
			
			if ( ( _p + 3 == _openUpperGeneral && _passGeneral[ _p + 2 ] ) || _p + 3 == _top  )//第二个扇形
			{
				mc.btns.btn1.tf.textColor = _colors[1];
			}
			else if ( _p + 2 >= _top )
			{
				mc.btns.btn1.tf.textColor = _colors[0];
			}
			else
			{
				mc.btns.btn1.tf.textColor = _killedColor;
			}
			if ( _p == _openUpperGeneral - 2 || _p == _openUpperGeneral - 1 )
			{
				rank = "";
			}
			else
			{
				rank = String(_p + 3);
			}
			mc.btns.btn1.tf.text = _list[ _p + 2 ] + "\n" + rank;
			
			if ( _p == _openUpperGeneral - 1 )//第三个扇形
			{
				rank = "";
			}
			else
			{
				rank = String(_p + 2);
			}
			mc.btns.btn2.tf.text = _list[ _p + 1 ] + "\n" + rank;
			if ( ( _p + 2 == _openUpperGeneral && _passGeneral[ _p + 1 ] ) || _p + 2 == _top )
			{
				mc.btns.btn2.tf.textColor = _colors[1];
			}
			else if ( _p + 1 >= _top )
			{
				mc.btns.btn2.tf.textColor = _colors[0];
			}
			else
			{
				mc.btns.btn2.tf.textColor = _killedColor;
			}
			
			//大扇形的文本
			mc.btns.btn.tf.text = _list[ _p ] + "\n" + (_p + 1);
			if ( _p + 1 == _top )
			{
				mc.btns.btn.tf.textColor = _colors[1];
			}
			else
			{
				mc.btns.btn.tf.textColor = _colors[2];
			}
			
			//大扇形的杀字是否显示
			mc.btns.btn.kill.visible = _passGeneral[ _p ];
			
			if ( _p <= 0)
			{
				mc.btns.btn3.tf.text = "";
			}
			else
			{
				mc.btns.btn3.tf.text = _list[ _p - 1 ] + "\n" + ( _p + 0 );
			}
			
			if ( _p <= 1)
			{
				mc.btns.btn4.tf.text = "";
			}
			else
			{
				mc.btns.btn4.tf.text = _list[ _p - 2 ] + "\n" + ( _p - 1 );
			}
			
			if ( _p <= 2)
			{
				mc.btns.btn5.tf.text = "";
			}
			else
			{
				mc.btns.btn5.tf.text = _list[ _p - 3 ] + "\n" + ( _p - 2 );
			}
		}
		/**
		 * 底部动画10个文本，以及三个大扇形的文本
		 */
		private function initAnimateTF():void
		{
			if ( idx + 4 >= leng || idx + 5 > _openUpperGeneral )//第一个扇形
			{
				mc.circle.mc0.tf.text = "";
			}
			else
			{
				mc.circle.mc0.tf.text = _list[ idx + 4 ] + "\n" + ( idx + 5);
			}
			if ( idx + 5 > _top )
			{
				mc.circle.mc0.tf.textColor = _colors[0];
			}
			else if ( idx + 5 == _top )
			{
				mc.circle.mc0.tf.textColor = _colors[1];
			}
			else
			{
				mc.circle.mc0.tf.textColor = _killedColor;
			}
			
			if ( idx + 3 >= leng || idx + 4 > _openUpperGeneral )//第二个扇形
			{
				mc.circle.mc1.tf.text = "";
			}
			else
			{
				mc.circle.mc1.tf.text = _list[ idx + 3 ] + "\n" + ( idx + 4);
			}
			if ( idx + 4 > _top )
			{
				mc.circle.mc1.tf.textColor = _colors[0];
			}
			else if ( idx + 4 == _top )
			{
				mc.circle.mc1.tf.textColor = _colors[1];
			}
			else
			{
				mc.circle.mc1.tf.textColor = _killedColor;
			}
			
			if ( idx + 2 >= leng || idx + 3 > _openUpperGeneral )//第三个扇形
			{
				mc.circle.mc2.tf.text = "";
			}
			else
			{
				mc.circle.mc2.tf.text = _list[ idx + 2 ] + "\n" + ( idx + 3);
			}
			if ( idx + 3 > _top )
			{
				mc.circle.mc2.tf.textColor = _colors[0];
			}
			else if ( idx + 3 == _top )
			{
				mc.circle.mc2.tf.textColor = _colors[1];
			}
			else
			{
				mc.circle.mc2.tf.textColor = _killedColor;
			}
			
			if ( idx + 1 >= leng || idx + 2 > _openUpperGeneral )//第四个扇形
			{
				mc.circle.mc3.tf.text = "";
			}
			else
			{
				mc.circle.mc3.tf.text = _list[ idx + 1 ] + "\n" + ( idx + 2);
			}
			if ( idx + 2 > _top )
			{
				mc.circle.mc3.tf.textColor = _colors[0];
			}
			else if ( idx + 2 == _top )
			{
				mc.circle.mc3.tf.textColor = _colors[1];
			}
			else
			{
				mc.circle.mc3.tf.textColor = _killedColor;
			}
			
			mc.circle.mc4.tf.text = _list[ idx ] + "\n" + ( idx + 1);//第五个扇形
			mc.circle.mc5.tf.text = _list[ idx ] + "\n" + ( idx + 1);//第六个扇形
			if ( idx + 1  == _top )
			{
				mc.circle.mc4.tf.textColor = _colors[1];
				mc.circle.mc5.tf.textColor = _colors[1];
			}
			else
			{
				mc.circle.mc4.tf.textColor = _killedColor;
				mc.circle.mc5.tf.textColor = _killedColor;
			}
			
			
			if ( idx + 2 == _top )//第一个大扇形
			{
				mc.frame.angle0.tf.textColor =  _colors[1];
			}
			else
			{
				mc.frame.angle0.tf.textColor = _killedColor;
			}
			mc.frame.angle0.tf.text = _list[ idx + 1 ] + "\n" + (idx + 2);
			mc.frame.angle1.tf.text = _list[ idx ] + "\n" + (idx + 1);//第二个大扇形
			if ( idx <= 0 )//第三个大扇形
			{
				mc.frame.angle2.tf.text = "";
			}
			else
			{
				mc.frame.angle2.tf.text = _list[ idx - 1 ] + "\n" + (idx - 0);
			}
			
			
			if ( idx <= 0 )
			{
				mc.circle.mc6.tf.text = "";
			}
			else
			{
				mc.circle.mc6.tf.text = _list[ idx - 1 ] + "\n" + (idx + 0);
			}
			if ( idx <= 1 )
			{
				mc.circle.mc7.tf.text = "";
			}
			else
			{
				mc.circle.mc7.tf.text = _list[ idx - 2 ] + "\n" + (idx - 1);
			}
			
			if ( idx <= 2 )
			{
				mc.circle.mc8.tf.text = "";
			}
			else
			{
				mc.circle.mc8.tf.text = _list[ idx - 3 ] + "\n" + (idx - 2);
			}
			
			if ( idx <= 3 )
			{
				mc.circle.mc9.tf.text = "";
			}
			else
			{
				mc.circle.mc9.tf.text = _list[ idx - 4 ] + "\n" + (idx - 3);
			}
		}
		/**
		 *按钮事件侦听
		 *及MovieClip全stop 
		 *及鼠标事件状态
		 */	
		private function initBtn():void
		{
			mc.stop();
			mc.btns.btn.btn.addEventListener( MouseEvent.CLICK, fire );
			var l:uint = 6;
			while( --l >= 0 )
			{
				mc.btns["btn" + l].buttonMode = true;
				mc.btns["btn" + l].mouseChildren = false;
			}
			mc.btns.btn0.gotoAndStop( 2 );
			mc.btns.addEventListener( MouseEvent.CLICK, run );
			
			mc.btns.addEventListener (MouseEvent.MOUSE_OVER, onOver1 );
			mc.btns.addEventListener (MouseEvent.MOUSE_OUT, onOut1 );
		}
		private function onOut1(evt:MouseEvent):void
		{
			mc.btns.removeEventListener(MouseEvent.MOUSE_MOVE, onMove );
			_lastBtn = null;
		}
		private function onOver1(evt:MouseEvent):void
		{
			mc.btns.addEventListener (MouseEvent.MOUSE_MOVE, onMove );
		}
		/**
		 * 像素碰撞检测
		 * @param e
		 */		
		private function onMove(e:MouseEvent):void
		{
			var btn:MovieClip = null;
			var i:uint = 0;
			while ( i < 6 )
			{
				var mcBtn:MovieClip = mc.btns["btn" + i++];
				var bmp:Bitmap = MovieClip(mcBtn.getChildAt( 0 )).getChildAt( 0 ) as Bitmap;
				//此按钮的Bitmap.bitmapData是否的碰撞检测 到当前鼠标位置
				if (bmp.bitmapData.hitTest( _point, 0xFF, new Point(mcBtn.mouseX, mcBtn.mouseY)))
				{
					btn = mcBtn;
				}
			}
			//未碰撞检测 到按钮，说明已离开之前按钮，原来之前按钮正常状态
			if ( btn == null )
			{
				if ( _lastBtn )
				{
					state2( _lastBtn );
				}
				_lastBtn = btn;//未碰撞检测 到按钮,_lastBtn置null
			}
			else if (btn != _lastBtn)
			{
				if ( _lastBtn )
				{
					state2( _lastBtn );
				}
				state( btn );
				_lastBtn = btn;
			}
		}
		
		private function fire(e:MouseEvent):void
		{
			_func( idx + 1 );
		}
		/**玩家最高第几战，从1开始**/
		public function get top():int
		{
			return _top;
		}
		protected function destroyTurn(e:Event):void
		{
			mc.addFrameScript( 9, null, mc.totalFrames - 1, null );
			
			mc.btns.btn.btn.removeEventListener( MouseEvent.CLICK, fire );
			mc.btns.removeEventListener( MouseEvent.CLICK, run );
			
		}
		
		private function down():void
		{
			idx++;
			if ( --time > 0)
			{
				mc.gotoAndPlay( 1 );
				initAnimateTF();
			}
			else
			{
				recover();
			}
		}
		
		private function up():void
		{
			idx--;
			if ( --time > 0)
			{
				mc.gotoAndPlay( 11 );
				initAnimateTF();
			}
			else
			{
				recover();
			}
		}
		private function recover():void
		{
			mc.btns.visible = true;
			mc.gotoAndStop( 1 );
			onMove( null );
			_show( idx + 1 );
			
			trace( "TurnplateCtrl.recover()", getTimer() );
			
		}
	}
}