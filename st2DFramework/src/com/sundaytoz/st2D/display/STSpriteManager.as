package com.sundaytoz.st2D.display
{
    import com.adobe.utils.PerspectiveMatrix3D;
    import com.sundaytoz.st2D.basic.StageContext;
    
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Matrix3D;
    

    public class STSpriteManager
    {
        // 싱글톤 관련 변수들
        private static var _instance:STSpriteManager;
        private static var _creatingSingleton:Boolean = false;
        
        private var _sprites:Vector.<STSprite> = new Vector.<STSprite>;
        
        private var modelViewProjection:Matrix3D = new Matrix3D();
        private var viewMatrix:Matrix3D = new Matrix3D();
        private var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
        
        public function STSpriteManager()
        {
            if (!_creatingSingleton){
                throw new Error("[Context] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():STSpriteManager
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new STSpriteManager();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        public function addSprite(sprite:STSprite):void
        {
            // zOrder 에 맞게 추가
            
            _sprites.push(sprite);
        }
        
        public function drawAllSprites():void
        {
            var context:Context3D = StageContext.instance.context;
            
            context.clear(1, 1, 1);
            
            context.setDepthTest(false, Context3DCompareMode.LESS);            
            context.setProgram( StageContext.instance.shaderProgram );
            
            for each( var sprite:STSprite in _sprites )
            {
                // 화면 밖의 스프라이트 인지 검사후 화면 밖이면 그리지 않음
                if( isInScreen(sprite) == false )
                    continue;
                
                context.setTextureAt(0, sprite.texture);
                context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                
                sprite.update();
                
                modelViewProjection.identity();
                modelViewProjection.append(sprite.modelMatrix );
                modelViewProjection.append(StageContext.instance.viewMatrix);
                modelViewProjection.append(StageContext.instance.projectionMatrix);
                
                context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true);
               
                context.setVertexBufferAt(0, sprite.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);       // position
                context.setVertexBufferAt(1, sprite.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);      // tex coord
                context.setVertexBufferAt(2, sprite.vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_4);      // vertex rgba
                
                context.drawTriangles(sprite.indexBuffer, 0, sprite.numTriangle);
                
            }
            
            context.present();
        }
        
        /**
         * 스프라이트가 현재 스크린 안에 있는지 확인합니다. 
         */
        private function isInScreen(sprite:STSprite):Boolean
        {
            if( sprite.right < 0 || 
                sprite.top < 0 || 
                sprite.left > StageContext.instance.screenWidth || 
                sprite.bottom > StageContext.instance.screenHeight)
            {
                return false;
            }
            
            return true;
        }
        
        /**
         * 모든 스프라이트가 담긴 벡터를 반환합니다. 
         */
        public function getAllSprites():Vector.<STSprite>
        {
            return _sprites;
        }
        
        /**
         * 스프라이트 벡터에서 스프라이트를 삭제합니다.  
         * @param sprite    삭제할 스프라이트
         */
        internal function removeSprite(sprite:STSprite):void
        {
            for( var i:uint = 0; i<_sprites.length; ++i)
            {
                if( _sprites[i] == sprite )
                {
                    _sprites.splice(i, 1);
                }
            }
        }
        
    }
}