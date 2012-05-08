//
//  PASlabText.m
//  PA SlabType Demo
//
//  Created by Cameron Perry on 5/7/12.
//  Copyright (c) 2012 Pivotal Action, Inc. All rights reserved.
//  
// Based off of the SlabType algorithm by Eric Loyer.
// http://erikloyer.com/index.php/blog/the_slabtype_algorithm_part_1_background/  

#import "PASlabText.h"

@implementation PASlabText

@synthesize charAspectRatio, idealLineLength, idealLineAspectRatio, boxWidth, boxHeight, idealLineHeight, hypotheticalLineCount, idealCharCountPerLine;
@synthesize font, sentence, words, lines;

-(id)initWithString:(NSString *)string {
    self = [super init];
    sentence = string;
    idealCharCountPerLine = 8;
    
    NSLog(@"This is the init: %@", sentence);
    return self;
}


/**
 This function is a stripped-down AS3 -> ObjC port of the slabtype
 algorithm by Eric Loyer with many of the original comments left intact [1].
 Additional help and clarification from the slabText jQuery plugin by @freqdec[2]
 [1] http://erikloyer.com/index.php/blog/the_slabtype_algorithm_part_1_background/                         
 [2] https://github.com/freqdec/slabText

 **/
-(void) splitText{
    if (words == NULL) {
        words = [NSMutableArray arrayWithCapacity:0];
    }

    // segment the text into lines 
    words =  [sentence componentsSeparatedByString:@" "];

    int wordIndex = 0;
    int wc = [words count];
    int preDiff = 0;
    int postDiff = 0;
    
    NSMutableString *preText = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *postText = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *finalText = [[NSMutableString alloc] initWithString:@""];
    lines = [[NSMutableArray alloc] initWithCapacity:0];
    
    // while we still have words left, build the next line
    while( wordIndex < wc){

        [postText setString:@""];
        
        // build two strings (preText and postText) word by word, with one
        // string always one word behind the other, until 
        // the length of one string is less than the ideal number of characters
        // per line, while the length of the other is greater than that ideal
        while([postText length] < idealCharCountPerLine){
            [preText setString: postText];
            [postText appendFormat:@"%@ ", [words objectAtIndex:wordIndex]];
            wordIndex++;
            if (wordIndex >= wc){
                break;
            }
        }
        
        // calculate the character difference between the two strings and the
        // ideal number of characters per line 
        preDiff = idealCharCountPerLine - [preText length];
        postDiff = [postText length] - idealCharCountPerLine;
       // NSLog(@"[%d] %@(%d)(%d) : %@(%d)(%d)",idealCharCountPerLine, preText, [preText length], preDiff,postText, [postText length], postDiff);
        
        // if the smaller string is closer to the length of the ideal than
        // the longer string, and doesn’t contain just a single space, then
        // use that one for the line 
        if( (preDiff < postDiff) && ([preText length] > 2)){
            [finalText setString:preText];
            wordIndex--;

        // otherwise, use the longer string for the line
        } else {
            [finalText setString:postText];
        }

        
        [lines addObject: [NSString stringWithFormat:@"%@",[finalText substringToIndex:([finalText length]-1)]]];

    }
    NSLog(@"%@",lines);
    
}

@end
