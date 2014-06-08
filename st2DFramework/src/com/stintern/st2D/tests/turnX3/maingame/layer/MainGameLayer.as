package com.stintern.st2D.tests.turnX3.maingame.layer
{
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.display.Layer;
	import com.stintern.st2D.display.SceneManager;
	import com.stintern.st2D.display.sprite.BatchSprite;
	import com.stintern.st2D.tests.turnX3.TouchManager;
	import com.stintern.st2D.tests.turnX3.maingame.DrawManager;
	import com.stintern.st2D.tests.turnX3.maingame.GameBoard;
	import com.stintern.st2D.tests.turnX3.maingame.Gravity;
	import com.stintern.st2D.tests.turnX3.maingame.LevelManager;
	import com.stintern.st2D.tests.turnX3.maingame.block.Block;
	import com.stintern.st2D.tests.turnX3.maingame.block.BlockManager;
	import com.stintern.st2D.tests.turnX3.maingame.block.HelperManager;
	import com.stintern.st2D.tests.turnX3.utils.Resources;
	
	import flash.events.MouseEvent;
	
	public class MainGameLayer extends Layer
	{
		private var _batch:BatchSprite;
		
		private var _blockManager:BlockManager;
		private var _helperManager:HelperManager;
		private var _drawManager:DrawManager;
		private var _touchManager:TouchManager;
		
		private var _gravity:Gravity;
		
		public function MainGameLayer()
		{
			super();
			
			this.tag = Resources.LAYER_MAINGAME;
			
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
			
			var uiLayer:UILayer = SceneManager.instance.getCurrentScene().getLayerByTag(Resources.LAYER_UI) as UILayer;
			uiLayer.init(_touchManager.callbackHelperMouseDown, _touchManager.callbackHelperMouseMove, _touchManager.callbackHelperMouseUp );
		}
		
		private function initUILoader():void
		{
			_touchManager.init(_helperManager);
			_blockManager.init(_gravity);
			
			initBlockSprites();
		}
		
		private function initBlockSprites():void
		{
			_batch = new BatchSprite();
			_batch.createBatchSpriteWithPath(Resources.IMAGE_BLOCK_SPRITE_SHEET, Resources.XML_BLOCK_SPRITE_SHEET, onLoaded);
			this.addBatchSprite(_batch);
			
			function onLoaded():void
			{
				// helper manager need batchsprite to draw the helper block when touching the helper
				var uiLayer:UILayer = SceneManager.instance.getCurrentScene().getLayerByTag(Resources.LAYER_UI) as UILayer;
				_helperManager.setBatchSprite(uiLayer.uiLoader.batchSprite);
				
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
