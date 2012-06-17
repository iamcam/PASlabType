//
//  PASlabFont.m
//  PA SlabType Demo
//
//  Created by Cameron Perry on 6/16/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import "PASlabFont.h"
#import "PASlabFontChunkFive.h"

@implementation PASlabFont
@synthesize fontName;

-(id) init {
    if(!(self = [super init])){
        return nil;
    }
    
    //any other init code?
    
    return self;
}

-(void) saySomething{
    NSLog(@"Something (Regular)");
}
@end
