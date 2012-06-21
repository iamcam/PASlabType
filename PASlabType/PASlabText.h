//
//  PASlabText.h
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/7/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "PAFonts.h"

@protocol PASlabTextDelegate

@optional
-(void)textBoundsDidChangeWithFrame: (CGRect)frame;

@end

@interface PASlabText : UIView
@property (nonatomic, weak) id <PASlabTextDelegate> delegate;

@property (readwrite, assign) float charAspectRatio;                // 0.44518217
@property (readwrite, assign) int idealLineLength;                  // 12
@property (readwrite, assign) float idealLineAspectRatio;           // charAspectRatio * idealLineLength = 0.44518217 * 12 = 54 

@property (readwrite, assign) float boxWidth;                         // 150px
@property (readwrite, assign) float boxHeight;                        // 200px

@property (readwrite, assign) float idealLineHeight;                // boxWidth / idealLineAspectRatio = 150/5.4218604 = 27.665781
@property (readwrite, assign) int hypotheticalLineCount;            // boxWidth / idealLineHeight = 200/27.665781 = floor(7.2291471) = 7
@property (readwrite, assign) int idealCharCountPerLine;            // charCount / hypotheticalLineCount = 54/7 = round(7.7142857) = 8

@property (readwrite, assign) int manualCharCountPerLine;

@property (nonatomic, strong) NSString *sentence;
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray *lineInfo;
@property (nonatomic, strong) NSMutableString *overflow;

//@property (nonatomic, retain) NSString *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *strokeColor;
@property (readwrite, assign) float strokeWidth;

@property (nonatomic, strong) NSArray *fontChoices;
@property (nonatomic, strong) NSMutableDictionary *selectedFontDict;
@property (nonatomic, strong) PASlabFont *font;


-(void)splitTextInString: (NSString *)string;
-(NSAttributedString *)formatLinesForLayout;
-(NSAttributedString *)sizeLineToFit:(NSString *)line;
-(void)selectFontWithName: (NSString *)name;
-(float)textHeight;

-(void) clearText;
@end
