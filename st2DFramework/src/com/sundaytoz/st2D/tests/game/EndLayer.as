package com.sundaytoz.st2D.tests.game
{
    import com.sundaytoz.st2D.basic.StageContext;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.Scene;
    import com.sundaytoz.st2D.display.SceneManager;
    import com.sundaytoz.st2D.display.sprite.STSprite;
    
    import flash.events.MouseEvent;
    
    public class EndLayer extends Layer
    {
        private var sprite1:STSprite;
        private var sprite2:STSprite;
        
        public function EndLayer()
        {
            STSprite.createSpriteWithPath("res/gameover.jpg", onCreated, null, StageContext.instance.screenWidth/2, StageContext.instance.screenHeight/2);
            
        }
        
        override public function update(dt:Number):void
        {
            
        }
        
        private function onCreated(sprite:STSprite):void
        {
            sprite1 = sprite;
            this.addSprite(sprite1);
        }
        
        
        
        private function onTouch(event:MouseEvent):void
        {
            // 이곳에 맨 처음으로 사용할 레이어를 부릅니다.
            var aniLayer:DungGameLayer = new DungGameLayer();
            
            var scene:Scene = new Scene();
            scene.addLayer(aniLayer);
            
            SceneManager.instance.pushScene(scene);
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
    }
}