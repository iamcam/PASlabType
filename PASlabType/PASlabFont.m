//
//  PASlabFont.m
//  PA SlabType Demo
//
//  Created by Cameron Perry on 6/16/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import "PASlabFont.h"


@implementation PASlabFont
@synthesize fontName;

/*
 * Default init - pretty much only if a font was selected for which we have no class
 * This would be an oopsie, but at lease it wouldn't crash it all
 */
-(id) init {
    if(!(self = [super init])){
        return nil;
    }
    //Return the system default
    fontName = [[UIFont systemFontOfSize:6.0] fontName];
    NSLog(@"Setting default system font: %@", fontName);
    //any other init code?
    return self;
}

-(id) initWithFontName:(NSString *)name {
    NSString *tmpName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *className= [NSString stringWithFormat:@"PASlabFont%@", tmpName];
    NSLog(@"Font Class Name: %@", className);
    
    id fontObj = [[NSClassFromString(className) alloc] init];

    if(!fontObj){
        return [self init];
    }
    [fontObj setFontName: name];

    return fontObj;

}

/*
 * In many cases it's easiest to assume a simple formula here will work, but some fonts are better with slight
 * tweaks to the calculation. Override as necessary
 * @ascent font's ascent (baseline to top of line)
 * @descent the font's descent (baseline to bottom of line)
 * @leading the font's leading (usualy 0.0)
 * @previousDescent the previous line's descent
 * // Other Options:
 * // ascent * scale; //first version. Doesn't seem to work well with Helvetica
 * // ascent*scale + descent*scale - previousDescent;
 */
-(float) lineHeightUsingScale:(float)scale ascent:(float)ascent descent:(float)descent leading:(float)leading previousDescent:(float)previousDescent{
    return scale * (ascent + descent + leading);

}

/**
 * Leading seems to be 0.00 most of the time, so this is a bit of a shortcut if we want to take it.
 */

-(float) lineHeightUsingScale:(float)scale ascent:(float)ascent descent:(float)descent previousDescent:(float)previousDescent{
    return [self lineHeightUsingScale:scale ascent:ascent descent:descent leading:0.0 previousDescent:previousDescent];
}


-(void) saySomething{
    NSLog(@"Something (Regular)");
}
@end
