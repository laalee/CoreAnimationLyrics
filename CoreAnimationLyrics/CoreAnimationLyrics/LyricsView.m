//
//  LyricsView.m
//  CoreAnimationLyrics
//
//  Created by Annie Lee on 2019/2/18.
//  Copyright © 2019 Annie Lee. All rights reserved.
//

#import "LyricsView.h"
#import "LyricsTextLayer.h"

@interface LyricsView ()
{
    NSMutableArray *layerArray;
}
@end

@implementation LyricsView

- (void)addLyricsTextLayer:(NSArray*)lyrics
{
    self.layer.sublayers = nil;
    
    layerArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < lyrics.count; i++) {
        
        LyricsTextLayer *textLayer = [LyricsTextLayer new];
        textLayer.frame = CGRectMake(0, i * TextLayerHeight, [[UIScreen mainScreen] bounds].size.width, TextLayerHeight);
        
        [textLayer setFont:@"Helvetica"];
        [textLayer setFontSize:20];
        [textLayer setString:lyrics[i]];
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        [textLayer setForegroundColor:[[UIColor whiteColor] CGColor]];
        [textLayer setBackgroundColor:[[UIColor darkGrayColor] CGColor]];
        
        [self.layer addSublayer:textLayer];
        
        if (i < firstLine) {
            continue;
        }
        
        UIAccessibilityElement *element = [[UIAccessibilityElement alloc]
                                             initWithAccessibilityContainer:self];
        element.accessibilityLabel = lyrics[i];
        element.accessibilityIdentifier = [NSString stringWithFormat:@"Lyrics %lu", (unsigned long)index];
        element.accessibilityTraits = UIAccessibilityTraitNone;
        textLayer.accessibilityElement = element;

        [layerArray addObject:textLayer];
    }
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);

}

- (NSInteger)centerLine
{
    return (NSInteger)self.frame.size.height / 30 / 2;
}

- (void)updateLayersWithHighlightLine:(NSInteger)line
{
    NSArray<CATextLayer *> *textLayers = self.layer.sublayers;
    
    NSInteger centerLine = [self centerLine];
    
    NSInteger distance = textLayers[line].position.y - self.frame.size.height / 2;
    
    for (int i = 0; i < textLayers.count; i++) {
        
        [textLayers[i] setForegroundColor:[[UIColor whiteColor] CGColor]];
        [textLayers[i] setBackgroundColor:[[UIColor darkGrayColor] CGColor]];
        
        if (line > centerLine) {
            
            CGPoint newPosition = CGPointMake(textLayers[i].position.x, textLayers[i].position.y - distance);
            
            [self moveUpTextLayer:textLayers[i] toNewPosition:newPosition];
        }
    }
    
    [textLayers[line] setForegroundColor:[[UIColor blackColor] CGColor]];
    [textLayers[line] setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
}

- (void)moveUpTextLayer:(CATextLayer*)textlayer toNewPosition:(CGPoint)newPosition
{
    CABasicAnimation *moveUp = [CABasicAnimation animationWithKeyPath:@"position"];
    moveUp.fromValue = [NSValue valueWithCGPoint:textlayer.position];
    moveUp.toValue = [NSValue valueWithCGPoint:newPosition];
    moveUp.duration   = 1.0;
    [textlayer addAnimation:moveUp forKey:moveUp.keyPath];
    
    textlayer.position = newPosition;
}

#pragma mark - accessibility

- (BOOL)isAccessibilityElement
{
    return NO;
}

- (NSInteger)accessibilityElementCount
{
    return [layerArray count];
}

- (id)accessibilityElementAtIndex:(NSInteger)index
{
    LyricsTextLayer *aLayer = layerArray[index];
    CGRect frame = aLayer.frame;
    aLayer.accessibilityElement.accessibilityFrame = [[UIApplication sharedApplication].keyWindow convertRect:frame fromView:self];
    return aLayer.accessibilityElement;
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
    NSInteger index = 0;
    for (LyricsTextLayer *aLayer in layerArray) {
        if ([aLayer.accessibilityElement isEqual:element]) {
            return index;
        }
        index++;
    }
    return NSNotFound;
}

@end
