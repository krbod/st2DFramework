package com.stintern.st2D.tests.ui
{
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.ui.Button;
    import com.stintern.st2D.ui.Text;
    import com.stintern.st2D.utils.UILoader;
    
    public class UITestLayer extends Layer
    {
        private var _uiLoader:UILoader = new UILoader(); 
        
        private var _text:Text;
        
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
        }
        
        private function loadComplete():void
        {
            var bkgSprite:Sprite = _uiLoader.loadSprite("BACKGROUND_1");
            var button:Button = _uiLoader.loadButton("START_1", "START_CLICKED_1", onStartClick);
            
            var animation:SpriteAnimation = _uiLoader.loadAnimation("MOLE");
            animation.playAnimation();
            
            _text = _uiLoader.loadTextField("PLZ");
            _text.callbackClick = onTextClick;
        }
        
        private function onStartClick():void
        {
            
        }
        
        private function onTextClick():void
        {
            _text.text = "Clicked";
        }
    }
}