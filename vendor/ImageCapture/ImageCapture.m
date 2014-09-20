
#import "ImageCapture.h"

@implementation ImageCapture


+ (void)takeShot
{
    // NSString* path = @"test.tiff";
    // NSImage* image = [self imageFromSceneKitView:self.scene];
    // BOOL didWrite = [[image TIFFRepresentation] writeToFile:path atomically:YES];
    // NSLog(@"Did write:%d", didWrite);
}

+ (void)test
{
	NSLog(@"this works?");
}

+ (NSImage*)imageFromSceneKitView:(SCNView*)sceneKitView backingScale:(int)scale
{
    NSInteger width = sceneKitView.bounds.size.width * scale; //* self.scene.window.backingScaleFactor;
    NSInteger height = sceneKitView.bounds.size.height * scale; //* self.scene.window.backingScaleFactor;
    NSBitmapImageRep* imageRep=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                       pixelsWide:width
                                                                       pixelsHigh:height
                                                                    bitsPerSample:8
                                                                  samplesPerPixel:4
                                                                         hasAlpha:YES
                                                                         isPlanar:NO
                                                                   colorSpaceName:NSCalibratedRGBColorSpace
                                                                      bytesPerRow:width*4
                                                                     bitsPerPixel:4*8];
    [[sceneKitView openGLContext] makeCurrentContext];
    glReadPixels(0, 0, (int)width, (int)height, GL_RGBA, GL_UNSIGNED_BYTE, [imageRep bitmapData]);
	
	// return imageRep;
	

    [NSOpenGLContext clearCurrentContext];
    NSImage* outputImage = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
    [outputImage addRepresentation:imageRep];
    NSImage* flippedImage = [NSImage imageWithSize:NSMakeSize(width, height) flipped:YES drawingHandler:^BOOL(NSRect dstRect) {
        [imageRep drawInRect:dstRect];
        return YES;
    }];
    return flippedImage;
}
	
+ (NSBitmapImageRep*)imageRepFromSceneKitView:(SCNView*)sceneKitView backingScale:(int)scale
{
    NSInteger width = sceneKitView.bounds.size.width * scale; //* self.scene.window.backingScaleFactor;
    NSInteger height = sceneKitView.bounds.size.height * scale; //* self.scene.window.backingScaleFactor;
    NSBitmapImageRep* imageRep=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                       pixelsWide:width
                                                                       pixelsHigh:height
                                                                    bitsPerSample:8
                                                                  samplesPerPixel:4
                                                                         hasAlpha:YES
                                                                         isPlanar:NO
                                                                   colorSpaceName:NSCalibratedRGBColorSpace
                                                                      bytesPerRow:width*4
                                                                     bitsPerPixel:4*8];
    [[sceneKitView openGLContext] makeCurrentContext];
    glReadPixels(0, 0, (int)width, (int)height, GL_RGBA, GL_UNSIGNED_BYTE, [imageRep bitmapData]);
	
	return imageRep;
	
}


+ (GLKTextureInfo*)textureFromSceneKitView:(SCNView*)sceneKitView backingScale:(int)scale
{
    NSInteger width = sceneKitView.bounds.size.width * scale; //* self.scene.window.backingScaleFactor;
    NSInteger height = sceneKitView.bounds.size.height * scale; //* self.scene.window.backingScaleFactor;
    NSBitmapImageRep* imageRep=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                       pixelsWide:width
                                                                       pixelsHigh:height
                                                                    bitsPerSample:8
                                                                  samplesPerPixel:4
                                                                         hasAlpha:YES
                                                                         isPlanar:NO
                                                                   colorSpaceName:NSCalibratedRGBColorSpace
                                                                      bytesPerRow:width*4
                                                                     bitsPerPixel:4*8];
    [[sceneKitView openGLContext] makeCurrentContext];
    glReadPixels(0, 0, (int)width, (int)height, GL_RGBA, GL_UNSIGNED_BYTE, [imageRep bitmapData]);
    [NSOpenGLContext clearCurrentContext];

	CGImageRef pixelData = [imageRep CGImage];
	// NSLog(@"cgiimageref: %i", pixelData);
		

	// CGContextRef gtx = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
	// CGContextDrawImage(gtx, CGRectMake(0, 0, width, height), pixelData);
	// CGContextFlush(gtx);

	GLKTextureInfo* texture = [GLKTextureLoader textureWithCGImage:pixelData options:NULL error:NULL];

	NSLog(@"texture: %i %ix%i", texture.name, texture.width, texture.height);
	
	return texture;
	
}
	


@end