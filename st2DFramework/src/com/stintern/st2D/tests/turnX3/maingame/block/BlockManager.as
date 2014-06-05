package com.stintern.st2D.tests.turnX3.maingame.block
{
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.display.sprite.BatchSprite;
	import com.stintern.st2D.tests.turnX3.maingame.GameBoard;
	import com.stintern.st2D.tests.turnX3.maingame.LevelManager;
	import com.stintern.st2D.tests.turnX3.utils.Resources;

	public class BlockManager
	{
		private var _blockArray:Vector.<Block> = new Vector.<Block>();
		private var _rowCount:uint;
		private var _colCount:uint;
		
		private var PADDING:uint = 2;	
		
		public function BlockManager()
		{
		}
		
		public function setBlockInfo(board:GameBoard):void
		{
			var boardArray:Vector.<Vector.<uint>> = board.boardArray;
			_rowCount = LevelManager.instance.rowCount;
			_colCount = LevelManager.instance.colCount;
			
			for(var i:uint=0; i<_rowCount; ++i)
			{
				for(var j:uint=0; j<_colCount; ++j)
				{
					switch(boardArray[i][j])
					{
						case Block.TYPE_OF_BLOCK_ANI:
						case Block.TYPE_OF_BLOCK_MONG:
						case Block.TYPE_OF_BLOCK_PANG:
							var block:Block = new Block();
							block.rowIndex = i;
							block.colIndex = j;
							
							block.type = boardArray[i][j];
							
							_blockArray.push(block);
							break;
						
						case Block.TYPE_OF_BLOCK_EMPTY:
							break;
					}// switch
				}// inner for
			}// outer for
		}
		
		public function setBlockSprite(batch:BatchSprite):void
		{
			var blockCount:uint = _blockArray.length;
			var blockSize:Number = StageContext.instance.screenWidth / (_colCount + PADDING);
			
			for(var i:uint=0; i<blockCount; ++i)
			{
				var pos:Array = getBlockPosition(_blockArray[i].rowIndex, _blockArray[i].colIndex);
				_blockArray[i].createSpriteWithBatchSprite(
					batch, 
					getBlockName(_blockArray[i].type), 
					pos[0], pos[1]);
				
				pos = null;
				
				_blockArray[i].setAnchorPoint(0.0, 1.0);
				_blockArray[i].scale.x = blockSize/Resources.IMAGE_SIZE;
				_blockArray[i].scale.y = blockSize/Resources.IMAGE_SIZE;
					
				batch.addSprite(_blockArray[i]);
			}
		}
		
		private function getBlockName(type:uint):String
		{
			switch(type)
			{
				case Block.TYPE_OF_BLOCK_ANI:
					return Resources.NAME_ANI;
					
				case Block.TYPE_OF_BLOCK_MONG:
					return Resources.NAME_MONGYI;
					
				case Block.TYPE_OF_BLOCK_PANG:
					return Resources.NAME_PANG;
					
				case Block.TYPE_OF_BLOCK_EMPTY:
					return Resources.NAME_EMPTY;
					
				default:
					return "";
			}
		}
			
		private function getBlockPosition(row:uint, col:uint):Array
		{
			var blockSize:Number = StageContext.instance.screenWidth / (_colCount + PADDING);
			
			return new Array(
				(col + 1) * blockSize,
				StageContext.instance.screenHeight - blockSize * row
				);
		}
			
	}
}