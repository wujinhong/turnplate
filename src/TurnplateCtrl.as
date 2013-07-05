package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TurnplateCtrl
	{
		private var _tp:MovieClip;
		/**中间大扇形对应的字符串位置，从0开始，转动时动态 +1 或者 —1 变化**/
		private var idx:int = 0;
		/**转盘指针，从0开始**/
		private var _p:int = 0;
		/**玩家最高第几战，从1开始**/
		private var top:uint = 0;
		/**每次旋转，扇形旋转次数，从1开始**/
		private var time:uint = 0;
		private var _list:Vector.<String>;
		private var leng:uint;
		private var _lastBtn:MovieClip;
		/**单击挑战按钮执行的方法，此方法要有一个int参数**/
		private var _func:Function;
		/** 转盘停止时执行的方法，此方法要有一个int参数**/
		private var _show:Function;
		private var _point:Point;
		private var _color:uint;
		private var _colors:Vector.<uint>;
		/**
		 * @param tp
		 * 	转盘swf
		 * @param list
		 *  转盘内的名字
		 * @param func
		 * 	挑战按钮执行方法
		 * @param show
		 *  转盘停止时执行的方法
		 */		
		public function TurnplateCtrl( tp:MovieClip, list:Vector.<String>, func:Function, show:Function )
		{
			_tp = tp;
			_list = list;
			_func = func;
			_show = show;
			_point = new Point(0, 0);
			
			_colors = new Vector.<uint>();
			_colors.push( 0xFF0000,0x00FF00,0x0000FF );
			_colors.fixed = true;
			
			init();
			start( 5 );
		}
		/**
		 *添加 名字
		 */
		public function add( s:String ):void
		{
			_list.push( s );
			leng++;
			top++;
		}
		private function init():void
		{
			_color = _tp.btns.btn.tf.textColor;
			_tp.btns.btn.tf.filters = [];
			_tp.btns.btn.tf.antiAliasType = AntiAliasType.ADVANCED;
			_tp.btns.btn.tf.thickness = 200;
			
			leng = _list.length;
			top = leng - 2;
			
			idx = _p = 0;
			
			_tp.addFrameScript( 9, down, _tp.totalFrames - 1, up );
			
			firstBtn();
			initBtn();
			mouseEnabled();
			initTF();
		}
		private function firstBtn():void
		{
			_tp.btns.btn0.tf.text = "返回\n第" + top + "战";
		}
		/**
		 *单击按钮面板的六个可单击状态
		 */
		private function mouseEnabled():void
		{
			if ( _p + 2 >= top )
			{
				_tp.btns.btn1.mouseEnabled = false;
				_tp.btns.btn1.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn1.mouseEnabled = true;
				_tp.btns.btn1.gotoAndStop( 2 );
			}
			if ( _p + 1 >= top )
			{
				_tp.btns.btn2.mouseEnabled = false;
				_tp.btns.btn2.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn2.mouseEnabled = true;
				_tp.btns.btn2.gotoAndStop( 2 );
			}
			if ( _p <= 0 ) 
			{
				_tp.btns.btn3.mouseEnabled = false;
				_tp.btns.btn3.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn3.mouseEnabled = true;
				_tp.btns.btn3.gotoAndStop( 2 );
			}
			
			if ( _p <= 1)
			{
				_tp.btns.btn4.mouseEnabled =  false;
				_tp.btns.btn4.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn4.mouseEnabled = true;
				_tp.btns.btn4.gotoAndStop( 2 );
			}
			
			if ( _p <= 2)
			{
				_tp.btns.btn5.mouseEnabled =  false;
				_tp.btns.btn5.gotoAndStop( 1 );
			}
			else
			{
				_tp.btns.btn5.mouseEnabled = true;
				_tp.btns.btn5.gotoAndStop( 2 );
			}
		}
		
		/**
		 *正向转动，从0开始
		 */		
		public function start( i:int = 0 ):void
		{
			if ( head( i ) )
			{
				setup( i );
				_tp.play();
			}
		}
		/**
		 *反向转动，从0开始
		 */		
		public function end( i:int ):void
		{
			if ( back( i ) )
			{
				setup( i );
				_tp.gotoAndPlay( 11 );
			}
		}
		/**
		 * 判断能否正向转动 
		 * @param i
		 * @return 
		 */		
		private function head(i:int):Boolean
		{
			if ( i < top && i > _p )
			{
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
			_tp.btns.visible = false;
			initTF();
			mouseEnabled();
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
					start( top - 1 );
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
					if ( _p + 2 < top )
					{
						mc.gotoAndStop( 3 );
					}
					break;
				}
				case "btn2":
				{
					if ( _p + 1 < top )
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
					if ( _p + 2 < top )
					{
						mc.gotoAndStop( 2 );
					}
					break;
				}
				case "btn2":
				{
					if ( _p + 1 < top )
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
			_tp.btns.btn1.tf.text = _list[ _p + 2 ] + "\n" + (_p + 3);
			if ( _p + 2 >= top )
			{
				changeColor( _tp.btns.btn1.tf, _colors[0] );
			}
			else
			{
				changeColor( _tp.btns.btn1.tf, _color );
			}
			
			_tp.btns.btn2.tf.text = _list[ _p + 1 ] + "\n" + (_p + 2);
			if ( _p + 1 >= top )
			{
				changeColor( _tp.btns.btn2.tf, _colors[0] );
			}
			else
			{
				changeColor( _tp.btns.btn2.tf, _color );
			}
			
			//大扇形的文本
			_tp.btns.btn.tf.text = _list[ _p ] + "\n" + (_p + 1);
			if ( _p + 1 == top )
			{
				changeColor( _tp.btns.btn.tf, _colors[1] );
			}
			else
			{
				changeColor( _tp.btns.btn.tf, _colors[2] );
			}
			
			if ( _p <= 0)
			{
				_tp.btns.btn3.tf.text = "";
			}
			else
			{
				_tp.btns.btn3.tf.text = _list[ _p - 1 ] + "\n" + (_p + 0);
			}
			
			if ( _p <= 1)
			{
				_tp.btns.btn4.tf.text = "";
			}
			else
			{
				_tp.btns.btn4.tf.text = _list[ _p - 2 ] + "\n" + (_p - 1);
			}
			
			if ( _p <= 2)
			{
				_tp.btns.btn5.tf.text = "";
			}
			else
			{
				_tp.btns.btn5.tf.text = _list[ _p - 3 ] + "\n" + (_p - 2);
			}
		}
		/**
		 * 第四个为原来默认颜色
		 * @param tf
		 * @param type
		 */		
		private function changeColor( tf:TextField, color:uint ):void
		{
			tf.textColor = color;
		}
		/**
		 * 第四个为原来默认颜色
		 * @param tf
		 * @param type
		 */		
		private function changeColor2( tf:TextField, color:uint ):void
		{
			var format:TextFormat = tf.defaultTextFormat;
			var str:String = tf.text;
			format.color = color;
			tf.defaultTextFormat = format;
			tf.text = str;//文本值 不重新改变 新的TextFormat不会立即生效
		}
		/**
		 * 底部动画10个文本，以及三个大扇形的文本
		 */
		private function initAnimateTF():void
		{
			if ( idx + 4 >= leng )
			{
				_tp.circle.mc0.tf.text = "";
			}
			else
			{
				_tp.circle.mc0.tf.text = _list[ idx + 4 ] + "\n" + (idx + 5);
			}
			
			if ( idx + 3 >= leng )
			{
				_tp.circle.mc1.tf.text = "";
			}
			else
			{
				_tp.circle.mc1.tf.text = _list[ idx + 3 ] + "\n" + (idx + 4);
			}
			
			if ( idx + 2 >= leng )
			{
				_tp.circle.mc2.tf.text = "";
			}
			else
			{
				_tp.circle.mc2.tf.text = _list[ idx + 2 ] + "\n" + (idx + 3);
			}
			
			if ( idx + 1 >= leng )
			{
				_tp.circle.mc3.tf.text = "";
			}
			else
			{
				_tp.circle.mc3.tf.text = _list[ idx + 1 ] + "\n" + (idx + 2);
			}
			
			_tp.circle.mc4.tf.text = _list[ idx ] + "\n" + (idx + 1);
			_tp.circle.mc5.tf.text = _list[ idx ] + "\n" + (idx + 1);
			
			if ( idx <= 0 )
			{
				_tp.circle.mc6.tf.text = "";
			}
			else
			{
				_tp.circle.mc6.tf.text = _list[ idx - 1 ] + "\n" + (idx + 0);
			}
			if ( idx <= 1 )
			{
				_tp.circle.mc7.tf.text = "";
			}
			else
			{
				_tp.circle.mc7.tf.text = _list[ idx - 2 ] + "\n" + (idx - 1);
			}
			
			if ( idx <= 2 )
			{
				_tp.circle.mc8.tf.text = "";
			}
			else
			{
				_tp.circle.mc8.tf.text = _list[ idx - 3 ] + "\n" + (idx - 2);
			}
			
			if ( idx <= 3 )
			{
				_tp.circle.mc9.tf.text = "";
			}
			else
			{
				_tp.circle.mc9.tf.text = _list[ idx - 4 ] + "\n" + (idx - 3);
			}
			
			//三个大扇形的文本
			_tp.frame.angle0.tf.text = _list[ idx + 1 ] + "\n" + (idx + 2);
			_tp.frame.angle1.tf.text = _list[ idx ] + "\n" + (idx + 1);
			if ( idx <= 0 )
			{
				_tp.frame.angle2.tf.text = "";
			}
			else
			{
				_tp.frame.angle2.tf.text = _list[ idx - 1 ] + "\n" + (idx - 0);
			}
		}
		/**
		 *按钮事件侦听
		 *及MovieClip全stop 
		 *及鼠标事件状态
		 */		
		private function initBtn():void
		{
			_tp.stop();
			_tp.btns.btn.btn.addEventListener( MouseEvent.CLICK, fire );
			var l:uint = 6;
			while( --l >= 0 )
			{
				_tp.btns["btn" + l].buttonMode = true;
				_tp.btns["btn" + l].mouseChildren = false;
			}
			_tp.btns.btn0.gotoAndStop( 2 );
			_tp.btns.addEventListener( MouseEvent.CLICK, run );
			
			_tp.btns.addEventListener (MouseEvent.MOUSE_OVER, onOver1 );
			_tp.btns.addEventListener (MouseEvent.MOUSE_OUT, onOut1 );
		}
		private function onOut1(evt:MouseEvent):void
		{
			_tp.btns.removeEventListener(MouseEvent.MOUSE_MOVE, onMove );
			_lastBtn = null;
		}
		private function onOver1(evt:MouseEvent):void
		{
			_tp.btns.addEventListener (MouseEvent.MOUSE_MOVE, onMove );
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
				var mcBtn:MovieClip = _tp.btns["btn" + i++];
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
				fname();
			}
			else if (btn != _lastBtn)
			{
				fname();
				state( btn );
			}
			function fname():void
			{
				if ( _lastBtn )
				{
					state2( _lastBtn );
				}
				_lastBtn = btn;//未碰撞检测 到按钮,_lastBtn置null
			}
		}
		private function fire(e:MouseEvent):void
		{
			_func( idx + 1 );
		}
		protected function destroyTurn(e:Event):void
		{
			_tp.addFrameScript( 9, null, _tp.totalFrames - 1, null );
			
			_tp.btns.btn.btn.removeEventListener( MouseEvent.CLICK, fire );
			_tp.btns.removeEventListener( MouseEvent.CLICK, run );
		}
		
		private function down():void
		{
			idx++;
			if ( --time > 0)
			{
				_tp.gotoAndPlay( 1 );
				initAnimateTF();
			}
			else
			{
				_tp.btns.visible = true;
				_tp.gotoAndStop( 1 );
				onMove( null );
				_show( idx + 1 );
			}
		}
		
		private function up():void
		{
			idx--;
			if ( --time > 0)
			{
				_tp.gotoAndPlay( 11 );
				initAnimateTF();
			}
			else
			{
				_tp.btns.visible = true;
				_tp.gotoAndStop( 1 );
				onMove( null );
				_show( idx + 1 );
			}
		}
	}
}