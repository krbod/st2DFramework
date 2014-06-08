package com.stintern.st2D.tests.turnX3.maingame.block
{
	import com.stintern.st2D.display.sprite.BatchSprite;
	import com.stintern.st2D.display.sprite.Sprite;
	import com.stintern.st2D.tests.turnX3.maingame.GameBoard;
	import com.stintern.st2D.tests.turnX3.utils.Resources;

	public class HelperManager
	{
		private var _boxCount:uint;
		private var _arrowCount:uint;
		private var _iceCount:uint;

		private var _movingSprite:Sprite;
		private var _batch:BatchSprite;
		
		private var _helperArray:Vector.<Sprite>;
		
		public function HelperManager()
		{
			_movingSprite = null;
			_helperArray = new Vector.<Sprite>();
		}
		
		public function moveHelperSprite(tag:uint, x:Number, y:Number):void
		{
			if( _movingSprite == null )
			{
				var sprite:Sprite = new Sprite();
				
				switch( tag )
				{
					case Helper.TYPE_OF_HELPER_BOX:
						sprite.createSpriteWithBatchSprite(_batch, Resources.NAME_OF_BOX_BUTTON);
						break;
					
					case Helper.TYPE_OF_HELPER_ARROW:
						sprite.createSpriteWithBatchSprite(_batch, Resources.NAME_OF_ARROW_BUTTON);
						break;
					
					case Helper.TYPE_OF_HELPER_ICE:
						sprite.createSpriteWithBatchSprite(_batch, Resources.NAME_OF_ICE_BUTTON);
						break;
				}
				
				sprite.tag = tag;
				_batch.addSprite(sprite);
				
				_movingSprite = sprite;
				_movingSprite.setAnchorPoint(0, 1);
				
			}
			
			_movingSprite.position.x = x;
			_movingSprite.position.y = y;
		}
		
		public function setupHelper(tag:uint, row:uint, col:uint):void
		{
			var type:uint;
			switch(tag)
			{
				case Helper.TYPE_OF_HELPER_BOX:
					type = Block.TYPE_OF_BLOCK_BOX;
					_boxCount--;
					break;
				
				case Helper.TYPE_OF_HELPER_ARROW:
					type = Block.TYPE_OF_BLOCK_ARROW;
					_arrowCount--;
					break;
				
				case Helper.TYPE_OF_HELPER_ICE:
					type = Block.TYPE_OF_BLOCK_ICE;
					_iceCount--;
					break;
			}
			
			GameBoard.instance.boardArray[row][col] = type;
			
			_helperArray.push(_movingSprite);
			_movingSprite = null;
		}
		
		public function allBlocksIsSetUp():Boolean
		{
			if( _helperArray.length == 0 )
				return false;
			
			if( boxCount == 0 &&
				arrowCount == 0 &&
				iceCount == 0 )
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * setting the count of each helper blocks
		 *  
		 * @param box count of box helper block
		 * @param arrow count of arrow helper block
		 * @param ice count of ice helper block
		 */
		public function setCounts(box:uint, arrow:uint, ice:uint):void
		{
			_boxCount = box;
			_arrowCount = arrow;
			_iceCount = ice;
		}
		
		public function get boxCount():uint
		{
			return _boxCount;
		}
		
		public function get arrowCount():uint
		{
			return _arrowCount;
		}
		
		public function get iceCount():uint
		{
			return _iceCount;
		}
		
		public function setBatchSprite(batch:BatchSprite):void
		{
			_batch = batch;	
		}
	}
}