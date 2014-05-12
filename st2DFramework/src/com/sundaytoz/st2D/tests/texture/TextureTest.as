package com.sundaytoz.st2D.tests.texture
{
    import com.adobe.utils.AGALMiniAssembler;
    import com.adobe.utils.PerspectiveMatrix3D;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.Stage3D;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    
    public class TextureTest extends Sprite
    {
        private const swfWidth:int = 640;
        private const swfHeight:int = 480;
        private const textureSize:int = 512;
        
        // the 3d graphics window on the stage
        private var context3D:Context3D;
        // the compiled shader used to render our mesh
        private var shaderProgram:Program3D;
        // the uploaded vertexes used by our mesh
        private var vertexBuffer:VertexBuffer3D;
        // the uploaded indexes of each vertex of the mesh
        private var indexBuffer:IndexBuffer3D;
        // the data that defines our 3d mesh model
        private var meshVertexData:Vector.<Number>;
        // the indexes that define what data is used by each vertex
        private var meshIndexData:Vector.<uint>;
        // matrices that affect the mesh location and camera angles
        private var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
        private var modelMatrix:Matrix3D = new Matrix3D();
        private var viewMatrix:Matrix3D = new Matrix3D();
        private var modelViewProjection:Matrix3D = new Matrix3D();
        // a simple frame counter used for animation
        private var t:Number = 0;
        
        [Embed (source = "../../utils/res/texture.jpg")] private var myTextureBitmap:Class;
        private var myTextureData:Bitmap = new myTextureBitmap();
        // The Molehill Texture that uses the above myTextureData
        private var myTexture:Texture;
        
        public function TextureTest()
        {  
            if( stage != null )
                init();
            else
                addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(event:Event = null):void
        {
            if( hasEventListener(Event.ADDED_TO_STAGE) )
            {
                removeEventListener(Event.ADDED_TO_STAGE, init);
            }
            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
            stage.stage3Ds[0].requestContext3D();
        }
        
        private function onContext3DCreate(event:Event):void
        {
            // in case it is not the first time this event fired
            removeEventListener(Event.ENTER_FRAME, enterFrame);
            
            // Obtain the current context
            var t:Stage3D = event.target as Stage3D;
            context3D = t.context3D;
            if (context3D == null)
            {
                // Currently no 3d context is available (error!)
                return;
            }
            
            // Disabling error checking will drastically improve performance.
            // If set to true, Flash will send helpful error messages regarding
            // AGAL compilation errors, uninitialized program constants, etc.
            context3D.enableErrorChecking = true;
            // Initialize our mesh data
            initData();
            
            // The 3d back buffer size is in pixels
            context3D.configureBackBuffer(swfWidth, swfHeight, 0, true);
            
            // A simple vertex shader which does a 3D transformation
            var vertexShaderAssembler:AGALMiniAssembler =
                new AGALMiniAssembler();
            vertexShaderAssembler.assemble
                (
                    Context3DProgramType.VERTEX,
                    // 4x4 matrix multiply to get camera angle
                    "m44 op, va0, vc0\n" +
                    // tell fragment shader about XYZ
                    "mov v0, va0\n" +
                    // tell fragment shader about UV
                    "mov v1, va1\n"
                );
            
            // A simple fragment shader which will use
            // the vertex position as a color
            var fragmentShaderAssembler:AGALMiniAssembler
            = new AGALMiniAssembler();
            fragmentShaderAssembler.assemble
                (
                    Context3DProgramType.FRAGMENT,
                    // grab the texture color from texture fs0
                    // using the UV coordinates stored in v1
                    "tex ft0, v1, fs0 <2d,repeat,miplinear>\n" +
                    // move this value to the output color
                    "mov oc, ft0\n"
                );
            
            // combine shaders into a program which we then upload to the GPU
            shaderProgram = context3D.createProgram();
            shaderProgram.upload(vertexShaderAssembler.agalcode,
                fragmentShaderAssembler.agalcode);
            
            // upload the mesh indexes
            indexBuffer = context3D.createIndexBuffer(meshIndexData.length);
            indexBuffer.uploadFromVector(meshIndexData, 0, meshIndexData.length);
            
            // upload the mesh vertex data
            // since our particular data is
            // x, y, z, u, v, nx, ny, nz
            // each vertex uses 8 array elements
            vertexBuffer = context3D.createVertexBuffer(
                meshVertexData.length/8, 8);
            vertexBuffer.uploadFromVector(meshVertexData, 0,
                meshVertexData.length/8);
            
            // Generate mipmaps
            myTexture = context3D.createTexture(textureSize, textureSize, Context3DTextureFormat.BGRA, false);
            
            var ws:int = myTextureData.bitmapData.width;
            var hs:int = myTextureData.bitmapData.height;
            var level:int = 0; 
            var tmp:BitmapData;
            var transform:Matrix = new Matrix();
            tmp = new BitmapData(ws, hs, true, 0x00000000);
            
            while ( ws >= 1 && hs >= 1 ) {
                tmp.draw(myTextureData.bitmapData, transform, null, null, null, true);
                myTexture.uploadFromBitmapData(tmp, level);
                transform.scale(0.5, 0.5); 
                level++; 
                ws >>= 1;
                hs >>= 1;
                
                if (hs && ws) {
                    tmp.dispose();
                    tmp = new BitmapData(ws, hs, true, 0x00000000);
                }
            }
            tmp.dispose();
            // create projection matrix for our 3D scene
            projectionMatrix.identity();
            // 45 degrees FOV, 640/480 aspect ratio, 0.1=near, 100=far
            projectionMatrix.perspectiveFieldOfViewRH(
                45.0, swfWidth / swfHeight, 0.01, 100.0);
            // create a matrix that defines the camera location
            viewMatrix.identity();
            // move the camera back a little so we can see the mesh
            viewMatrix.appendTranslation(0,0,-4);
            // start animating
            addEventListener(Event.ENTER_FRAME,enterFrame);
        }
        
        private function enterFrame(e:Event):void
        {
            // clear scene before rendering is mandatory
            context3D.clear(0,0,0);
            context3D.setProgram ( shaderProgram );
        
            // create the various transformation matrices
            modelMatrix.identity();
            modelMatrix.appendRotation(t*0.7, Vector3D.Y_AXIS);
            modelMatrix.appendRotation(t*0.6, Vector3D.X_AXIS);
            modelMatrix.appendRotation(t*1.0, Vector3D.Y_AXIS);
            modelMatrix.appendTranslation(0.0, 0.0, 0.0);
            modelMatrix.appendRotation(90.0, Vector3D.X_AXIS);
            // rotate more next frame
            t += 2.0;
            // clear the matrix and append new angles
            modelViewProjection.identity();
            modelViewProjection.append(modelMatrix);
            modelViewProjection.append(viewMatrix);
            modelViewProjection.append(projectionMatrix);
            // pass our matrix data to the shader program
            context3D.setProgramConstantsFromMatrix(
                Context3DProgramType.VERTEX,
                0, modelViewProjection, true );
            
            // associate the vertex data with current shader program
            // position
            context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            // tex coord
            context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
            // which texture should we use?
          
            context3D.setTextureAt(0, myTexture);
            // finally draw the triangles
            context3D.drawTriangles(indexBuffer, 0, meshIndexData.length/3);
            // present/flip back buffer
            context3D.present();
        }
            
        private function initData():void
        {
            // Defines which vertex is used for each polygon
            // In this example a square is made from two triangles
            meshIndexData = Vector.<uint>
                ([
                    0, 1, 2, 0, 2, 3,
                ]);
            // Raw data used for each of the 4 vertexes
            // Position XYZ, texture coordinate UV, normal XYZ
            meshVertexData = Vector.<Number>
                ( [
                    //X, Y, Z, U, V, nX, nY, nZ
                    -1, -1, 1, 0, 0, 0, 0, 1,
                    1, -1, 1, 1, 0, 0, 0, 1,
                    1, 1, 1, 1, 1, 0, 0, 1,
                    -1, 1, 1, 0, 1, 0, 0, 1
                ]);
        }
        
        
    }
}