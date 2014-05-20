package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.sprite.BaseSprite;
    import com.stintern.st2D.display.sprite.STSprite;
    import com.stintern.st2D.utils.AssetLoader;
    import com.stintern.st2D.utils.GameStatus;
    
    import flash.display.Bitmap;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Matrix3D;
    import com.stintern.st2D.animation.AnimationData;
    
    /**
     * 하나의 텍스쳐를 이용하는 스프라이트의 경우 BatchSprite 를 이용하여 
     * 효율적으로 화면에 출력할 수 있습니다.  
     */
    public class BatchSprite extends BaseSprite
    {
        private var _sprites:Array = new Array();
        private var _updateRequired:Boolean = true;     //Vertex, Index Buffer 를 그리기 전에 갱신해야 하는 여부
        
        public function BatchSprite()
        {
        }
        
        public function dispose():void
        {
            destroyBuffers();
        }
        
        /**
         * BatchSprite 를 생성합니다. 
         * @param path BatchSprite 에 사용할 이미지 경로
         * @param pathXML path로 읽어온 이미지에서 사용할 frame 정보들을 가져올 xml 경로
         * @param onCreated 생성된 후 호출될 메소드
         * @param onProgress 생성중 진행 상황을 알 수 있는 메소드
         */
        public function createBatchSpriteWithPath(path:String, pathXML:String, onCreated:Function, onProgress:Function = null ):void
        {
            this.path = path;
            
            //애니메이션 데이터를 저장할 수 있게 path를 key로 하는 dictionary를 만들고 xml 데이터를 읽어옵니다.
            AnimationData.instance.createAnimationDictionary(path, pathXML, onCreated);
            
            //이미지 파일을 읽어옵니다.
            AssetLoader.instance.loadImageTexture(path, onComplete, onProgress);
            
            function onComplete(object:Object, zOrder:uint):void
            {
                //이미지파일을 저장합니다.
                createBatchSpriteWithBitmap((object as Bitmap));
                //이미지 로딩이 끝났다는 의미에서 변수를 1 증가시킵니다.
                AnimationData.instance.animationData[path]["available"]++;
                
                //모든 로딩이 종료 되었으면 콜백함수를 호출합니다.
                if( AnimationData.instance.animationData[path]["available"] == 2 )
                {
                    if(onCreated != null) onCreated();
                }
            }
        }
        
        /**
         * 스프라이트에 사용할 텍스쳐를 초기화합니다. 
         * @param bitmap 텍스쳐에 사용할 비트맵객체
         * @param useMipMap 비트맵 밉맵을 생성할 지 여부
         */
        public function createBatchSpriteWithBitmap(bitmap:Bitmap):void
        {
            this.textureData = bitmap;
            
            var context:Context3D = StageContext.instance.context;
            this.texture = context.createTexture(bitmap.width, bitmap.height, Context3DTextureFormat.BGRA, false);
            uploadTextureWithMipmaps(this.texture, bitmap.bitmapData);      
        }
        
        /**
         * BatchSprite 에 새로운 Sprite 를 추가합니다. 
         * @param sprite 추가할 Sprite
         */
        public function addSprite(sprite:STSprite):void
        {
            // BatchSprite 의 텍스쳐에 sprite 의 텍스쳐가 있는지 확인
            //            if( sprite.textureData != _textureData || )
            //            {
            //                
            //            }
            
            var spriteMatrixRawData:Vector.<Number> = sprite.modelMatrix.rawData;
            var spriteVertexData:Vector.<Number> = sprite.vertexData;
            
            var targetIndex:int = _sprites.length * VERTEX_COUNT * DATAS_PER_VERTEX;
            var sourceIndex:int = 0;
            var sourceEnd:int = VERTEX_COUNT * DATAS_PER_VERTEX;
            
            // VertexData 를 생성합니다.
            while(sourceIndex < sourceEnd)
            {
                var x:Number = spriteVertexData[sourceIndex++];
                var y:Number = spriteVertexData[sourceIndex++];
                var z:Number = spriteVertexData[sourceIndex++];
                
                vertexData[targetIndex++] =   spriteMatrixRawData[0] * x + spriteMatrixRawData[1] * y + spriteMatrixRawData[2] * z + sprite.modelMatrix.position.x ;         // x
                vertexData[targetIndex++] =   spriteMatrixRawData[4] * x + spriteMatrixRawData[5] * y + spriteMatrixRawData[6] * z + sprite.modelMatrix.position.y;         // y
                vertexData[targetIndex++] =   spriteMatrixRawData[8] * x + spriteMatrixRawData[9] * y + spriteMatrixRawData[10] * z + sprite.modelMatrix.position.z;       // z
                
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // u 
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // v
                
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // r
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // g
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // b
                vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // a
            }
            
            // IndexData 를 생성합니다.
            for(var i:uint=_sprites.length; i<_sprites.length+1; ++i)
            {
                indexData.push(0 + i * VERTEX_COUNT);  
                indexData.push(1 + i * VERTEX_COUNT);
                indexData.push(2 + i * VERTEX_COUNT);
                indexData.push(0 + i * VERTEX_COUNT);
                indexData.push(2 + i * VERTEX_COUNT);
                indexData.push(3 + i * VERTEX_COUNT);
            }
            
            _sprites.push(sprite);
            _updateRequired = true;
        }
        
        /**
         * BatchSprite 를 출력합니다. 
         */
        public function draw():void
        {
            if( _sprites.length == 0 )
                return;
            
            if( _updateRequired )
                updateBuffers();
            
            updateSpriteMatrix();
            
            var context:Context3D = StageContext.instance.context;
            
            context.setTextureAt(0, this.texture);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            
            var mat:Matrix3D = new Matrix3D();
            mat.identity();
            mat.append(StageContext.instance.viewMatrix);
            mat.append(StageContext.instance.projectionMatrix);
            
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mat, true);
            
            context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);       // position
            context.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);      // tex coord
            context.setVertexBufferAt(2, vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);      // vertex rgba
            
            context.drawTriangles(indexBuffer, 0, _sprites.length * 2);
            
            GameStatus.instance.increaseDrawCallCount();
        }
        
        /**
         * 새로운 스프라이트를 추가하였을 때 버퍼를 갱신합니다. 
         */
        private function updateBuffers():void
        {
            destroyBuffers();
            
            var numVertices:int = vertexData.length;
            var numIndices:int = indexData.length;
            var context:Context3D = StageContext.instance.context;
            
            if (numVertices == 0) 
                return;
            
            vertexBuffer = context.createVertexBuffer(numVertices/DATAS_PER_VERTEX, DATAS_PER_VERTEX);
            vertexBuffer.uploadFromVector(vertexData, 0, numVertices/DATAS_PER_VERTEX);
            
            indexBuffer = context.createIndexBuffer(numIndices);
            indexBuffer.uploadFromVector(indexData, 0, numIndices);
            
            _updateRequired = false;
        }
        
        /**
         * 버퍼를 삭제합니다. 
         */
        private function destroyBuffers():void
        {
            if (vertexBuffer)
            {
                vertexBuffer.dispose();
                vertexBuffer = null;
            }
            
            if (indexBuffer)
            {
                indexBuffer.dispose();
                indexBuffer = null;
            }
        }
        
        private function updateSpriteMatrix():void
        {
            for(var i:uint=0; i<_sprites.length; ++i)
            {
                var sprite:STSprite = _sprites[i];
                
                sprite.update();
                
                var spriteMatrixRawData:Vector.<Number> = sprite.modelMatrix.rawData;
                var spriteVertexData:Vector.<Number> = sprite.vertexData;
                
                var targetIndex:int = i * VERTEX_COUNT * DATAS_PER_VERTEX;
                var sourceIndex:int = 0;
                var sourceEnd:int = VERTEX_COUNT * DATAS_PER_VERTEX;
                
                while(sourceIndex < sourceEnd)
                {
                    var x:Number = spriteVertexData[sourceIndex++];
                    var y:Number = spriteVertexData[sourceIndex++];
                    var z:Number = spriteVertexData[sourceIndex++];
                    
                    vertexData[targetIndex++] =   spriteMatrixRawData[0] * x + spriteMatrixRawData[1] * y + spriteMatrixRawData[2] * z + sprite.modelMatrix.position.x ;         // x
                    vertexData[targetIndex++] =   spriteMatrixRawData[4] * x + spriteMatrixRawData[5] * y + spriteMatrixRawData[6] * z + sprite.modelMatrix.position.y;         // y
                    vertexData[targetIndex++] =   spriteMatrixRawData[8] * x + spriteMatrixRawData[9] * y + spriteMatrixRawData[10] * z + sprite.modelMatrix.position.z;       // z
                    
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // u 
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // v
                    
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // r
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // g
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // b
                    vertexData[targetIndex++] = spriteVertexData[sourceIndex++];   // a
                }
            }
            
            var numVertices:int = vertexData.length;
            vertexBuffer.uploadFromVector(vertexData, 0, numVertices/DATAS_PER_VERTEX);
            
        }
        
    }
}