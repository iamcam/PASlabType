//
//  PASlabFont.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 6/16/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASlabFont : NSObject

@property (nonatomic, retain) NSString *fontName;

-(id) init;
-(void) saySomething;

@end
