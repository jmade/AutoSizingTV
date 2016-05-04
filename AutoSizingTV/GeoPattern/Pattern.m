//
//  Pattern.m
//  GeoPattern
//
//  Created by Matthew Faluotico on 5/7/15.
//  Copyright (c) 2015 MF. All rights reserved.
//

#import "Pattern.h"
#import "Helpers.h"
#import "GeoPatternConstants.h"
#import "ShapeDrawer.h"
#import "PreProcesses.h"

@interface Pattern()
@property CGContextRef context;
@property NSString *hashValue;
@property NSDictionary *options;
@end

@implementation Pattern

- (id) initWithContext: (CGContextRef ) context WithOptions: (NSDictionary *) options; {
    self = [super init];
    self.context = context;
    self.options = options;
    self.hashValue = [options objectForKey:kGeoPatternHash];
    return self;
}

- (void) temp {
    
    CGColorRef color = ((UIColor*)[self.options objectForKey:kGeoPatternColor]).CGColor;
    
    UIColor * dotColor = [UIColor colorWithCGColor:color];
    
    CGContextSetFillColorWithColor(self.context, dotColor.CGColor);
    
    CGContextAddArc(self.context, 3, 3, 6, 0, radians(360), 0);
    CGContextFillPath(self.context);
    
    CGContextAddArc(self.context, 20, 20, 6, 0, radians(360), 0);
    CGContextFillPath(self.context);
}

- (void) generate {
    
    PATTERN pattern;
    
    if ([self.options objectForKey:kGeoPatternType]) {
        pattern = [[self.options objectForKey:kGeoPatternType] integerValue];
    } else {
        pattern = [Helpers intFromHex:self.hashValue atIndex:20 withLength:1];
    }
    
    switch (pattern) {
        case GeoPatternOctogons          : [self generateOctogons]; break;
        case GeoPatternOverlappingcircles: [self generateOverlappingcircles]; break;
        case GeoPatternPlussigns         : [self generatePlussigns]; break;
        case GeoPatternXes               : [self generateXes]; break;
        case GeoPatternSinewaves         : [self generateSinewaves]; break;
        case GeoPatternHexagons          : [self generateHexagons]; break;
        case GeoPatternOverlappingrings  : [self generateOverlappingrings]; break;
        case GeoPatternPlaid             : [self generatePlaid]; break;
        case GeoPatternTriangles         : [self generateTriangles]; break;
        case GeoPatternSquares           : [self generateSquares]; break;
        case GeoPatternConcentriccircles : [self generateConcentriccircles]; break;
        case GeoPatternDiamonds          : [self generateDiamonds]; break;
        case GeoPatternTessellation      : [self generateTessellation]; break;
        case GeoPatternNestedsquares     : [self generateNestedsquares]; break;
        case GeoPatternMosaicsquares     : [self generateMosaicsquares]; break;
        case GeoPatternChevrons          : [self generateChevrons]; break;
        default                          : [self generateSquares];
    }
};

+ (CGSize) calculateSizeFromOptions: (NSDictionary *) options {
    PATTERN pattern;
    
    if ([options objectForKey:kGeoPatternType]) {
        pattern = [[options objectForKey:kGeoPatternType] integerValue];
    } else {
        NSString *hash = [options objectForKeyedSubscript:kGeoPatternHash];
        pattern = [Helpers intFromHex:hash atIndex:20 withLength:1];
    }
    
    switch (pattern) {
        case GeoPatternOctogons          : return [PreProcesses sizeForOctogons: options]; break;
        case GeoPatternOverlappingcircles: return [PreProcesses sizeForOverlappingcircles: options]; break;
        case GeoPatternPlussigns         : return [PreProcesses sizeForPlussigns: options]; break;
        case GeoPatternXes               : return [PreProcesses sizeForXes: options]; break;
        case GeoPatternSinewaves         : return [PreProcesses sizeForSinewaves: options]; break;
        case GeoPatternHexagons          : return [PreProcesses sizeForHexagons: options]; break;
        case GeoPatternOverlappingrings  : return [PreProcesses sizeForOverlappingrings: options]; break;
        case GeoPatternPlaid             : return [PreProcesses sizeForPlaid: options]; break;
        case GeoPatternTriangles         : return [PreProcesses sizeForTriangles: options]; break;
        case GeoPatternSquares           : return [PreProcesses sizeForSquares: options]; break;
        case GeoPatternConcentriccircles : return [PreProcesses sizeForConcentriccircles: options]; break;
        case GeoPatternDiamonds          : return [PreProcesses sizeForDiamonds: options]; break;
        case GeoPatternTessellation      : return [PreProcesses sizeForTessellation: options]; break;
        case GeoPatternNestedsquares     : return [PreProcesses sizeForNestedsquares: options]; break;
        case GeoPatternMosaicsquares     : return [PreProcesses sizeForMosaicsquares: options]; break;
        case GeoPatternChevrons          : return [PreProcesses sizeForChevrons: options]; break;
        default                          : return [PreProcesses sizeForSquares: options];
    }
}

+ (BOOL) shouldUseImagingMode: (NSDictionary *) options {
    
    PATTERN pattern;
    
    if ([options objectForKey:kGeoPatternType]) {
        pattern = [[options objectForKey:kGeoPatternType] integerValue];
    } else {
        NSString *hash = [options objectForKeyedSubscript:kGeoPatternHash];
        pattern = [Helpers intFromHex:hash atIndex:20 withLength:1];
    }
    
    return (
            pattern == GeoPatternTriangles ||
            pattern == GeoPatternXes ||
            pattern == GeoPatternTessellation ||
            pattern == GeoPatternDiamonds
            );
    
}

