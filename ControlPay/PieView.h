//
//  PieView.h
//  PieChart
//
//  Created by Pavan Podila on 2/21/12.
//  Copyright (c) 2012 Pixel-in-Gene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView

@property (nonatomic, strong) NSArray *sliceValues;
@property (nonatomic, strong) NSArray *pieColors;

-(id)initWithSliceValues:(NSArray *)sliceValues;
@end
