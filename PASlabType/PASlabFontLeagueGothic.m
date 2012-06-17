//
//  PASlabFontLeagueGothic.m
//  PA SlabType Demo
//
//  Created by Cameron Perry on 6/16/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import "PASlabFontLeagueGothic.h"

@implementation PASlabFontLeagueGothic

-(id) init{
    if(!(self=[super init])){
        return nil;
    }
    return self;
}

-(float) lineHeightUsingScale:(float)scale ascent:(float)ascent descent:(float)descent leading:(float)leading previousDescent:(float)previousDescent{
    return (ascent + descent/3) * scale - previousDescent * 0.75;
}


@end
