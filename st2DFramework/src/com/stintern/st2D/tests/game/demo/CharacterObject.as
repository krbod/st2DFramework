package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.scheduler.Scheduler;

    public class CharacterObject
    {
        private var _info:CharacterInfo;
        private var _batchSprite:BatchSprite;
        private var _sprite:SpriteAnimation;
        private var _targetObject:CharacterObject;
        private var _attackScheduler:Scheduler = new Scheduler;
        
        private var _characterMovingLayer:CharacterMovingLayer = SceneManager.instance.getCurrentScene().getLayerByName("CharacterMovingLayer") as CharacterMovingLayer;
        private var _backGroundLayer:BackGroundLayer = SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer;
        private var _controlLayer:ControlLayer = SceneManager.instance.getCurrentScene().getLayerByName("ControlLayer") as ControlLayer;
        
        public static const RUN:String = "RUN";
        public static const ATTACK:String = "ATTACK";
         
        
        public function CharacterObject(path:String, hp:Number, power:Number, speed:Number, ally:Boolean)
        {
            _info = new CharacterInfo(hp, power, speed, ally);
            _batchSprite = _characterMovingLayer.batchSprite;
            _targetObject = null;
            
            _attackScheduler.addFunc(2000, attackFunc, 0);
            _attackScheduler.startScheduler();
            function attackFunc():void
            {
                if(_info.state==ATTACK && _targetObject)
                {
                    _targetObject.info.hp -= _info.power;
                    trace(_targetObject.info.hp)
                    if(_targetObject.info.hp <= 0)
                    {
                        _targetObject.attackScheduler.stopScheduler();
                        if(_info.ally)
                        {
                            _controlLayer.removeEnemyCharacterObject(_targetObject);
                        }
                        else
                        {
                            _controlLayer.removePlayerCharacterObject(_targetObject);
                        }
                        _characterMovingLayer.batchSprite.removeSprite(_targetObject.sprite);
                        _info.state = RUN;
                        _sprite.setPlayAnimation("character_run")
                        _sprite.isMoving = true;
                        _targetObject = null;
                        _attackScheduler.stopScheduler();
                    }
                }
            }
            
            onCreated();
        }

        private function onCreated():void
        {
            _sprite = new SpriteAnimation();
            var x:Number = 0;
            var y:Number = 0;
            _sprite.createAnimationSpriteWithPath("res/demo/demo_spritesheet.png", "character_run", onSpriteCreated, null, x, y );
        }
        
        private function onSpriteCreated():void
        {
            _sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/5, StageContext.instance.screenHeight/5);
            if(_info.ally == true)
            {
                _sprite.position.x = 0;
                _sprite.position.y = _sprite.height;
                _batchSprite.addSprite(_sprite);
                _sprite.moveTo(StageContext.instance.screenWidth * _backGroundLayer.bgPageNum, _sprite.height, _info.speed);
            }
            else
            {
                _sprite.position.x = StageContext.instance.screenWidth * _backGroundLayer.bgPageNum;
                _sprite.position.y = _sprite.height;
                _batchSprite.addSprite(_sprite);
                _sprite.moveTo(0, _sprite.height, _info.speed);
            }
            _sprite.playAnimation();
        }

        public function get sprite():SpriteAnimation
        {
            return _sprite;
        }

        public function get info():CharacterInfo
        {
            return _info;
        }

        public function set info(value:CharacterInfo):void
        {
            _info = value;
        }

        public function get targetObject():CharacterObject
        {
            return _targetObject;
        }

        public function set targetObject(value:CharacterObject):void
        {
            _targetObject = value;
        }

        public function get attackScheduler():Scheduler
        {
            return _attackScheduler;
        }



    }
}
import com.stintern.st2D.tests.game.demo.CharacterObject;


class CharacterInfo
{
    private var _hp:Number;
    private var _power:Number;
    private var _speed:Number
    private var _ally:Boolean;
    private var _state:String;
    
    public function CharacterInfo(hp:Number, power:Number, speed:Number, ally:Boolean)
    {
        _hp = hp;
        _power = power;
        _speed = speed;
        _ally = ally;
        _state = CharacterObject.RUN;
    }

    public function get hp():Number
    {
        return _hp;
    }
    
    public function set hp(value:Number):void
    {
        _hp = value;
    }

    public function get power():Number
    {
        return _power;
    }

    public function get speed():Number
    {
        return _speed;
    }

    public function get ally():Boolean
    {
        return _ally;
    }

    public function get state():String
    {
        return _state;
    }

    public function set state(value:String):void
    {
        _state = value;
    }


}