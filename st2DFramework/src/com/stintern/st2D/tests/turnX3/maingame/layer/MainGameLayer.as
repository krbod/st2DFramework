package com.stintern.st2D.tests.turnX3.maingame.layer
{
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.display.Layer;
	import com.stintern.st2D.display.sprite.BatchSprite;
	import com.stintern.st2D.display.sprite.Sprite;
	import com.stintern.st2D.tests.turnX3.TouchManager;
	import com.stintern.st2D.tests.turnX3.maingame.block.Block;
	import com.stintern.st2D.tests.turnX3.maingame.block.BlockManager;
	import com.stintern.st2D.tests.turnX3.maingame.block.Helper;
	import com.stintern.st2D.tests.turnX3.maingame.block.HelperManager;
	import com.stintern.st2D.tests.turnX3.utils.Resources;
	import com.stintern.st2D.ui.Button;
	import com.stintern.st2D.ui.Text;
	import com.stintern.st2D.utils.UILoader;
	
	import flash.events.MouseEvent;
	import com.stintern.st2D.tests.turnX3.maingame.DrawManager;
	import com.stintern.st2D.tests.turnX3.maingame.GameBoard;
	import com.stintern.st2D.tests.turnX3.maingame.Gravity;
	import com.stintern.st2D.tests.turnX3.maingame.LevelManager;
	
	public class MainGameLayer extends Layer
	{
		private var _uiLoader:UILoader = new UILoader(); 
		
		private var _batch:BatchSprite;
		
		private var _blockManager:BlockManager;
		private var _helperManager:HelperManager;
		private var _drawManager:DrawManager;
		private var _touchManager:TouchManager;
		
		private var _gravity:Gravity;
		
		/** UI */
		private var _helperButton:Vector.<Button>;
		
		private var _txtBoxCount:Text;
		private var _txtArrowCount:Text;
		private var _txtIceCount:Text;
		
		public function MainGameLayer()
		{
			super();
			
			init();
			initUILoader();
			
			StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function update(dt:Number):void
		{
			if( _helperManager != null )
			{
				if( _helperManager.allBlocksIsSetUp() )
				{
					_blockManager.stepBlock();
				}
			}
				
		}
		
		private function init():void
		{
			_blockManager = new BlockManager();
			_helperManager = new HelperManager();
			_drawManager = new DrawManager();
			_touchManager = new TouchManager();
			
			_gravity = new Gravity();
			_gravity.direction = Gravity.DIRECTION_DOWN;
		}
		
		private function initUILoader():void
		{
			_uiLoader.init(this, Resources.IMAGE_GAME_LAYER_SHEET, Resources.XML_GAME_LAYER_SHEET, onUIInited);
			
			function onUIInited():void
			{
				_touchManager.init(_helperManager, updateCountText);
				_blockManager.init(_gravity);
				
				initBlockSprites();
				setUI();
			}
		}
		
		private function setUI():void
		{
			var bkgSprite:Sprite = _uiLoader.loadSprite(Resources.NAME_OF_BACKGROUND_IMAGE);
			
			_helperButton = new Vector.<Button>();
			_helperButton.push( _uiLoader.loadButton(Resources.NAME_OF_BOX_BUTTON, Resources.NAME_OF_BOX_BUTTON) );
			_helperButton.push( _uiLoader.loadButton(Resources.NAME_OF_ARROW_BUTTON, Resources.NAME_OF_ARROW_BUTTON) );
			_helperButton.push( _uiLoader.loadButton(Resources.NAME_OF_ICE_BUTTON, Resources.NAME_OF_ICE_BUTTON) );
			
			for(var i:uint=0; i<Helper.COUNT_OF_HELPER_TYPE; ++i)
			{
				_helperButton[i].tag = Helper.TYPE_OF_HELPER_BOX + i;
				
				_helperButton[i].callbackMouseDown = _touchManager.callbackHelperMouseDown;
				_helperButton[i].callbackMouseMove = _touchManager.callbackHelperMouseMove;
				_helperButton[i].callbackMouseUp = _touchManager.callbackHelperMouseUp;
			}
			
			_txtBoxCount = _uiLoader.loadTextField("BoxCount");
			_txtArrowCount = _uiLoader.loadTextField("ArrowCount");
			_txtIceCount = _uiLoader.loadTextField("IceCount");
		}
		
		private function initBlockSprites():void
		{
			_batch = new BatchSprite();
			_batch.createBatchSpriteWithPath(Resources.IMAGE_BLOCK_SPRITE_SHEET, Resources.XML_BLOCK_SPRITE_SHEET, onLoaded);
			this.addBatchSprite(_batch);
			
			function onLoaded():void
			{
				// helper manager need batchsprite to draw the helper block when touching the helper
				_helperManager.setBatchSprite(_uiLoader.batchSprite);
				
				initBoard();
			}
		}
		
		private function initBoard():void
		{
			// get current level
			var level:uint = 1;		// test
			
			LevelManager.instance.setCurrentLevel(level);
			
			// setting the board 
			GameBoard.instance.setBoardAt(level);
			
			// setting the block's infomation 
			_blockManager.setBlockInfo();
			
			// setting the block's sprite
			_blockManager.setBlockSprite(_batch);
			
			// setting the helper blocks
			//_levelManager.getHelperBlockCount(level);
			
			_helperManager.setCounts(4, 0, 0);		//test
			_txtBoxCount.text = ":4";
			_txtArrowCount.text = ":0";
			_txtIceCount.text = ":0";
		}

		private function updateCountText():void
		{
			_txtBoxCount.text = ":" + _helperManager.boxCount.toString();
			_txtArrowCount.text = ":" + _helperManager.arrowCount.toString();
			_txtIceCount.text = ":" + _helperManager.iceCount.toString();
		}
		
		private var isClicked:Boolean = false;
		private function onClick(event:MouseEvent):void
		{
			if( !isClicked )
				_drawManager.processEntrance( _blockManager.getBlockArrayByType(Block.TYPE_OF_BLOCK_OPEN_PANG), true );
			else 
				_drawManager.processEntrance( _blockManager.getBlockArrayByType(Block.TYPE_OF_BLOCK_OPEN_PANG), false );
			
			isClicked = !isClicked;
		}
		
	}
}
