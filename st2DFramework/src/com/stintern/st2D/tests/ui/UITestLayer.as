package com.stintern.st2D.tests.ui
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.ui.Button;
    import com.stintern.st2D.utils.UILoader;
    
    import flash.events.MouseEvent;
    
    public class UITestLayer extends Layer
    {
        private var _uiLoader:UILoader = new UILoader(); 
        
        private var _sprite:SpriteAnimation = new SpriteAnimation;
        
        public function UITestLayer()
        {
            super();
            
            init();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function init():void
        {
            _uiLoader.init(this, "res/atlas.png", "res/atlas.xml", loadComplete);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        private function loadComplete():void
        {
            var bkgSprite:Sprite = _uiLoader.loadSprite("BACKGROUND_1");
            bkgSprite.setAnchorPoint(0, 0);
            
            var button:Button = _uiLoader.loadButton("START_1", "START_CLICKED_1", onStartClick);
            button.setAnchorPoint(0, 1);
            
            var animation:SpriteAnimation = _uiLoader.loadAnimation("MOLE");
            animation.playAnimation();
        }
        
        private function onStartClick():void
        {
        }
        
        private function onTouch(event:MouseEvent):void
        {
            trace(event.stageX, event.stageY);
        }
        
    }
}