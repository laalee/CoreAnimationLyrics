//
//  LyricsView.m
//  CoreAnimationLyrics
//
//  Created by Annie Lee on 2019/2/18.
//  Copyright © 2019 Annie Lee. All rights reserved.
//

#import "LyricsView.h"

@implementation LyricsView

- (void)addLyricsTextLayer:(NSArray*)lyrics
{
    self.layer.sublayers = nil;
    
    for (int i = 0; i < lyrics.count; i++) {
        
        CATextLayer *textLayer = [CATextLayer new];
        textLayer.frame = CGRectMake(0, i * TextLayerHeight, [[UIScreen mainScreen] bounds].size.width, TextLayerHeight);
        
        [textLayer setFont:@"Helvetica"];
        [textLayer setFontSize:20];
        [textLayer setString:lyrics[i]];
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        [textLayer setForegroundColor:[[UIColor whiteColor] CGColor]];
        [textLayer setBackgroundColor:[[UIColor darkGrayColor] CGColor]];
        
        [self.layer addSublayer:textLayer];
    }
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

@end