+ (NSDictionary*) defaults {
    return @{
             kGeoPatternBaseColor : [UIColor redColor]
             };
}

static inline double radians (double degrees)  {
    return degrees * M_PI/180;
}

#pragma mark - Pattern Generation

- (void) generateOctogons {
    
    CGFloat size = [Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:0 withLength:1] inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:10 andUpperBound:60];
    NSInteger counter = 0, x = 0, y = 0;
    
    for (y = 0;y< 6; y++) {
        for (x = 0;x<6; x++) {
        
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
            
            CGAffineTransform t = CGAffineTransformMakeTranslation(x * size, y * size);
            
            [ShapeDrawer drawOctogonWithSize:size
                                    withFill:fill
                                  withStroke:stroke
                                     atWidth:1
                                    inConext:self.context
                            transformEffects:t];
            
            counter++;
        }
    }
}

- (void) generateOverlappingcircles {
    NSInteger hex = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    CGFloat scale = hex;
    CGFloat diameter = [Helpers mapValue:scale inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:25 andUpperBound:200];
    CGFloat radius = diameter / 2.0;
    
    NSInteger counter = 0, x = 0, y =0;
    
    for (y=0; y<6; y++) {
        for (x = 0; x <6; x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            
            CGPoint center = CGPointMake(x * radius, y *radius);
            [ShapeDrawer drawCircleWithCenter:center withRadius:radius withFill:fill withStroke:[UIColor clearColor] atWidth:0 inContext:self.context];
            
            if (x==0) {
                center = CGPointMake(6 * radius, y * radius);
                [ShapeDrawer drawCircleWithCenter:center withRadius:radius withFill:fill withStroke:[UIColor clearColor] atWidth:0 inContext:self.context];
            }
            
            if (y==0) {
                center = CGPointMake(x * radius, 6 * radius);
                [ShapeDrawer drawCircleWithCenter:center withRadius:radius withFill:fill withStroke:[UIColor clearColor] atWidth:0 inContext:self.context];
            }
            
            if (x==0 && y==0) {
                center = CGPointMake(6 * radius, 6 * radius);
                [ShapeDrawer drawCircleWithCenter:center withRadius:radius withFill:fill withStroke:[UIColor clearColor] atWidth:0 inContext:self.context];
            }
            
            counter++;
        }
    }
}

- (void) generatePlussigns {
    CGFloat squareSize = [Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:0 withLength:1] inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:10 andUpperBound:25];
    CGFloat plusSize = squareSize * 3;
    
    NSInteger counter = 0;
    
    for (NSInteger y = 0; y < 6; y++) {
        for (NSInteger x  = 0; x < 6; x++) {
            
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
            
            NSInteger dx = (y % 2 == 0) ? 0 : 1;
            
            CGFloat tx, ty;
            CGAffineTransform t;
            
            tx = x * plusSize - x * squareSize + dx * squareSize - squareSize;
            ty = y * plusSize - y * squareSize - plusSize / 2.0;

            t = CGAffineTransformMakeTranslation(tx, ty);
            
            [ShapeDrawer drawPlusSignWithSize:squareSize
                                         fill:fill
                                       stroke:stroke
                                  strokeWidth:1
                                    inContext:self.context
                               withTransforms:t];
            
            if (x == 0) {
                tx = 4 * plusSize - x * squareSize + dx * squareSize - squareSize;
                ty = y * plusSize - y * squareSize - plusSize / 2.0;
                
                t = CGAffineTransformMakeTranslation(tx, ty);
                
                [ShapeDrawer drawPlusSignWithSize:squareSize
                                             fill:fill
                                           stroke:stroke
                                      strokeWidth:1
                                        inContext:self.context
                                   withTransforms:t];

            }
            
            
            if (y == 0) {
                
                tx = x * plusSize - x * squareSize + dx * squareSize - squareSize;
                ty = 4 * plusSize - y * squareSize - plusSize / 2;
                
                t = CGAffineTransformMakeTranslation(tx, ty);
                
                [ShapeDrawer drawPlusSignWithSize:squareSize
                                             fill:fill
                                           stroke:stroke
                                      strokeWidth:1
                                        inContext:self.context
                                   withTransforms:t];

            }
            
            if (x == 0 && y == 0) {
                
                tx = 4 * plusSize - x * squareSize + dx * squareSize - squareSize;
                ty = 4 * plusSize - y * squareSize - plusSize / 2.0;
                
                t = CGAffineTransformMakeTranslation(tx, ty);
                
                [ShapeDrawer drawPlusSignWithSize:squareSize
                                             fill:fill
                                           stroke:stroke
                                      strokeWidth:1
                                        inContext:self.context
                                   withTransforms:t];

            }
            
            counter++;
        }
    }
    
}

