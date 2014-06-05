package com.stintern.st2D.utils
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.ui.Button;
    import com.stintern.st2D.ui.Slider;
    import com.stintern.st2D.ui.Text;

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
            _batchSprite.addSprite(sprite);
            
            var frame:AnimationFrame = AnimationData.instance.animationData[_batchSprite.path]["frame"][name];
            sprite.position.x = frame.pivotX;
            sprite.position.y = StageContext.instance.screenHeight - frame.pivotY;
            
            sprite.setAnchorPoint(frame.anchorX, frame.anchorY);
            
            return sprite;
        }
        
        public function loadButton(normalImage:String, clickedImage:String, onClick:Function = null):Button
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
        
        public function loadTextField(name:String):Text
        {
            var text:Text = new Text();
            
            var frame:AnimationFrame = AnimationData.instance.animationData[_batchSprite.path]["frame"][name];
            text.init(frame);
            
            return text;
        }
        
        public function loadSlider(barImage:String, buttonImage:String, type:uint = 0, onClick:Function = null, onMouseDown:Function = null, onMouseUp:Function = null):Slider
        {
            var slider:Slider = new Slider();
            slider.createSlider(_batchSprite, barImage, buttonImage, type, onClick, onMouseDown, onMouseUp);
            
            return slider;
        }
            
    }
}