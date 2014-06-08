package com.stintern.st2D.tests.turnX3.maingame
{
	import com.stintern.st2D.tests.turnX3.maingame.block.Block;
	import com.stintern.st2D.utils.scheduler.Scheduler;
	
	import flash.events.Event;
	
	public class DrawManager
	{
		
		public function DrawManager()
		{
		}
		
		public function processEntrance(entranceBlockArray:Vector.<Block>, isClose:Boolean):void
		{
			var _entranceScheduler:Scheduler = new Scheduler();
			_entranceScheduler.addFunc(10, deadFunction, 0);  
			_entranceScheduler.startScheduler();	
			
			var alpha:Number;
			isClose == true ? alpha = 1.0 : alpha = 0.0;
			
			var entranceBlockCount:uint = entranceBlockArray.length;
			function deadFunction(evt:Event = null):void
			{
				for(var i:uint=0; i<entranceBlockCount; ++i)
				{
					entranceBlockArray[i].setAlpha( alpha );
					
					if( (alpha < 0.0 || alpha > 1.0 ) && i == entranceBlockCount-1 )
					{
						_entranceScheduler.stopScheduler();
						_entranceScheduler = null;
						
						if( isClose )
						{
							processEntrance(entranceBlockArray, false);
						}
						else
						{
							entranceBlockArray = null;
						}
					}
				}
				isClose == true ? alpha -= 0.05 : alpha += 0.05;
			}
		}
	}
}