- (void) generateXes {
    CGFloat squareSize = [Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:0 withLength:1] inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:10 andUpperBound:25];
    CGFloat xSize = squareSize * 3 * 0.943;
    
    CGFloat tx,ty,dy;
    CGAffineTransform t, r;
    NSInteger counter = 0, x , y;
    
    for (y = 0; y < 6; y++) {
        for (x = 0; x < 6; x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            UIColor *stroke = [UIColor clearColor];
            
            dy = x % 2 == 0 ? y * xSize - xSize * 0.5 : y * xSize - xSize * 0.5 + xSize / 4;
            
            // draw
            
            tx = x * xSize / 2 - xSize / 2,
            ty = dy - y * xSize / 2;
            
            t = CGAffineTransformMakeTranslation(tx, ty);
            r = [Helpers rotate:45 aroundPoint:CGPointMake(xSize / 2, xSize / 2) previousTransform:t];
            
            [ShapeDrawer drawXWithSize:squareSize
                                         fill:fill
                                       stroke:stroke
                                  strokeWidth:0
                                    inContext:self.context
                               withTransforms:r];
            
            if (x == 0) {
                tx = 6 * xSize / 2 - xSize / 2,
                ty = dy - y * xSize / 2;
                
                t = CGAffineTransformMakeTranslation(tx, ty);
                r = [Helpers rotate:45 aroundPoint:CGPointMake(xSize / 2, xSize / 2) previousTransform:t];
                
                [ShapeDrawer drawXWithSize:squareSize
                                             fill:fill
                                           stroke:stroke
                                      strokeWidth:0
                                        inContext:self.context
                                   withTransforms:r];
            }
            
            if (y == 0) {
                dy = (x % 2 == 0) ? 
                    6 * xSize - xSize / 2 :
                    6 * xSize - xSize / 2 + xSize / 4;
                
                tx = x * xSize / 2 - xSize / 2,
                ty = dy - 6 * xSize / 2;
                
                t = CGAffineTransformMakeTranslation(tx, ty);
                r = [Helpers rotate:45 aroundPoint:CGPointMake(xSize / 2, xSize / 2) previousTransform:t];
                
                [ShapeDrawer drawPlusSignWithSize:squareSize
                                             fill:fill
                                           stroke:stroke
                                      strokeWidth:0
                                        inContext:self.context
                                   withTransforms:r];
            
            }
        
            
            if (y == 5) {
                tx = x * xSize / 2 - xSize / 2,
                ty = dy - 11 * xSize / 2;
                
                t = CGAffineTransformMakeTranslation(tx, ty);
                r = [Helpers rotate:45 aroundPoint:CGPointMake(xSize / 2, xSize / 2) previousTransform:t];
                
                [ShapeDrawer drawPlusSignWithSize:squareSize
                                             fill:fill
                                           stroke:stroke
                                      strokeWidth:0
                                        inContext:self.context
                                   withTransforms:r];
            }
            
            if (x == 0 && y == 0) {
             
                tx = 6 * xSize / 2 - xSize / 2,
                ty = dy - 6 * xSize / 2;
                
                t = CGAffineTransformMakeTranslation(tx, ty);
                r = [Helpers rotate:45 aroundPoint:CGPointMake(xSize / 2, xSize / 2) previousTransform:t];
                
                [ShapeDrawer drawPlusSignWithSize:squareSize
                                             fill:fill
                                           stroke:stroke
                                      strokeWidth:0
                                        inContext:self.context
                                   withTransforms:r];
            }
            
            counter++;
        }
    }
    
}

- (void) generateSinewaves {
    
    NSInteger period, amplitude, waveWidth;
    period = floor([Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:0 withLength:1]
                     inRangeWithLower:0
                        andUpperBound:15
             toNewRangeWithLowerBound:100
                        andUpperBound:400]);
    amplitude = floor([Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:1 withLength:1]
                     inRangeWithLower:0
                        andUpperBound:15
             toNewRangeWithLowerBound:30
                        andUpperBound:100]);
    waveWidth = floor([Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:2 withLength:1]
                     inRangeWithLower:0
                        andUpperBound:15
             toNewRangeWithLowerBound:3
                        andUpperBound:30]);
    
    
    NSInteger i = 0;
    
    // M0 39 C 52.5 0, 97.5 0, 150 39 S 247.5 78, 300 39 S 397.5 0, 450, 39
    
    for (i=0;i < 36; i++) {
        
        NSInteger val = [Helpers intFromHex:self.hashValue atIndex:i withLength:1];
        CGFloat opacity = [Helpers opacity:val];
        UIColor *stroke = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
        UIColor *fill = [UIColor clearColor];
        CGFloat strokeWidth = waveWidth;
        CGFloat xOffset = (period / 4) * 0.7;
        
        CGAffineTransform t = CGAffineTransformMakeTranslation(-period / 4, waveWidth * i - amplitude * 1.5);
        
        [ShapeDrawer drawWaveWithPeriod:period amplitude:amplitude waveWidth:waveWidth xOffset:xOffset fill:fill stroke:stroke strokeWidth:strokeWidth inContext:self.context withTransforms:t];
        
        t = CGAffineTransformMakeTranslation(-period / 4, waveWidth * i - amplitude * 1.5 + waveWidth * 36);
        
        [ShapeDrawer drawWaveWithPeriod:period amplitude:amplitude waveWidth:waveWidth xOffset:xOffset fill:fill stroke:stroke strokeWidth:strokeWidth inContext:self.context withTransforms:t];
    }
    
    
}

