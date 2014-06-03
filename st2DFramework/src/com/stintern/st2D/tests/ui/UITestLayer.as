package com.stintern.st2D.tests.ui
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.ui.Button;
    
    import flash.events.MouseEvent;
    
    public class UITestLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
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
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/atlas.png", "res/atlas.xml", loadComplete);
            addBatchSprite(_batchSprite);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        private function loadComplete():void
        {
            var bkgSprite:Sprite = new Sprite();
            bkgSprite.createSpriteWithBatchSprite(_batchSprite, "BACKGROUND_1");
            bkgSprite.setDefaultPosition(_batchSprite, "BACKGROUND_1");
            bkgSprite.setAnchorPoint(0, 0);
            _batchSprite.addSprite(bkgSprite);
            
            var button:Button = new Button();
            button.createButton(_batchSprite, "START_1", "START_CLICKED_1", onStartClick);
            button.setAnchorPoint(0, 1);
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