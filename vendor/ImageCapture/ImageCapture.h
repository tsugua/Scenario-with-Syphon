#import <OpenGL/gl.h>
#import <GLKit/GLKit.h>
#import <SceneKit/SceneKit.h>

@interface ImageCapture : NSObject

+ (void)takeShot;
+ (NSImage*)imageFromSceneKitView:(SCNView*)sceneKitView backingScale:(int)scale;
+ (NSBitmapImageRep*)imageRepFromSceneKitView:(SCNView*)sceneKitView backingScale:(int)scale;
+ (GLKTextureInfo*)textureFromSceneKitView:(SCNView*)sceneKitView backingScale:(int)scale;


+ (void)test;
	
@end