- (void) generateHexagons {
    CGFloat scale = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    CGFloat size = [Helpers mapValue:scale inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:8 andUpperBound:60];
    CGFloat hexHeight = size * sqrt(3);
    CGFloat hexWidth = size * 2;
    
    
    NSInteger counter = 0, x = 0, y = 0;
    CGFloat dy;
    
    for (y = 0;y< 6; y++) {
        for (x = 0;x<6; x++) {
            
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            dy = (x % 2 == 0)? (y * hexHeight) : (y * hexHeight + (hexHeight / 2));
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
            
            CGAffineTransform t = CGAffineTransformMakeTranslation(x * size * 1.5 - hexWidth / 2,
                                                                   dy - hexHeight / 2);
            
            [ShapeDrawer drawHexagonWithSize:size
                                    withFill:fill
                                  withStroke:stroke
                                     atWidth:1
                                    inConext:self.context
                            transformEffects:t];
            
            if (x == 0) {
                t = CGAffineTransformMakeTranslation(6 * size * 1.5 - hexWidth / 2,
                                                     dy - hexHeight / 2);
                
                [ShapeDrawer drawHexagonWithSize:size
                                        withFill:fill
                                      withStroke:stroke
                                         atWidth:1
                                        inConext:self.context
                                transformEffects:t];
            }
            
            if (y == 0) {
                t = CGAffineTransformMakeTranslation(x * size * 1.5 - hexWidth / 2,
                                                     dy - hexHeight / 2);
                
                [ShapeDrawer drawHexagonWithSize:size
                                        withFill:fill
                                      withStroke:stroke
                                         atWidth:1
                                        inConext:self.context
                                transformEffects:t];
            }
            
            if (x ==0 && y == 0) {
                t = CGAffineTransformMakeTranslation(6 * size * 1.5 - hexWidth / 2,
                                                     5 * hexHeight - hexHeight / 2);
                
                [ShapeDrawer drawHexagonWithSize:size
                                        withFill:fill
                                      withStroke:stroke
                                         atWidth:1
                                        inConext:self.context
                                transformEffects:t];
            }
            
            counter++;
        }
    }

}

- (void) generateOverlappingrings {
    NSInteger hex = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    CGFloat scale = hex;
    CGFloat ringSize = [Helpers mapValue:scale inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:10 andUpperBound:60];
    CGFloat strokeWidth = ringSize / 4.0;
    
    NSInteger counter = 0, x,y;
    
    for (y = 0; y <6; y++) {
        for (x=0;x<6;x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *stroke = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            UIColor *fill = [UIColor clearColor];
            
            CGPoint center = CGPointMake(x * ringSize, y * ringSize);
            CGFloat radius = ringSize - (strokeWidth / 2.0);
            
            [ShapeDrawer
             drawCircleWithCenter:center
             withRadius:radius
             withFill:fill
             withStroke:stroke
             atWidth:strokeWidth
             inContext:self.context];
            
            if (x==0) {
                center = CGPointMake(6 * ringSize, y * ringSize);
                radius = ringSize - (strokeWidth/2.0);
                [ShapeDrawer
                 drawCircleWithCenter:center
                 withRadius:radius
                 withFill:fill
                 withStroke:stroke
                 atWidth:strokeWidth
                 inContext:self.context];
            }
            
            if (y ==0) {
                center = CGPointMake(x * ringSize, 6 * ringSize);
                radius = ringSize - (strokeWidth/2.0);
                [ShapeDrawer
                 drawCircleWithCenter:center
                 withRadius:radius
                 withFill:fill
                 withStroke:stroke
                 atWidth:strokeWidth
                 inContext:self.context];
            }
            
            if (x==0 && y==0) {
                center = CGPointMake(6 * ringSize, 6 * ringSize);
                radius = ringSize - (strokeWidth/2.0);
                [ShapeDrawer
                 drawCircleWithCenter:center
                 withRadius:radius
                 withFill:fill
                 withStroke:stroke
                 atWidth:strokeWidth
                 inContext:self.context];
            }
            
            counter++;
        }
    }

}

- (void) generatePlaid {
    CGFloat height = 0;
    CGFloat width = 0;
    NSValue *rect_ = [self.options objectForKey:@"size"];
    CGSize size = [rect_ CGSizeValue];
    
    NSInteger counter = 0, val, space;
    NSString *hex = self.hashValue;
    
    
    while (counter < 36) {
        space = [Helpers intFromHex:hex atIndex:counter withLength:1];
        height += (space + 5);
        val = [Helpers intFromHex:hex atIndex:counter + 1 withLength:1];
        CGFloat opacity = [Helpers opacity:val];
        UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
        NSInteger stripeHeight = val + 5;

        CGRect rect = CGRectMake(0, height, size.width, stripeHeight);
        
        [ShapeDrawer drawRectangle:rect withFill:fill withStroke:[UIColor clearColor] atWidth:0 inContext:self.context];
        
        height += stripeHeight;
        counter +=2;
    }
    
    counter = 0;
    
    while (counter < 36) {
        space = [Helpers intFromHex:hex atIndex:counter withLength:1];
        width += (space + 5);
        val = [Helpers intFromHex:hex atIndex:counter + 1 withLength:1];
        CGFloat opacity = [Helpers opacity:val];
        UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
        NSInteger stripeWidth = val + 5;
        
        CGRect rect = CGRectMake(width, 0, stripeWidth, size.height);
        
        [ShapeDrawer drawRectangle:rect withFill:fill withStroke:[UIColor clearColor] atWidth:0 inContext:self.context];
        
        width += stripeWidth;
        counter +=2;
    }
    
}

