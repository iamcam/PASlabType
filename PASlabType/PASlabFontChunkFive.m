//
//  PASlabFontChunkFive.m
//  PA SlabType Demo
//
//  Created by Cameron Perry on 6/16/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import "PASlabFontChunkFive.h"

@implementation PASlabFontChunkFive

-(id) init{
    if(!(self=[super init])){
        return nil;
    }
    
    //autoload some options
    
    return self;
}

-(void)saySomething{
    [super saySomething];
    NSLog(@"Chunk5");
}
@end
