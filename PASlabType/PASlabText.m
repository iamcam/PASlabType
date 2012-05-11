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
@synthesize manualCharCountPerLine; // TODO: probably won't stay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        // Setting the dimensions of our drawing box
        boxWidth = self.frame.size.width;
        boxHeight = self.frame.size.height;
        [self setOpaque:NO];
        [self setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.15]];
        

        if(!fontChoices){
            //Optional choices: @"Ostrich Sans Black",@"Ostrich Sans Bold"
            fontChoices = [NSArray  arrayWithObjects:@"Raleway-Thin",@"League Gothic",@"League Script Thin",@"Ostrich Sans Rounded",@"ChunkFive", nil];
            color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85];
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
    sentence = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n "];
    
    NSLog(@"This is the init: %@", sentence);
    
    // These two are interchangeable for now, but idealCharCountPerLine is a perferred calculation
    idealLineLength = 10;
    charAspectRatio = 0.5;
//    charAspectRatio = 0.44518217f; //on a per-font basis
//    charAspectRatio = 0.3749f;
    charAspectRatio = 0.324324324f; //League Gothic
    idealLineAspectRatio = charAspectRatio * idealLineLength; // 0.44518217 * 12 = 5.4218604
    

    
    idealLineHeight = boxWidth / idealLineAspectRatio;
    hypotheticalLineCount = floor(boxHeight / idealLineHeight);
    if( hypotheticalLineCount == 0 ) hypotheticalLineCount = 1;
    
    // TODO: will figuring out how many lines we really have do anything to change?
    idealCharCountPerLine = (int)round([string length]/hypotheticalLineCount);
    if(idealCharCountPerLine == 0)
        idealCharCountPerLine = 1;

    if(manualCharCountPerLine > 0){
        idealCharCountPerLine = manualCharCountPerLine;
    }

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
    NSRange range;
    
    // while we still have words left, build the next line
    while( wordIndex < wc){
        NSLog(@"wordIndex: %d\twc: %d\t ptlen:%d\tidealCharCount:%d",wordIndex, wc, [postText length], idealCharCountPerLine);
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

            range = [postText rangeOfString:@"\n" options:NSBackwardsSearch];
            NSLog(@"wordIndex: %d\twc: %d",wordIndex, wc);
            if (wordIndex >= wc || range.length > 0){
                break;
            }
        }
        
        if(range.length){
            [finalText setString:[postText stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        } else {
            // calculate the character difference between the two strings and the
            // ideal number of characters per line 
            // Added: Removed the extra whitespace that was present in the origian length calculations
            preDiff = idealCharCountPerLine - ([preText length]-1);
            postDiff = ([postText length]-1) - idealCharCountPerLine;
            
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
        }

        
        [lines addObject: [NSString stringWithFormat:@"%@",finalText]];

    }
    NSLog(@"%@",lines);    
 
}


/**
 Line-by-line format to fit within the given bounds
 **/
-(NSAttributedString *)formatLinesForLayout {
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    int lc = [lines count];

    for( int ii = 0; ii < lc; ii++){
        NSString *line = [NSString stringWithFormat:@"%@\n",[lines objectAtIndex:ii]];
        
        [finalString appendAttributedString:[self sizeLineToFit:line]];

    }
    
    
    return finalString;
}

-(NSAttributedString *)sizeLineToFit:(NSString *)line {
    float scale = 1.0f;
    float fontSize = 12.0f;    

    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)[fontChoices objectAtIndex:1], (fontSize * scale), NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id) self.color.CGColor, kCTForegroundColorAttributeName,
                           (__bridge id) fontRef, kCTFontAttributeName,
                           (id) self.strokeColor.CGColor, kCTStrokeColorAttributeName,
                           (id) [NSNumber numberWithInt:self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
    NSAttributedString *tmpString = [[NSAttributedString alloc] initWithString:line attributes:attrs];
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) tmpString);
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat lineWidth = CTLineGetTypographicBounds(lineRef, &ascent, &descent, NULL);
    
    float whitespace = CTLineGetTrailingWhitespaceWidth(lineRef);
    float realTextWidth = lineWidth - whitespace;
    scale = self.frame.size.width / realTextWidth;
    
    // http://stackoverflow.com/questions/5312962/line-spacing-and-paragraph-alignment-in-coretext/6056018#6056018
    float spaceBetweenParaghraphs = 0.0f;
    float topSpacing = 0.0f;
    float spaceBetweenLines = 0.0;
    float minLineHeight = ascent * scale; //helps us get real tight
    float maxLineHeight = ascent * scale; //helps us get real tight

    
    CTParagraphStyleSetting theSettings[5] = 
    {
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &spaceBetweenParaghraphs },
        { kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &topSpacing },
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &spaceBetweenLines },
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
    };
    /**
     Touching 
     **/
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, 5);
    
    fontRef = CTFontCreateWithName((__bridge CFStringRef)[fontChoices objectAtIndex:1], (fontSize * scale), NULL);
    attrs = [NSDictionary dictionaryWithObjectsAndKeys:
             (id) self.color.CGColor, kCTForegroundColorAttributeName,
             (__bridge id) fontRef, kCTFontAttributeName,
             (id) self.strokeColor.CGColor, kCTStrokeColorAttributeName,
             (id) [NSNumber numberWithInt:self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
             (__bridge id) paragraphStyle, kCTParagraphStyleAttributeName,
             nil];

    tmpString = [[NSAttributedString alloc] initWithString:line attributes:attrs];
    lineWidth = CTLineGetTypographicBounds(lineRef, &ascent, &descent, NULL);

//    NSLog(@"LineWidth: %f,\twhitespace: %f,\trealTextWidth: %f,\tscale: %f,\tnewTextWidth: %f",lineWidth, whitespace, realTextWidth, scale, realTextWidth*scale);
    NSLog(@"scale: %f\tfont size: %f\tascent: %f\tdescent: %f\tascent*scale: %f\t descent*scale: %f",scale,(fontSize * scale), ascent, descent, (ascent * scale), (descent*scale));
    return tmpString;
}

-(void)clearText {
    words = nil;
    words = [NSArray array];
    [lines removeAllObjects];
}

//NOTE : Cannot call drawRect directly
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height + 15.0);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
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



