//
//  PASlabText.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/7/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface PASlabText : UIView


@property (readwrite, assign) float charAspectRatio;                // 0.44518217
@property (readwrite, assign) int idealLineLength;                  // 12
@property (readwrite, assign) float idealLineAspectRatio;           // charAspectRatio * idealLineLength = 0.44518217 * 12 = 54 

@property (readwrite, assign) float boxWidth;                         // 150px
@property (readwrite, assign) float boxHeight;                        // 200px

@property (readwrite, assign) float idealLineHeight;                // boxWidth / idealLineAspectRatio = 150/5.4218604 = 27.665781
@property (readwrite, assign) int hypotheticalLineCount;            // boxWidth / idealLineHeight = 200/27.665781 = floor(7.2291471) = 7
@property (readwrite, assign) int idealCharCountPerLine;            // charCount / hypotheticalLineCount = 54/7 = round(7.7142857) = 8

@property (nonatomic, retain) NSString *sentence;
@property (nonatomic, retain) NSArray *words;
@property (nonatomic, retain) NSMutableArray *lines;


@property (nonatomic, retain) NSString *font;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *strokeColor;
@property (readwrite, assign) float strokeWidth;

@property (nonatomic, retain) NSArray *fontChoices;

-(void)splitTextInString: (NSString *)string;
-(NSAttributedString *)formatLinesForLayout;
-(NSAttributedString *)sizeLineToFit:(NSString *)line;

@end
