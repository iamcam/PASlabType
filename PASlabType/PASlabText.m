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

@synthesize delegate;
@synthesize charAspectRatio, idealLineLength, idealLineAspectRatio, boxWidth, boxHeight, idealLineHeight, hypotheticalLineCount, idealCharCountPerLine;
@synthesize sentence, words, lines, lineInfo, overflow;
@synthesize font, color, strokeColor, strokeWidth;
@synthesize fontChoices, selectedFontDict;
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
//        [self setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.15]];
        overflow = [[NSMutableString alloc] initWithString:@""];

        if(!fontChoices){
            // Default Choices: @"Raleway-Thin",  @"League Gothic",@"League Script Thin",@"Ostrich Sans Rounded",@"ChunkFive"
            //Optional choices: @"Ostrich Sans Black",@"Ostrich Sans Bold"
            font = [[PASlabFont alloc] init];
            fontChoices = [NSArray  arrayWithObjects:@"Raleway-Thin",  @"League Gothic",@"League Script Thin",@"Ostrich Sans Rounded",@"ChunkFive", nil];
            color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85];
            strokeColor = [UIColor blueColor];
            [self setStrokeWidth:0.0f];

        }
    }
    
//    [self selectFontWithName: @"ChunkFive"];
//    [self selectFontWithName:@"League Gothic"];
    
    return self;
}


/**
 This function is a stripped-down AS3 -> ObjC port of the slabtype
 algorithm by Eric Loyer with many of the original comments left intact [1].
 Additional help and clarification from the slabText jQuery plugin by @freqdec[2]
 [1] http://erikloyer.com/index.php/blog/the_slabtype_algorithm_part_1_background/                         
 [2] https://github.com/freqdec/slabText
 **/
// FIXME: Adding a newline to some strings act like the line is a different length.
// FIXME: if there is only one line, large text is clipped
// TODO: Test w/ Dave Ramsey quote and chunk5: "example" w/ and w/o \n
-(void) splitTextInString: (NSString *)string {
    [self clearText];
    sentence = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n "];
    boxWidth = self.frame.size.width;
    boxHeight = self.frame.size.height;

    // These two are interchangeable for now, but idealCharCountPerLine is a perferred calculation
    idealLineLength = [font idealCharCountPerLine];
    charAspectRatio = [font charAspectRatio]; //aspect ratio isn't really that useful in many cases
    idealLineAspectRatio = charAspectRatio * idealLineLength; // 0.44518217 * 12 = 5.4218604
    
    idealLineHeight = boxWidth / idealLineAspectRatio;
    hypotheticalLineCount = floor(boxHeight / idealLineHeight);
    if( hypotheticalLineCount == 0 ) hypotheticalLineCount = 1;
    
    // TODO: will figuring out how many lines we really have do anything to change?
    idealCharCountPerLine = (int)round([string length]/hypotheticalLineCount);

    idealCharCountPerLine = [font idealCharCountPerLine]; //22 is a good place to start
    if(idealCharCountPerLine == 0)
        idealCharCountPerLine = 1;

    if(manualCharCountPerLine > 0){
        idealCharCountPerLine = manualCharCountPerLine;
    }

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
    NSRange range = NSMakeRange(NSNotFound, 0); // Initialize with NOT FOUND, length 0 //http://stackoverflow.com/a/3504498

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

            range = [postText rangeOfString:@"\n" options:NSBackwardsSearch];

            if (wordIndex >= wc || range.length > 0){
                break;
            }
        }

        if(range.length > 0 ){
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

    if(! lineInfo ){
        lineInfo = [[NSMutableArray alloc] initWithCapacity: lc];
    } else {
        [lineInfo removeAllObjects];
    }

    for( int ii = 0; ii < lc; ii++){
        NSString *line = [NSString stringWithFormat:@"%@\n",[lines objectAtIndex:ii]];

        //The line's info is allso added to the array in sizeLineToFit
        NSAttributedString *tmpString = [self sizeLineToFit:line];
        [finalString appendAttributedString:tmpString];
    }
    
    return finalString;
}



/**
 * Sizes the lines to fit the horizontal width of the frame
 */
