package com.stintern.st2D.tests.turnX3.maingame.block
{
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.display.SceneManager;
	import com.stintern.st2D.display.sprite.BatchSprite;
	import com.stintern.st2D.tests.turnX3.maingame.GameBoard;
	import com.stintern.st2D.tests.turnX3.maingame.Gravity;
	import com.stintern.st2D.tests.turnX3.maingame.LevelManager;
	import com.stintern.st2D.tests.turnX3.maingame.layer.MainGameLayer;
	import com.stintern.st2D.tests.turnX3.utils.Resources;
	import com.stintern.st2D.utils.Vector2D;
	
	public class BlockManager
	{
		private var _blockArray:Vector.<Block> = new Vector.<Block>();
		private var _keyBlockArray:Vector.<Block> = new Vector.<Block>();
		
		private var _batch:BatchSprite;
		
		private var _rowCount:uint;
		private var _colCount:uint;
		
		private var _finishedBlockCount:uint;
		
		public function BlockManager()
		{
			_finishedBlockCount = 0;
		}
		
		public function stepBlock():void
		{
			var keyBlockCount:uint = _keyBlockArray.length;
			for(var i:uint=0; i<keyBlockCount; ++i)
			{
				// If block is moving now or became the heart, then leave it
				if( _keyBlockArray[i].isMoving == true || 
					_keyBlockArray[i].type == Block.TYPE_OF_BLOCK_HEART )
				{
					continue;
				}
				
				// Get next position
				var pos:Vector2D = getNextPosition(_keyBlockArray[i].rowIndex, _keyBlockArray[i].colIndex );
				var coord:Array = getBlockPosition(pos.x, pos.y);
				
				// Move the blocks
				_keyBlockArray[i].moveTo(coord[0], coord[1], 150);
				
				// Update the board and block array
				updateStatus(pos, _keyBlockArray[i]);
				
				pos = null;
				coord = null;
			}
		}
		
		public function setBlockInfo():void
		{
			var boardArray:Vector.<Vector.<uint>> = GameBoard.instance.boardArray;
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
						case Block.TYPE_OF_BLOCK_OPEN_PANG:
							var block:Block = new Block();
							block.rowIndex = i;
							block.colIndex = j;
							
							block.type = boardArray[i][j];
							
							_blockArray.push(block);
							
							if( block.type == Block.TYPE_OF_BLOCK_MONG )
							{
								_keyBlockArray.push(block);
							}
							break;
						
						case Block.TYPE_OF_BLOCK_EMPTY:
							break;
					}// switch
				}// inner for
			}// outer for
		}
		
		public function setBlockSprite(batch:BatchSprite):void
		{
			_batch = batch;
			
			var blockCount:uint = _blockArray.length;
			var blockSize:Number = StageContext.instance.screenWidth / (_colCount + Resources.PADDING);
			
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
		
		public function getBlockArrayByType(type:uint):Vector.<Block>
		{
			var elements:Vector.<Block> = new Vector.<Block>();
			
			var blockCount:uint = _blockArray.length;
			for(var i:uint=0; i<blockCount; ++i)
			{
				if( _blockArray[i].type == type )
				{
					elements.push(_blockArray[i]);
				}
			}
			
			return elements;
		}
		
		/**
		 * check the gravity direction and if block can go to next positoin
		 * and return the next position to move
		 *  
		 * @param row current block's row index
		 * @param col current block's col index
		 * @return vector2D object including row and col
		 */
		private function getNextPosition(row:uint, col:uint):Vector2D
		{
			// Get current gravity direction
			var newRow:uint = row;
			var newCol:uint = col;
			
			trace(Gravity.instance.direction);
			switch(Gravity.instance.direction)
			{
				case Gravity.DIRECTION_DOWN:
					newRow += 1;
					break;
				
				case Gravity.DIRECTION_UP:
					newRow -= 1;
					break;
				
				case Gravity.DIRECTION_LEFT:
					newCol -= 1;
					break;
				
				case Gravity.DIRECTION_RIGHT:
					newCol += 1;
					break;
			}
			
			// Check if block can be moved to next position
			if( verifyNewPosition(newRow, newCol) )
			{
				return new Vector2D(newRow, newCol);
			}
			else
			{
				return new Vector2D(row, col);
			}
		}
		
		private function verifyNewPosition(row:uint, col:uint):Boolean
		{
			var type:uint = GameBoard.instance.boardArray[row][col];
			switch(type)
			{
				case Block.TYPE_OF_BLOCK_EMPTY:
				case Block.TYPE_OF_BLOCK_OPEN_PANG:
				case Block.TYPE_OF_BLOCK_ANI:
					return true;
					
				default:
					return false;
			}
			
			return true;
		}
		
		private function updateStatus(pos:Vector2D, block:Block):void
		{
			GameBoard.instance.boardArray[block.rowIndex][block.colIndex] = Block.TYPE_OF_BLOCK_EMPTY;
			
			// If new position is where the heart is located in, then update the board with heart
			if( GameBoard.instance.boardArray[pos.x][pos.y] == Block.TYPE_OF_BLOCK_ANI )
			{
				GameBoard.instance.boardArray[pos.x][pos.y] = Block.TYPE_OF_BLOCK_HEART;
				block.type = Block.TYPE_OF_BLOCK_HEART;
				
				// change the ani block to heart block
				changeImageOfBlock(block, Block.TYPE_OF_BLOCK_HEART);	
				_finishedBlockCount++;
				
				// If stage is passed
				if( _finishedBlockCount == LevelManager.instance.aniCount )
				{
					var mainGameLayer:MainGameLayer = SceneManager.instance.getCurrentScene().getLayerByTag(Resources.LAYER_MAINGAME) as MainGameLayer;
					mainGameLayer.nextLevel();
				}
			}
			else
			{
				GameBoard.instance.boardArray[pos.x][pos.y] = Block.TYPE_OF_BLOCK_MONG;
			}
			
			// Update block's row and col index
			block.rowIndex = pos.x;
			block.colIndex = pos.y;
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
				case Block.TYPE_OF_BLOCK_OPEN_PANG:
					return Resources.NAME_PANG;
					
				case Block.TYPE_OF_BLOCK_HEART:
					return Resources.NAME_ANI_HEART;
					
				case Block.TYPE_OF_BLOCK_EMPTY:
					return Resources.NAME_EMPTY;
					
				default:
					return "";
			}
		}
		
		private function getBlockPosition(row:uint, col:uint):Array
		{
			var blockSize:Number = StageContext.instance.screenWidth / (_colCount + Resources.PADDING);
			
			return new Array(
				(col + Resources.PADDING*0.5) * blockSize,
				StageContext.instance.screenHeight - blockSize * row
			);
		}
		
		private function changeImageOfBlock(block:Block, type:int):void
		{
			block.changeSprite(_batch, getBlockName(type)); 
			block.depth = 100;
			
			_batch.sortSprites();
		}
		
	}
}