- (void) generateTriangles {
    CGFloat scale = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    CGFloat sideLength = [Helpers mapValue:scale
                           inRangeWithLower:0
                              andUpperBound:15
                   toNewRangeWithLowerBound:15
                              andUpperBound:80];
    CGFloat triangleHeight = sideLength / 2 * sqrt(3);
    
    NSInteger counter, x, y;
    counter = 0;
    
    for (y = 0; y < 6; y++) {
        for (x = 0; x < 6; x++) {
            
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            
            // style
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
            
            CGAffineTransform r, t;
            CGFloat rotationInDegs;
            
            if (y % 2 == 0) {
                rotationInDegs = (x % 2 == 0) ? 180 : 0;
            } else {
                rotationInDegs = (x % 2 != 0) ? 180 : 0;
            }
            
            t = CGAffineTransformMakeTranslation(x * sideLength * 0.5 - sideLength / 2
                                                 , triangleHeight * y);
            
            r = [Helpers rotate:rotationInDegs aroundPoint:CGPointMake(sideLength / 2, triangleHeight / 2) previousTransform:t];
            
            [ShapeDrawer drawTriangleWithSideLength:sideLength
                                             height:triangleHeight
                                           withFill:fill
                                         withStroke:stroke
                                            atWidth:1
                                           inConext:self.context
                                   transformEffects:r];
            
            if (x == 0) {
                t = CGAffineTransformMakeTranslation(6 * sideLength * 0.5 - sideLength / 2
                                                     , triangleHeight * y);
                r = [Helpers rotate:rotationInDegs aroundPoint:CGPointMake(sideLength / 2, triangleHeight / 2) previousTransform:t];
                
                [ShapeDrawer drawTriangleWithSideLength:sideLength
                                                 height:triangleHeight
                                               withFill:fill
                                             withStroke:stroke
                                                atWidth:1
                                               inConext:self.context
                                       transformEffects:r];
            }
            
            counter++;
        }
    }
    
}

- (void) generateSquares {
    
    NSInteger fromHex = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    double squareSize = [Helpers mapValue:fromHex
                          inRangeWithLower:0
                             andUpperBound:15
                  toNewRangeWithLowerBound:10
                             andUpperBound:60];
    
    NSInteger counter = 0;
    NSInteger y;
    NSInteger x;
    
    for (y = 0; y < 6; y++) {
        for (x = 0; x < 6; x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fillColor = [Helpers fillColor:val];
            
            UIColor *fillOpacity = [fillColor colorWithAlphaComponent:opacity];
            UIColor *strokeColor = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
            CGRect rect = CGRectMake(x * squareSize, y * squareSize, squareSize, squareSize);
            
            [ShapeDrawer drawRectangle:rect withFill:fillOpacity withStroke:strokeColor atWidth: 1 inContext:self.context];
            
            counter++;
        }
    }
    
    
}

- (void) generateConcentriccircles {
    NSInteger hex = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    CGFloat scale = hex;
    CGFloat ringSize = [Helpers mapValue:scale inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:10 andUpperBound:60];
    CGFloat strokeWidth = ringSize / 5.0;
    
    NSInteger counter = 0, x = 0, y =0;
    
    for (y = 0; y < 6; y++) {
        for (x = 0; x < 6; x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *stroke = [Helpers fillColor:val];
            UIColor *fill = [UIColor clearColor];
            
            stroke = [stroke colorWithAlphaComponent:opacity];
            
            CGFloat centerX = x * ringSize + x * strokeWidth + ((ringSize + strokeWidth) / 2.0);
            CGFloat centerY = y * ringSize + y * strokeWidth + ((ringSize + strokeWidth) / 2.0);
            CGPoint center = CGPointMake(centerX, centerY);
            
            [ShapeDrawer drawCircleWithCenter:center withRadius:ringSize / 2 withFill:fill withStroke:stroke atWidth:strokeWidth inContext:self.context];
            
            val = [Helpers intFromHex:self.hashValue atIndex:39-counter withLength:1];
            opacity = [Helpers opacity:val];
            fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            stroke = [UIColor clearColor];
            
            
            [ShapeDrawer drawCircleWithCenter:center withRadius:ringSize / 4 withFill:fill withStroke:stroke atWidth:0 inContext:self.context];
            
            counter++;
        }
    }
    
}

- (void) generateDiamonds {
    CGFloat width = [Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:0 withLength:1] inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:10 andUpperBound:50];
    CGFloat height = [Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:1 withLength:1] inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:10 andUpperBound:50];
    
    NSInteger counter = 0, x, y;
    
    for (y=0; y<6; y++) {
        for (x=0; x <6; x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
            
            double dx = (y % 2 == 0) ? 0 : (width / 2.0);
            
            CGFloat tx = x * width - (width / 2.0) + dx;
            CGFloat ty = height / 2.0 * y - height / 2;
            
            [ShapeDrawer drawDiamondWithWidth:width
                                   withHeight:height 
                                     withFill:fill
                                   withStroke:stroke
                                      atWidth:0
                                    inContext:self.context
                             transformEffects:CGAffineTransformMakeTranslation(tx, ty)];
            
            if (x == 0) {
                
                tx = 6 * width - (width / 2.0) + dx;
                ty = height / 2.0 * y - height / 2;
                [ShapeDrawer drawDiamondWithWidth:width
                                       withHeight:height
                                         withFill:fill
                                       withStroke:stroke
                                          atWidth:0
                                        inContext:self.context
                                 transformEffects:CGAffineTransformMakeTranslation(tx, ty)];

            }
            
            if (y == 0) {
                
                tx = x * width - (width / 2.0) + dx;
                ty = height / 2.0 * 6 - height / 2;
                [ShapeDrawer drawDiamondWithWidth:width
                                       withHeight:height
                                         withFill:fill
                                       withStroke:stroke
                                          atWidth:0
                                        inContext:self.context
                                 transformEffects:CGAffineTransformMakeTranslation(tx, ty)];
                
            }
            
            
            if (x == 0 && y == 0) {
                
                tx = 6 * width - (width / 2.0) + dx;
                ty = height / 2.0 * 6 - height / 2;
                [ShapeDrawer drawDiamondWithWidth:width
                                       withHeight:height
                                         withFill:fill
                                       withStroke:stroke
                                          atWidth:0
                                        inContext:self.context
                                 transformEffects:CGAffineTransformMakeTranslation(tx, ty)];
                
            }
            
            counter++;
        }
    }
}

