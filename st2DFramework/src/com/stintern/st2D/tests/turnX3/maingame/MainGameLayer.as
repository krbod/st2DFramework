package com.stintern.st2D.tests.turnX3.maingame
{
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.display.Layer;
	import com.stintern.st2D.display.sprite.BatchSprite;
	import com.stintern.st2D.display.sprite.Sprite;
	import com.stintern.st2D.tests.turnX3.maingame.block.Block;
	import com.stintern.st2D.tests.turnX3.maingame.block.BlockManager;
	import com.stintern.st2D.tests.turnX3.maingame.block.Helper;
	import com.stintern.st2D.tests.turnX3.maingame.block.HelperManager;
	import com.stintern.st2D.tests.turnX3.utils.Resources;
	import com.stintern.st2D.ui.Button;
	import com.stintern.st2D.ui.Text;
	import com.stintern.st2D.utils.UILoader;
	
	import flash.events.MouseEvent;
	
	public class MainGameLayer extends Layer
	{
		private var _uiLoader:UILoader = new UILoader(); 
		
		private var _gameStage:GameBoard;
		private var _batch:BatchSprite;
		
		private var _blockManager:BlockManager;
		private var _helperManager:HelperManager;
		private var _drawManager:DrawManager;
		
		
		/** UI */
		private var _helperButton:Vector.<Button>;
		
		private var _txtBoxCount:Text;
		private var _txtArrowCount:Text;
		private var _txtIceCount:Text;
		
		public function MainGameLayer()
		{
			super();
			
			initUILoader();
			
			StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function update(dt:Number):void
		{
			if( _blockManager != null )
				_blockManager.stepBlock();
		}
		
		private function initUILoader():void
		{
			_uiLoader.init(this, Resources.IMAGE_GAME_LAYER_SHEET, Resources.XML_GAME_LAYER_SHEET, onUIInited);
			
			function onUIInited():void
			{
				setUI();
				
				initBlockSprites();
			}
		}
		
		private function setUI():void
		{
			var bkgSprite:Sprite = _uiLoader.loadSprite("bkg");
			
			_helperButton = new Vector.<Button>();
			_helperButton.push( _uiLoader.loadButton("BoxButton", "BoxButton") );
			_helperButton.push( _uiLoader.loadButton("ArrowButton", "ArrowButton") );
			_helperButton.push( _uiLoader.loadButton("IceButton", "IceButton") );
			
			for(var i:uint=0; i<Helper.COUNT_OF_HELPER_TYPE; ++i)
			{
				_helperButton[i].callbackMouseDown = callbackHelperMouseDown;
				_helperButton[i].callbackMouseMove = callbackHelperMouseMove;
				_helperButton[i].callbackMouseUp = callbackHelperMouseUp;
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
				_blockManager = new BlockManager();
				_helperManager = new HelperManager();
				_drawManager = new DrawManager();
				
				initBoard();
			}
		}
		
		private function initBoard():void
		{
			_gameStage = new GameBoard();
			
			// get current level
			var level:uint = 1;		// test
			
			LevelManager.instance.setCurrentLevel(level);
			
			// setting the board 
			_gameStage.setBoardAt(level);
			
			// setting the block's infomation 
			_blockManager.setBlockInfo(_gameStage);
			
			// setting the block's sprite
			_blockManager.setBlockSprite(_batch);
			
			// setting the helper blocks
			//_levelManager.getHelperBlockCount(level);
			
			_helperManager.setCounts(3, 0, 0);		//test
			_txtBoxCount.text = ":3";
			_txtArrowCount.text = ":0";
			_txtIceCount.text = ":0";
		}
		
		private function callbackHelperMouseDown():void
		{
			
		}
		
		private function callbackHelperMouseMove():void
		{
			
		}
		
		private function callbackHelperMouseUp():void
		{
			
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