// FIXME: Large text on first line clips the top off
-(NSAttributedString *)sizeLineToFit:(NSString *)line {
    float scale = 1.0f;
    float fontSize = 6.0f;    
//    NSLog(@"Line: %@", line);
    
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)[font fontName], (fontSize * scale), NULL);
    
    /********/

    /********/
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id) self.color.CGColor, kCTForegroundColorAttributeName,
                           (__bridge id) fontRef, kCTFontAttributeName,
                           (id) self.strokeColor.CGColor, kCTStrokeColorAttributeName,
                           (id) [NSNumber numberWithInt:self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           nil];
    NSAttributedString *tmpString = [[NSAttributedString alloc] initWithString:line attributes:attrs];
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) tmpString);
    
    CGFloat ascent, descent, leading, capHeight;
    CGFloat lineWidth = CTLineGetTypographicBounds(lineRef, &ascent, &descent, NULL);
        
    float whitespace = CTLineGetTrailingWhitespaceWidth(lineRef);
    float realTextWidth = lineWidth - whitespace;
    scale = self.frame.size.width / realTextWidth;
    
    // http://stackoverflow.com/questions/5312962/line-spacing-and-paragraph-alignment-in-coretext/6056018#6056018
    float spaceBetweenParaghraphs = 0.1f;
    float topSpacing = 0.1f;
    float spaceBetweenLines = 0.1; //default 0.0
    float minLineHeight = ascent * scale; //helps us get real tight
    float maxLineHeight = ascent * scale; //helps us get real tight
    
    ascent = CTFontGetAscent(fontRef);
    descent = CTFontGetDescent(fontRef);
    leading = CTFontGetLeading(fontRef);
    capHeight = CTFontGetCapHeight(fontRef);
//   float xHeight = CTFontGetXHeight(fontRef);
//   float lineHeight = ascent + descent + leading; //Technically correct, but for our purposes, not so much.
//    maxLineHeight = (ascent - descent) * scale;
//    minLineHeight  = (ascent - descent) * scale;

    if([lineInfo count] > 0){
        float prevDesc = [[[lineInfo lastObject] objectForKey:@"descent"] floatValue];
        maxLineHeight = [font lineHeightUsingScale:scale ascent:ascent descent:descent previousDescent:prevDesc]; //there's also a similar func that uses leading.
//        NSLog(@"Previous Descent: %.3f", prevDesc);
    } else {
        //TODO: This is maybe another place to consider a custom per-font method.
        maxLineHeight = (ascent + descent) * scale;
    }
    

//    NSLog(@"Ascent: %.3f\tDescent: %.3f\tLeading: %.3f\tCap Height: %.3f\tX Height: %.3f\tLH: %.3f\t", ascent, descent, leading, capHeight,xHeight, lineHeight);
//    NSLog(@"Ascent: %.3f\tDescent: %.3f\tLeading: %.3f\tCap Height: %.3f\tX Height: %.3f\tLH: %.3f\t", ascent * scale, descent * scale, leading * scale, capHeight * scale,xHeight * scale, lineHeight * scale);
    
    CTParagraphStyleSetting theSettings[5] = 
    {
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &spaceBetweenParaghraphs },
        { kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &topSpacing },
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &spaceBetweenLines },
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
    };
    /**
    Line height sample code at http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/CoreText_Programming/Operations/Operations.html
     **/
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, 5);
    float newFontSize = (fontSize * scale);
    
    //CF vars aren't controlled by ARC, so we need to be a little more careful with retain/release
    CFBridgingRelease(fontRef);
    
    fontRef = CTFontCreateWithName((__bridge CFStringRef) [font fontName], newFontSize, NULL);
    attrs = [NSDictionary dictionaryWithObjectsAndKeys:
             (id) self.color.CGColor, kCTForegroundColorAttributeName,
             (__bridge id) fontRef, kCTFontAttributeName,
             (id) self.strokeColor.CGColor, kCTStrokeColorAttributeName,
             (id) [NSNumber numberWithInt:self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
             (__bridge id) paragraphStyle, kCTParagraphStyleAttributeName,
             nil];

    tmpString = [[NSAttributedString alloc] initWithString:line attributes:attrs];
//    lineWidth = CTLineGetTypographicBounds(lineRef, &ascent, &descent, NULL);

    //    NSLog(@"LineWidth: %f,\twhitespace: %f,\trealTextWidth: %f,\tscale: %f,\tnewTextWidth: %f",lineWidth, whitespace, realTextWidth, scale, realTextWidth*scale);
//    NSLog(@"scale: %f\tfont size: %f\tfontScale: %f\tascent: %f\tdescent: %f\tascent*scale: %f\t descent*scale: %f",scale,fontSize, (fontSize * scale), ascent, descent, (ascent * scale), (descent*scale));

//    NSRange range = NSMakeRange(0, [tmpString length]);
//    NSLog(@"tmpString: %@", [tmpString attributesAtIndex:0 effectiveRange: &range]);

    /*
     * Create a dictionary holding the metrics for the resized text so we can do a look-back and adjust line heights as necessary
     * All font metris have the scale applied as it is seen in this line.
     */
    
    NSDictionary *infoDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat:newFontSize], @"fontSize",
                              [NSNumber numberWithFloat:scale], @"scale",
                              [NSNumber numberWithFloat:ascent * scale], @"ascent",
                              [NSNumber numberWithFloat:descent * scale], @"descent",
                              [NSNumber numberWithFloat:leading * scale], @"leading",
                              [NSNumber numberWithFloat:capHeight * scale], @"capHeight",
                              [NSNumber numberWithFloat:minLineHeight], @"minLineHeight",
                              [NSNumber numberWithFloat:maxLineHeight], @"maxLineHeight"
                              , nil];
    
    [lineInfo addObject:infoDict];

    //CF vars aren't controlled by ARC, so we need to be a little more careful with retain/release
    // See for more details: http://www.raywenderlich.com/5773/beginning-arc-in-ios-5-tutorial-part-2
    CFBridgingRelease(fontRef);
    CFBridgingRelease(paragraphStyle);
    CFBridgingRelease(lineRef);

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
    CGContextTranslateCTM(context, 0, self.bounds.size.height + 0.0);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
    NSAttributedString *attString = [self formatLinesForLayout];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString); //3
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);

    CFRange range;
    
    
    /**
     Numbers to see if we can get some kind of useful dimensions
     */
    CGSize constraints = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,[attString length]), NULL, constraints, &range);