- (void) generateTessellation {
 
    CGFloat sideLength = [Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:0 withLength:1]
                             inRangeWithLower:0
                                andUpperBound:15
                     toNewRangeWithLowerBound:5
                                andUpperBound:40];
    
    CGFloat sq = 1.7320508075688772;
    CGFloat hexHeight = sideLength * sq;
    CGFloat hexWidth = sideLength  * 2;
    CGFloat triangleHeight = sideLength / 2.0 * sq;
    CGFloat tileWidth = sideLength * 3 + triangleHeight * 2.0;
    CGFloat tileHeight = (hexHeight * 2) + (sideLength * 2);
    
    NSInteger counter = 0;
    
    for (counter = 0; counter < 20; counter++) {
        
        // STYLES
        
        NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
        CGFloat opacity = [Helpers opacity:val];
        UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
        UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
        
        
        switch (counter) {
                // good
            case 0: {
                CGRect rect = CGRectMake(-sideLength / 2, -sideLength / 2, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];

                rect = CGRectMake(tileWidth - sideLength / 2, -sideLength / 2, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];
                
                rect = CGRectMake(-sideLength / 2, tileHeight - sideLength / 2, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];

                rect = CGRectMake(tileWidth - sideLength / 2, tileHeight - sideLength / 2, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];
                break;
            }
                // good
            case 1: {
                CGRect rect = CGRectMake(hexWidth / 2 + triangleHeight, hexHeight / 2, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];
                break;
            }
                // good
            case 2: {
                CGRect rect = CGRectMake(-sideLength / 2, tileHeight / 2 - sideLength / 2, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];
                
                rect = CGRectMake(tileWidth - sideLength / 2, tileHeight / 2 - sideLength / 2, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];
                break;
            }
                // good
            case 3: {
                CGRect rect = CGRectMake(hexWidth / 2 + triangleHeight, hexHeight * 1.5 + sideLength, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context];
                break;
            }
                // good
            case 4: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(sideLength / 2, -sideLength / 2);
                CGAffineTransform r = CGAffineTransformRotate(t, 0);
                CGAffineTransform s;
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:r];
                
                t = CGAffineTransformMakeTranslation(sideLength / 2, tileHeight - (-sideLength / 2));
                r = CGAffineTransformRotate(t, 0);
                s = CGAffineTransformScale(r, 1, -1);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:s];
                break;
            }
                // good
            case 5: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(tileWidth - sideLength / 2, -sideLength / 2);
                CGAffineTransform r = CGAffineTransformRotate(t, 0);
                CGAffineTransform s = CGAffineTransformScale(r, -1, 1);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:s];
                
                t = CGAffineTransformMakeTranslation(tileWidth - sideLength / 2, tileHeight + sideLength / 2);
                r = CGAffineTransformRotate(t, 0);
                s = CGAffineTransformScale(t, -1, -1);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:s];
                break;
                // good
            } case 6: {
                CGAffineTransform t = CGAffineTransformMakeTranslation((tileWidth / 2) + (sideLength / 2),
                                                                       hexHeight /2);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:t];
                break;
            } case 7: {
                // good
                CGAffineTransform t = CGAffineTransformMakeTranslation(tileWidth - tileWidth / 2 - sideLength / 2,
                                                                       hexHeight /2);
                CGAffineTransform s = CGAffineTransformScale(t, -1, 1);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:s];
                break;
                // good
            } case 8: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(tileWidth / 2 + sideLength / 2,
                                                                       tileHeight - hexHeight / 2);
                CGAffineTransform s = CGAffineTransformScale(t, 1, -1);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:s];
                break;
                
                // good
            } case 9: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(tileWidth - tileWidth / 2 - sideLength / 2,
                                                                       tileHeight - hexHeight / 2);
                CGAffineTransform s = CGAffineTransformScale(t, -1, -1);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:s];
                break;
                // good
            } case 10: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(sideLength / 2,
                                                                       tileHeight / 2 - sideLength / 2);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:t];
                break;
            } case 11: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(tileWidth - sideLength / 2,
                                                                       tileHeight /2 - sideLength / 2);
                CGAffineTransform s = CGAffineTransformScale(t, -1, 1);
                
                [ShapeDrawer
                 drawRotatedTriangleWithWidth:triangleHeight
                 withSideLength:sideLength withFill:fill
                 withStroke:stroke atWidth:1
                 inConext:self.context
                 transformEffects:s];
                break;
                // good
            } case 12: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(sideLength / 2,
                                                                       sideLength / 2);
                CGAffineTransform r = CGAffineTransformRotate(t, radians(-30));
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:r];
                break;
                // good
            } case 13: {
                CGAffineTransform s = CGAffineTransformMakeScale(-1, 1);
                CGAffineTransform t = CGAffineTransformTranslate(s,
                                                                   -tileWidth + sideLength / 2,
                                                                       sideLength / 2);
                CGAffineTransform r = CGAffineTransformRotate(t, radians(-30));
                
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:r];
                break;
                // good
            } case 14: {
                CGAffineTransform t = CGAffineTransformMakeTranslation(sideLength / 2,
                                                                       tileHeight / 2 - sideLength / 2 - sideLength);
                CGAffineTransform tr = [Helpers rotate:30 aroundPoint:CGPointMake(0, sideLength) previousTransform:t];
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:tr];
                break;
                // good
            } case 15: {
                CGAffineTransform s = CGAffineTransformMakeScale(-1, 1);
                CGAffineTransform t = CGAffineTransformTranslate(s,
                                                                 -tileWidth + sideLength / 2,
                                                                 tileHeight / 2 - sideLength / 2 - sideLength);
                CGAffineTransform tr = [Helpers rotate:30 aroundPoint:CGPointMake(0, sideLength) previousTransform:t];
                
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:tr];
                break;
                // good
            } case 16: {
                CGAffineTransform s = CGAffineTransformMakeScale(1, -1);
                CGAffineTransform t = CGAffineTransformTranslate(s,
                                                                       sideLength / 2,
                                                                     -tileHeight + tileHeight / 2 - sideLength / 2 - sideLength);
                CGAffineTransform tr = [Helpers rotate:30 aroundPoint:CGPointMake(0, sideLength) previousTransform:t];
                
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:tr];
                break;
                // good
            } case 17: {
                CGAffineTransform s = CGAffineTransformMakeScale(-1, -1);
                CGAffineTransform t = CGAffineTransformTranslate(s, -tileWidth + sideLength / 2,
                                                                       -tileHeight + tileHeight / 2 - sideLength / 2 - sideLength);
                CGAffineTransform tr = [Helpers rotate:30 aroundPoint:CGPointMake(0, sideLength) previousTransform:t];
                
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:tr];
                break;
            } case 18: {
                CGAffineTransform s = CGAffineTransformMakeScale(1, -1);
                CGAffineTransform t = CGAffineTransformTranslate(s, sideLength / 2,
                                                                       -tileHeight + sideLength / 2);
                CGAffineTransform r = CGAffineTransformRotate(t, radians(-30));
                
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:r];
                break;
            } case 19: {
                CGAffineTransform s = CGAffineTransformMakeScale(-1, -1);
                CGAffineTransform t = CGAffineTransformTranslate(s, -tileWidth + sideLength / 2,
                                                                   -tileHeight + sideLength / 2);
                
                CGAffineTransform r = CGAffineTransformRotate(t, radians(-30));
                
                CGRect rect = CGRectMake(0, 0, sideLength, sideLength);
                [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth:1 inContext:self.context transformEffects:r];
                break;
            }
            default:
                break;
        }
    }
    
}

