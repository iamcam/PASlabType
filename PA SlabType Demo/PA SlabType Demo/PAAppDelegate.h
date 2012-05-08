//
//  PAAppDelegate.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/3/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PASlabText.h"


@interface PAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) PASlabText *slab;

@end
