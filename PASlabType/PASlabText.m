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
@synthesize sentence, words, lines;
@synthesize font, color, strokeColor, strokeWidth;
@synthesize fontChoices;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        // Setting the dimensions of our drawing box
        boxWidth = self.frame.size.width;
        boxHeight = self.frame.size.height;
        
        if(!fontChoices){
            fontChoices = [NSArray  arrayWithObjects:@"Arial",@"AmericanTypewriter", @"Arial-RoundedMTBold",@"Futura-Medium", @"HelveticaNeueu-Light", @"Verdana" , nil];
            color = [UIColor redColor];
            strokeColor = [UIColor blueColor];
            strokeWidth = 0.0f;
            font = [NSString stringWithFormat:@"Arial"];
        }
    }
    return self;
}

/**
 This function is a stripped-down AS3 -> ObjC port of the slabtype
 algorithm by Eric Loyer with many of the original comments left intact [1].
 Additional help and clarification from the slabText jQuery plugin by @freqdec[2]
 [1] http://erikloyer.com/index.php/blog/the_slabtype_algorithm_part_1_background/                         
 [2] https://github.com/freqdec/slabText

 **/
-(void) splitTextInString: (NSString *)string {
    sentence = string;
    
    NSLog(@"This is the init: %@", sentence);
    
    // These two are interchangeable for now, but idealCharCountPerLine is a perferred calculation
    idealLineLength = 12;
    
//    charAspectRatio = 0.44518217f; //on a per-font basis
    charAspectRatio = 0.3749f;
    idealLineAspectRatio = charAspectRatio * idealLineLength; // 0.44518217 * 12 = 5.4218604
    

    
    idealLineHeight = boxWidth / idealLineAspectRatio;
    hypotheticalLineCount = floor(boxHeight / idealLineHeight);
    
    idealCharCountPerLine = (int)round([string length]/hypotheticalLineCount);

    NSLog(@"idealLineLength: %d",idealLineLength);
    NSLog(@"charAspectRatio: %f", charAspectRatio);
    NSLog(@"idealLineAspectRatio: %f", idealLineAspectRatio);
    NSLog(@"idealLineHeight: %f",idealLineHeight);
    NSLog(@"hypotheticalLineCount: %d",hypotheticalLineCount);
    NSLog(@"idealCharCountPerLine: %d",idealCharCountPerLine);

    if (words == NULL) {
        words = [NSMutableArray arrayWithCapacity:0];
    }
    if(!lines){
        lines = [[NSMutableArray alloc] initWithCapacity:0];
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


    // while we still have words left, build the next line
    while( wordIndex < wc){

        [postText setString:@""];
        
        // build two strings (preText and postText) word by word, with one
        // string always one word behind the other, until 
        // the length of one string is less than the ideal number of characters
        // per line, while the length of the other is greater than that ideal
        while([postText length] < idealCharCountPerLine){
            [preText setString: postText];

            if([postText length]){ //prepend a space
                [postText appendFormat:@" %@", [words objectAtIndex:wordIndex]];
            } else {
                [postText setString:[words objectAtIndex:wordIndex]];
            }
            wordIndex++;
            if (wordIndex >= wc){
                break;
            }
        }
        
        // calculate the character difference between the two strings and the
        // ideal number of characters per line 
        // Added: Removed the extra whitespace that was present in the origian length calculations
        preDiff = idealCharCountPerLine - ([preText length]-1);
        postDiff = ([postText length]-1) - idealCharCountPerLine;
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

        
        [lines addObject: [NSString stringWithFormat:@"%@",finalText]];

    }
    NSLog(@"%@",lines);

    
//    [self drawRect: CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
 
    [self setOpaque:YES];
    [self setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];

}


-(NSAttributedString*)attrStringFromMarkup: (NSString *)markup {
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)[fontChoices objectAtIndex:1], 20.0f, NULL);
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id) self.color.CGColor, kCTForegroundColorAttributeName,
                           (__bridge id) fontRef, kCTFontAttributeName,
                           (id) self.strokeColor.CGColor, kCTStrokeColorAttributeName,
                           (id) [NSNumber numberWithInt:self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
    [aString appendAttributedString:[[NSAttributedString alloc] initWithString:markup attributes:attrs] ];
    return aString;
}
/**
 Line-by-line format to fit within the given bounds
 **/
-(NSAttributedString *)formatLinesForLayout {
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:@""];
//    NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    int lc = [lines count];
    float fontSize = 12.0f;    
    float newFontSize = 12.0f;
    for( int ii = 0; ii < lc; ii++){
        NSString *line = [NSString stringWithFormat:@"%@\n",[lines objectAtIndex:ii]];
        
        // Get a line.
        // Figure out how big the line is (width).
        // Set the size accordingly
        // Append to finalString

        CGSize size = [line sizeWithFont:[UIFont fontWithName:[fontChoices objectAtIndex:1] size:fontSize]];
        float scale = boxWidth/ size.width;
        newFontSize = fontSize * scale;
        CGSize newSize = [line sizeWithFont:[UIFont fontWithName:[fontChoices objectAtIndex:1] size:newFontSize]];
        NSLog(@"%f - %f = %f", boxWidth, newSize.width, (boxWidth-newSize.width));
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)[fontChoices objectAtIndex:1], newFontSize, NULL);
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id) self.color.CGColor, kCTForegroundColorAttributeName,
                               (__bridge id) fontRef, kCTFontAttributeName,
                               (id) self.strokeColor.CGColor, kCTStrokeColorAttributeName,
                               (id) [NSNumber numberWithInt:self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                               nil];
        NSAttributedString *tmpString = [[NSAttributedString alloc] initWithString:line attributes:attrs];
        [finalString appendAttributedString:tmpString];

    }
    
    
    return finalString;
}

//NOTE : Cannot call drawRect directly
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
//    NSAttributedString* attString = [[NSAttributedString alloc]
//                                      initWithString:[lines componentsJoinedByString:@"\n"]] ;     
//    NSAttributedString *attString = [self attrStringFromMarkup:[lines componentsJoinedByString:@"\n"]];
    NSAttributedString *attString = [self formatLinesForLayout];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString); //3
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context); //4
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
}




@end



