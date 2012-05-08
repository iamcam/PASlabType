//
//  PASlabText.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/7/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASlabText : NSObject


@property float charAspectRatio;                // 0.44518217
@property int idealLineLength;                  // 12
@property float idealLineAspectRatio;           // charAspectRatio * idealLineLength = 0.44518217 * 12 = 54 

@property int boxWidth;                         // 150px
@property int boxHeight;                        // 200px

@property float idealLineHeight;                // boxWidth / idealLineAspectRatio = 150/5.4218604 = 27.665781
@property int hypotheticalLineCount;            // boxWidth / idealLineHeight = 200/27.665781 = floor(7.2291471) = 7
@property int idealCharCountPerLine;            // charCount / hypotheticalLineCount = 54/7 = round(7.7142857) = 8

@property (nonatomic, retain) NSObject *font;

@property (nonatomic, retain) NSString *sentence;
@property (nonatomic, retain) NSArray *words;
@property (nonatomic, retain) NSMutableArray *lines;

-(id)initWithString:(NSString *)string;
-(void)splitText;

@end