- (void) generateNestedsquares {
    
    NSInteger hashInt = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    CGFloat blockSize = [Helpers mapValue:hashInt inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:4 andUpperBound:12];
    CGFloat squareSize = blockSize * 7;
    
    NSInteger counter = 0, x = 0,y = 0;
    
    for (y = 0; y < 6; y++) {
        for (x = 0; x < 6; x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *stroke = [Helpers fillColor:val];
            UIColor *fill = [UIColor clearColor];
            
//            fill = [fill colorWithAlphaComponent:opacity];
            stroke = [stroke colorWithAlphaComponent:opacity];
            
            CGRect rect = CGRectMake(x * squareSize + x * blockSize * 2 + blockSize / 2.0,
                                     y * squareSize + y * blockSize * 2 + blockSize / 2.0,
                                     squareSize,
                                     squareSize);
            
            [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth: blockSize inContext:self.context];
            
            val = [Helpers intFromHex:self.hashValue atIndex:39-counter withLength:1];
            opacity = [Helpers opacity:val];
            stroke = [Helpers fillColor:val];
            
//            fill = [fill colorWithAlphaComponent:opacity];
            stroke = [stroke colorWithAlphaComponent:opacity];
            
            
            rect = CGRectMake(x * squareSize + x * blockSize * 2 + blockSize / 2.0 + blockSize * 2,
                              y * squareSize + y * blockSize * 2 + blockSize / 2.0 + blockSize * 2,
                              blockSize * 3,
                              blockSize * 3);
            
            [ShapeDrawer drawRectangle:rect withFill:fill withStroke:stroke atWidth: blockSize inContext:self.context];
            
            counter++;
        }
    }
    
}

