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
		private var _helperButton:Vector.<Button>;
		
		private var _txtBoxCount:Text;
		private var _txtArrowCount:Text;
		private var _txtIceCount:Text;
		
		public function UILayer()
		{
			super();
			
			this.tag = Resources.LAYER_UI;
		}
		
		override public function update(dt:Number):void
		{
			
		}
		
		public function init(callbackMouseDown:Function, callbackMouseMove:Function, callbackMouseUp:Function):void
		{
			_uiLoader.init(this, Resources.IMAGE_GAME_LAYER_SHEET, Resources.XML_GAME_LAYER_SHEET, onUIInited);
			function onUIInited():void
			{
				setUI(callbackMouseDown, callbackMouseMove, callbackMouseUp);
			}
			
		}
		
		private function setUI(callbackMouseDown:Function, callbackMouseMove:Function, callbackMouseUp:Function):void
		{
			var bkgSprite:Sprite = _uiLoader.loadSprite(Resources.NAME_OF_BACKGROUND_IMAGE);
			
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
		
		public function updateCountText(box:String, arrow:String, ice:String):void
		{
			_txtBoxCount.text = ":" + box;
			_txtArrowCount.text = ":" + arrow;
			_txtIceCount.text = ":" + ice;
		}
		
		public function get uiLoader():UILoader
		{
			return _uiLoader;
		}
	}
}