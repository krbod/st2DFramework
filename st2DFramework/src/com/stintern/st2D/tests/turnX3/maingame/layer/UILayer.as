package com.stintern.st2D.tests.turnX3.maingame.layer
{
	import com.stintern.st2D.display.Layer;
	import com.stintern.st2D.display.sprite.Sprite;
	import com.stintern.st2D.tests.turnX3.maingame.block.Helper;
	import com.stintern.st2D.tests.turnX3.utils.Resources;
	import com.stintern.st2D.ui.Button;
	import com.stintern.st2D.ui.Text;
	import com.stintern.st2D.utils.UILoader;
	
	public class UILayer extends Layer
	{
		private var _uiLoader:UILoader = new UILoader(); 
		
		/** UI */
		
		// helper
		private var _helperButton:Vector.<Button>;
		private var _txtBoxCount:Text;
		private var _txtArrowCount:Text;
		private var _txtIceCount:Text;
		
		// rotate
		private var _rotateLeftButton:Button;
		private var _rotateRightButton:Button;
		private var _rotate180Button:Button;
		
		private var _rotateLeftSprite:Sprite;
		private var _rotateRightSprite:Sprite;
		
		public function UILayer()
		{
			super();
			
			this.tag = Resources.LAYER_UI;
		}
		
		override public function update(dt:Number):void
		{
			
		}
		
		public function init(callbackArray:Vector.<Function>):void
		{
			_uiLoader.init(this, Resources.IMAGE_GAME_LAYER_SHEET, Resources.XML_GAME_LAYER_SHEET, onUIInited);
			function onUIInited():void
			{
				setUI(callbackArray);
				callbackArray = null;
			}
			
		}
		
		private function setUI(callbackArray:Vector.<Function>):void
		{
			var bkgSprite:Sprite = _uiLoader.loadSprite(Resources.NAME_OF_BACKGROUND_IMAGE);
			
			setHelperUI(callbackArray[0], callbackArray[1], callbackArray[2]);
			
			setRotateUI(callbackArray[3], callbackArray[4], callbackArray[5]);
		}
		
		private function setHelperUI(callbackMouseDown:Function, callbackMouseMove:Function, callbackMouseUp:Function):void
		{
			_helperButton = new Vector.<Button>();
			_helperButton.push( _uiLoader.loadButton(Resources.NAME_OF_BOX_BUTTON, Resources.NAME_OF_BOX_BUTTON) );
			_helperButton.push( _uiLoader.loadButton(Resources.NAME_OF_ARROW_BUTTON, Resources.NAME_OF_ARROW_BUTTON) );
			_helperButton.push( _uiLoader.loadButton(Resources.NAME_OF_ICE_BUTTON, Resources.NAME_OF_ICE_BUTTON) );
			
			for(var i:uint=0; i<Helper.COUNT_OF_HELPER_TYPE; ++i)
			{
				_helperButton[i].tag = Helper.TYPE_OF_HELPER_BOX + i;
				
				_helperButton[i].callbackMouseDown = callbackMouseDown;
				_helperButton[i].callbackMouseMove = callbackMouseMove;
				_helperButton[i].callbackMouseUp = callbackMouseUp;
			}
			
			_txtBoxCount = _uiLoader.loadTextField("BoxCount");
			_txtArrowCount = _uiLoader.loadTextField("ArrowCount");
			_txtIceCount = _uiLoader.loadTextField("IceCount");
			
			_txtBoxCount.text = ":4";
			_txtArrowCount.text = ":0";
			_txtIceCount.text = ":0";
		}
		
		private function setRotateUI(callbackRotateLeft:Function, callbackRotateRight:Function, callbackRotate180:Function):void
		{
			_rotateLeftButton = _uiLoader.loadButton(Resources.NAME_OF_ROTATE_LEFT_BUTTON, Resources.NAME_OF_ROTATE_LEFT_BUTTON_CLICKED);
			_rotateRightButton = _uiLoader.loadButton(Resources.NAME_OF_ROTATE_RIGHT_BUTTON, Resources.NAME_OF_ROTATE_RIGHT_BUTTON_CLICKED);
			_rotate180Button = _uiLoader.loadButton(Resources.NAME_OF_ROTATE_180_BUTTON, Resources.NAME_OF_ROTATE_180_BUTTON_CLICKED);
			
			_rotateLeftButton.callbackClick = callbackRotateLeft;
			_rotateRightButton.callbackClick = callbackRotateRight;
			_rotate180Button.callbackClick = callbackRotate180;
			
			_rotateLeftSprite = _uiLoader.loadSprite(Resources.NAME_OF_ROTATE_LEFT_IMAGE);
			_rotateRightSprite = _uiLoader.loadSprite(Resources.NAME_OF_ROTATE_RIGHT_IMAGE);
			
			// At first, rotate ui can't be showed.
			_rotateLeftButton.setVisible(false);
			_rotateRightButton.setVisible(false);
			_rotate180Button.setVisible(false);
			
			_rotateLeftSprite.setVisible(false);
			_rotateRightSprite.setVisible(false);
		}
		
		public function updateCountText(box:uint, arrow:uint, ice:uint):void
		{
			_txtBoxCount.text = ":" + box;
			_txtArrowCount.text = ":" + arrow;
			_txtIceCount.text = ":" + ice;
			
			// Make the Helper UIs invisible and the Rotation UIs visible 
			if( box == 0 && arrow == 0 && ice == 0 )
			{
				exchangeUI();
			}
		}
		
		private function exchangeUI():void
		{
			// Make the Helper UIs invisible
			for(var i:uint=0; i<Helper.COUNT_OF_HELPER_TYPE; ++i)
			{
				_helperButton[i].setVisible(false);
			}
			
			_txtBoxCount.setVisible(false);
			_txtArrowCount.setVisible(false);
			_txtIceCount.setVisible(false);
			
			// Make the Rotation UIs visible
			_rotateLeftButton.setVisible(true);
			_rotateRightButton.setVisible(true);
			_rotate180Button.setVisible(true);
			
			_rotateLeftSprite.setVisible(true);
			_rotateRightSprite.setVisible(true);
		}
		
		public function get uiLoader():UILoader
		{
			return _uiLoader;
		}
	}
}