- (void) generateMosaicsquares {
    
    NSInteger hexVal = [Helpers intFromHex:self.hashValue atIndex:0 withLength:1];
    CGFloat triangleSize = [Helpers mapValue:hexVal inRangeWithLower:0 andUpperBound:15 toNewRangeWithLowerBound:15 andUpperBound:50];
    
    NSInteger counter = 0, x = 0, y = 0;
    
    for (y = 0; y < 4; y++) {
        for (x = 0; x < 4; x++) {
            if (x % 2 == 0) {
                if (y % 2 == 0) {
                    NSInteger i = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
                    NSArray *values = @[[NSNumber numberWithInteger:i]];
                    
                    [self doOuterTrianglesX:x * triangleSize * 2
                                          y:y * triangleSize * 2
                                       size:triangleSize
                                     andVal:values];
                } else{
                    NSInteger i = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
                    NSInteger j = [Helpers intFromHex:self.hashValue atIndex:counter + 1 withLength:1];
                    
                    NSArray *values = @[[NSNumber numberWithInteger:i],
                                        [NSNumber numberWithInteger:j]];
                    
                    [self doInnerTrianglesX:x * triangleSize * 2
                                          y:y * triangleSize * 2
                                       size:triangleSize
                                     andVal:values];
                }
            } else {
                if (y % 2 == 0) {
                    NSInteger i = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
                    NSInteger j = [Helpers intFromHex:self.hashValue atIndex:counter + 1 withLength:1];
                    
                    NSArray *values = @[[NSNumber numberWithInteger:i],
                                        [NSNumber numberWithInteger:j]];
                    
                    [self doInnerTrianglesX:x * triangleSize * 2
                                          y:y * triangleSize * 2
                                       size:triangleSize
                                     andVal:values];
                } else {
                    NSInteger i = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
                    NSArray *values = @[[NSNumber numberWithInteger:i]];
                    
                    [self doOuterTrianglesX:x * triangleSize * 2
                                          y:y * triangleSize * 2
                                       size:triangleSize
                                     andVal:values];
                }
            }
            
            counter++;
        }
    }
 }

- (void) generateChevrons {
    
    CGFloat width = [Helpers mapValue:[Helpers intFromHex:self.hashValue atIndex:0 withLength:1]
                      inRangeWithLower:0
                         andUpperBound:15
              toNewRangeWithLowerBound:30
                         andUpperBound:80];
    
    CGFloat height = width;
    
    NSInteger counter = 0, y, x;
    
    for (y=0; y<6; y++) {
        for (x=0; x<6; x++) {
            NSInteger val = [Helpers intFromHex:self.hashValue atIndex:counter withLength:1];
            CGFloat opacity = [Helpers opacity:val];
            UIColor *stroke = [[Helpers STROKE_COLOR]
                                colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
            UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
            CGFloat strokeWidth = 1;
            
            CGFloat tx = x * width, ty = y * height * 0.66 - height / 2;
            
            [ShapeDrawer drawChevronWithWidth:width
                                   withHeight:height
                                     withFill:fill
                                   withStroke:stroke
                                      atWidth:strokeWidth
                                     inConext:self.context
                             transformEffects:CGAffineTransformMakeTranslation(tx, ty)];
            
            if (y==0) {
                
                ty = 6 * height * 0.66 - height / 2;
                
                [ShapeDrawer drawChevronWithWidth:width
                                       withHeight:height
                                         withFill:fill
                                       withStroke:stroke
                                          atWidth:strokeWidth
                                         inConext:self.context
                                 transformEffects:CGAffineTransformMakeTranslation(tx, ty)];
            }
            
            counter++;
        }
    }
    
}

#pragma mark - Mosaic Triangle Helpers

- (void) doInnerTrianglesX: (NSInteger) x y: (NSInteger) y size: (CGFloat) size andVal: (NSArray *) values {
    NSInteger val = [[values objectAtIndex:0] integerValue];
    CGFloat opacity = [Helpers opacity:val];
    UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
    UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
    
    CGFloat tx = x + size,
    ty = y;
    CGPoint scale = CGPointMake(-1, 1);
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];
    
    tx = x + size;
    ty = y + size * 2;
    scale.x = 1;
    scale.y = -1;
    t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];
    
    // update vals
    val = [[values objectAtIndex:1] integerValue];
    opacity = [Helpers opacity: val];
    fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
    
    tx = x + size;
    ty = y + size * 2;
    scale.x = -1;
    scale.y = -1;
    
    t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];
    
    tx = x + size;
    ty = y;
    scale.x = 1;
    scale.y = 1;
    
    t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];

    
    
}

- (void) doOuterTrianglesX: (NSInteger) x y: (NSInteger) y size: (CGFloat) size andVal: (NSArray *) values {
    NSInteger val = [[values objectAtIndex:0] integerValue];
    CGFloat opacity = [Helpers opacity:val];
    UIColor *fill = [[Helpers fillColor:val] colorWithAlphaComponent:opacity];
    UIColor *stroke = [[Helpers STROKE_COLOR] colorWithAlphaComponent:[Helpers STROKE_OPACITY]];
    
    CGFloat tx = x,
    ty = y + size;
    
    CGPoint scale = CGPointMake(1, -1);
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];
    
    tx = x + size * 2;
    ty = y + size;
    scale.x = -1;
    scale.y = -1;
    t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];
    
    tx = x;
    ty = y + size;
    scale.x = 1;
    scale.y = 1;
    
    t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];
    
    tx = x + size * 2;
    ty = y + size;
    scale.x = -1;
    scale.y = 1;
    
    t = CGAffineTransformMakeTranslation(tx, ty);
    
    [ShapeDrawer drawRightTriangleWithLength:size
                               withFill:fill
                             withStroke:stroke
                                atWidth:1
                               inConext:self.context
                       transformEffects:CGAffineTransformScale(t, scale.x, scale.y)];
    
    
    
}
@end
