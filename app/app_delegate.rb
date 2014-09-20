class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    @win_controller = SceneWindowController.alloc.init
    @win_controller.showWindow self
    start_server
    start_timer
  end
  
  def start_timer
    timer = EM.add_periodic_timer 0.001 do
      publish
   end
  end
  
  def start_server
    @view = @win_controller.viewController.view
    @width = @view.frame.size.width
    @height = @view.frame.size.height
    
    #setup the syphon server and set the GLView as the context. I'm not sure this is the correct context. Perhaps it doesn't need to be set.
		@attrs			  = Pointer.new_with_type('I', 11)
		@attrs[0]		= NSOpenGLPFADoubleBuffer
		@attrs[1]		= NSOpenGLPFAAccelerated
		@attrs[2]		= NSOpenGLPFADepthSize
		@attrs[3]		= 24
		@attrs[4]		= NSOpenGLPFAMultisample
		@attrs[5]		= NSOpenGLPFASampleBuffers
		@attrs[6]		= NSOpenGLPFAColorSize
		@attrs[7]		= 1
		@attrs[8]		= NSOpenGLPFASamples
		@attrs[9]		= 4
		@attrs[10]	  = 0

    
    @pf = NSOpenGLPixelFormat.alloc.initWithAttributes(@attrs)
    
    @glContext = NSOpenGLContext.alloc.initWithFormat(@pf, shareContext:nil)
    @glContext.makeCurrentContext

    @syphonServer = ServerEOS.alloc.createSyphonServer("test", withContext: @glContext)
  end
  
  def save_image(image)
    
    path = "test.png"
    data = image.representationUsingType(NSPNGFileType, properties: nil)
    data.writeToFile(path, atomically:true)
    p 'wrote'
    
    # texture_from_image
    
  end
  
  
  def publish
    
    # This is the simpliest version. It grabs a full NSImage. It may be the best way but I was trying to find something with less conversions to get to the texture.
    # image = ImageCapture.imageFromSceneKitView(@view, backingScale: NSScreen.mainScreen.backingScaleFactor)
    # save_image(image) #this proves the image is being aquired correctly.
    
    
    # This version is saving directly as an imagerep and then trying to turn it into a CGImage. Trying to turn it into a CGImage is returning NSCFType which is a bad memory pointer from what I can tell.
    
    imageRep = ImageCapture.imageRepFromSceneKitView(@view, backingScale: NSScreen.mainScreen.backingScaleFactor)
    #
    save_image(imageRep)
    # pixelData = imageRep.CGImage
    # p pixelData
    # texture = GLKTextureLoader.textureWithCGImage(pixelData, options:nil, error:nil)
    
    
    
    #This version extracts the whole texture from the objective-C file. (Doesn't work)
    # texture = ImageCapture.textureFromSceneKitView(@view, backingScale: NSScreen.mainScreen.backingScaleFactor)
    
    options = {GLKTextureLoaderOriginBottomLeft => true}
    perror = Pointer.new(:object) 
    
    path = "test.tiff"
    
    texture = GLKTextureLoader.textureWithContentsOfFile(path, options:options, error:perror)
    
    if (texture == nil) 
      puts("Error loading file: %@", perror[0].localizedDescription)
    end
    
    
   
    p texture.width
    if texture

      if @syphonServer.hasClients
        @syphonServer.publishFrameTexture(texture.name,
                        textureTarget: GL_TEXTURE_2D,
                          imageRegion: NSMakeRect(0, 0, texture.width, texture.height),
                    textureDimensions: NSMakeSize(texture.width, texture.height),
                              flipped: true)

      end
    end
  end
  
end
