//
//  PASlabFont.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 6/16/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASlabFont : NSObject{
    NSString *fontName;
}

@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, readwrite) float charAspectRatio;
@property (nonatomic, readwrite) int idealCharCountPerLine;

-(id) init;
-(id) initWithFontName:(NSString *)name;
-(void) saySomething;
-(float) lineHeightUsingScale:(float)scale ascent:(float)ascent descent:(float)descent previousDescent:(float)previousDescent;
-(float) lineHeightUsingScale:(float)scale ascent:(float)ascent descent:(float)descent leading:(float)leading previousDescent:(float)previousDescent;


@end