//    NSLog(@"Suggested\tw:%f\th:%f\tlen:%d\tloc:%d",suggestedSize.width, suggestedSize.height, (int) range.length, (int) range.location);
//    NSLog(@"Actual: \tw:%f,\th:%f",self.frame.size.width, self.frame.size.height);
    
    range = CTFrameGetVisibleStringRange(frame);
//    NSLog(@"visible: %d\tnot Visible: %d", (int) range.length,(int) ([attString length] - range.length)-1);
    int invisibleStart = range.length;
    NSString *plainString = [attString string];

    // I think it makes sense to just convert newlines to spaces, but that is probably a better job done *outside* the class.
    // [overflow setString:[[plainString substringFromIndex: invisibleStart] stringByReplacingOccurrencesOfString:@"\n" withString:@" "]]; 
    [overflow setString:[plainString substringFromIndex:invisibleStart]];
    if(overflow.length>0){
        NSLog(@"Overflow: %@", overflow);
    }
    
    CTFrameDraw(frame, context); //4
    
    //Inform our delegate of te text frame
//    [self.delegate textBoundsDidChangeWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self textHeight])];
    [self.delegate textBoundsDidChangeWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, suggestedSize.height)];
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
}

-(float)textHeight {
    // Get the actual line height of our text
    int lc = [lineInfo count];
    float totalHeight = 0.0;
    for (int ii=0; ii<lc; ii++) {
        totalHeight += [[[lineInfo objectAtIndex:ii] valueForKey:@"maxLineHeight"] floatValue];
    }
    return totalHeight;
}

#pragma mark - Font Stuffs

/*
 * Pass a name of the font. Assuming the font exists, an object representing the font is returned;
 * If the font does not exist in the project, the system default will be returned.
 */
-(void)selectFontWithName: (NSString *)name{
    font = nil;
    
    font = [[PASlabFont alloc] initWithFontName: name];
    
}

-(PASlabText *) copy {
    PASlabText *tmp = [[PASlabText alloc] initWithFrame:self.frame];
    [tmp setSelectedFontDict:self.selectedFontDict];
    [tmp setFont:self.font];
    [tmp setCharAspectRatio:self.charAspectRatio];
    [tmp setIdealLineHeight:self.idealLineHeight];
    [tmp setIdealLineAspectRatio:self.idealLineAspectRatio];
    [tmp setBoxWidth:self.boxWidth];
    [tmp setBoxHeight:self.boxHeight];
    [tmp setManualCharCountPerLine:self.manualCharCountPerLine];
    [tmp setColor:self.color];
    [tmp setStrokeColor:self.strokeColor];
    [tmp setStrokeWidth:self.strokeWidth];
    [tmp setFontChoices:self.fontChoices];

    [tmp splitTextInString:self.sentence];
    return tmp;

}
@end



