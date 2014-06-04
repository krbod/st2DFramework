package com.stintern.st2D.utils
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.ui.Button;

    public class UILoader
    {
        private var _batchSprite:BatchSprite = new BatchSprite();
        
        public function UILoader()
        {
        }
        
        /**
         *  
         * @param spritesheet
         * @param xml
         * 
         */
        public function init(layer:Layer, spritesheet:String, xml:String, onComplete:Function):void
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath(spritesheet, xml, onComplete);
            layer.addBatchSprite(_batchSprite);
        }
        
        public function loadSprite(name:String):Sprite
        {
            var sprite:Sprite = new Sprite();
            sprite.createSpriteWithBatchSprite(_batchSprite, name);
            sprite.setDefaultPosition(_batchSprite, name);
            _batchSprite.addSprite(sprite);
            
            return sprite;
        }
        
        public function loadButton(normalImage:String, clickedImage:String, onClick:Function):Button
        {
            var button:Button = new Button();
            button.createButton(_batchSprite, normalImage, clickedImage, onClick);
            return button;
        }
        
        public function loadAnimation(animationName:String):SpriteAnimation
        {
            var animation:SpriteAnimation = new SpriteAnimation();
            
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, animationName,  3);
            animation.createAnimationSpriteWithBatchSprite(_batchSprite, animationName, animationName);
            
            _batchSprite.addSprite(animation);
            
            return animation;
        }
            
    }
}