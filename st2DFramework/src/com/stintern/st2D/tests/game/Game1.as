import com.stintern.st2D.display.Layer;
import com.stintern.st2D.display.sprite.STAnimation;

class GameObject
{
    public var _sprite:STAnimation = new STAnimation;
    public var _info:ObjectInfo;
    public static var loadingCnt:int = 0;
    
    public function GameObject(path:String, animationName:String, hp:Number, power:Number, party:String)
    {
        _info = new ObjectInfo(hp, power, party);
        _sprite.createAnimationSpriteWithPath(path, animationName, onCreated);
    }
    
    private function onCreated():void
    {
        loadingCnt++;
    }
}

class ObjectInfo
{
    public var _hp:Number;
    public var _power:Number;
    public var _party:String;
    
    public function ObjectInfo(hp:Number, power:Number, party:String)
    {
        _hp = hp;
        _power = power;
        _party = party;
    }
}

package com.stintern.st2D.tests.game
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.STAnimation;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.Event;
    
    public class Game1 extends Layer
    {
        private var gameObject:Vector.<GameObject> = new Vector.<GameObject>;
        private var testSprite:STAnimation = new STAnimation;
        private var gameStart:Boolean = false;
        private var _batchSprite:BatchSprite;
        private var sch:Scheduler = new Scheduler();
        
        public function Game1()
        {
            init();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function init():void
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/atlas.png", "res/atlas.xml", loadCompleted);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {   
            //원하는 애니메이션 자유롭게 설정.              사용할 텍스쳐 이름                                         애니메이션 이름                    프레임 호출 순서                                각 프레임 별 대기 시간(프레임) 다음 애니메이션
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("right", new Array("right0","right1","right2","right1"), 8, "right"));
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("left",  new Array("left0","left1","left2","left1"),     8, "left")); 
            AnimationData.instance.setAnimation("res/atlas.png", new Animation("fire",  new Array("fire0","fire1","fire2","fire3",
                "fire4","fire5","fire6","fire7"),     6, "fire")); 
            
            testSprite.createAnimationSpriteWithPath("res/atlas.png", "fire", nullFunction, null, 512, 384); 
            
            for(var i:int=0; i< 10; i++)
            {
                gameObject.push(new GameObject("res/atlas.png", "right", 100, 10, "PLAYER"));
            }
            for(i=0; i< 10; i++)
            {
                gameObject.push(new GameObject("res/atlas.png", "left", 100, 10, "ENEMY"));
            }
            
            sch.addFunc(300, gameSetting, 0);
            sch.startScheduler();
            
            function nullFunction():void {}
        }
        
        private function gameSetting(evt:Event):void
        {
            if(GameObject.loadingCnt != 20) return;
            else sch.stopScheduler();
            
            for(var i:int=0; i < 20; i++)
            {
                if(gameObject[i]._info._party == "PLAYER")
                {
                    gameObject[i]._sprite.position.x = 100;
                    gameObject[i]._sprite.position.y = i * 32 + 100;
                }
                else
                {
                    gameObject[i]._sprite.position.x = 600;
                    gameObject[i]._sprite.position.y = (i-10) * 32 + 100;
                }
                
                gameObject[i]._sprite.depth = 2;
                _batchSprite.addSprite(gameObject[i]._sprite);
            }
            
            testSprite.depth = 5;
            _batchSprite.addSprite(testSprite);
            
            startGame();
        }
        
        private function startGame():void
        {
            for(var i:int=0; i < 20; i++)
            {
                gameObject[i]._sprite.playAnimation();
                if(gameObject[i]._info._party == "ENEMY") gameObject[i]._sprite.moveBy(-600, 0, 20);
            }
            
            testSprite.playAnimation();
            
            gameStart = true;
        }
    }
}