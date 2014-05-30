//
//  backgroundDesignViewController.h
//  phoneNumbers
//
//  Created by Avik Bag on 4/30/14.
//  Copyright (c) 2014 engr103. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface backgroundDesignViewController : NSObject

+ (UIImage*) blur : (float) blurVal withImage:(UIImage*) backgroundImg;
@end
