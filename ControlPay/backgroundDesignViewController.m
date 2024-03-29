//
//  backgroundDesignViewController.m
//  phoneNumbers
//
//  Created by Avik Bag on 4/30/14.
//  Copyright (c) 2014 engr103. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "backgroundDesignViewController.h"

@interface backgroundDesignViewController ()

@end

@implementation backgroundDesignViewController

// The Gaussian Blur with no accelerated framework
+ (UIImage*)blur : (float) blurVal withImage:(UIImage*) backgroundImg
 {
 // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)[
 UIImage * theImage = [self reOrientIfNeeded:backgroundImg];
 
 // create our blurred image
 CIContext *context = [CIContext contextWithOptions:nil];
 CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
 
 // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
 CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
 [filter setValue:inputImage forKey:kCIInputImageKey];
 [filter setValue:[NSNumber numberWithFloat:blurVal] forKey:@"inputRadius"];
 CIImage *result = [filter valueForKey:kCIOutputImageKey];
 
 // CIGaussianBlur has a tendency to shrink the image a little,
 // this ensures it matches up exactly to the bounds of our original image
 CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
 
 UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
 CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
 
 //return returnImage;
 
 // *************** if you need scaling
 return [[self class] scaleIfNeeded:cgImage];
 }
 
 +(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
 bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
 if (isRetina) {
 return [UIImage imageWithCGImage:cgimg scale:6.0 orientation:UIImageOrientationUp];
 } else {
 return [UIImage imageWithCGImage:cgimg];
 }
 }

+ (UIImage*) reOrientIfNeeded:(UIImage*)theImage{
    
    if (theImage.imageOrientation != UIImageOrientationUp) {
        
        CGAffineTransform reOrient = CGAffineTransformIdentity;
        switch (theImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, M_PI);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformRotate(reOrient, M_PI_2);
                break;
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, 0, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, -M_PI_2);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
        }
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.height, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                break;
        }
        
        CGContextRef myContext = CGBitmapContextCreate(NULL, theImage.size.width, theImage.size.height, CGImageGetBitsPerComponent(theImage.CGImage), 0, CGImageGetColorSpace(theImage.CGImage), CGImageGetBitmapInfo(theImage.CGImage));
        
        CGContextConcatCTM(myContext, reOrient);
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.height,theImage.size.width), theImage.CGImage);
                break;
                
            default:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.width,theImage.size.height), theImage.CGImage);
                break;
        }
        
        CGImageRef CGImg = CGBitmapContextCreateImage(myContext);
        theImage = [UIImage imageWithCGImage:CGImg];
        
        CGImageRelease(CGImg);
        CGContextRelease(myContext);
    }
    
    return theImage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
