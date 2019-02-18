//
//  ViewController.m
//  CoreAnimationLyrics
//
//  Created by Annie Lee on 2019/2/15.
//  Copyright © 2019 Annie Lee. All rights reserved.
//

#import "ViewController.h"

#define TextLayerHeight 30

@interface ViewController ()
@property UIView *lyricsView;
@property NSInteger current;
@property NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.current = 0;
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    NSArray *lyrics = [self parseFile:@"Lyrics" type:@"txt"];
    
    [self setupLyricsView];
    
    [self addLyricsTextLayer:lyrics];
    
    [self setupPlayButton];
}

- (NSArray*)parseFile:(NSString*)file type:(NSString*)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    
    NSString *parseJson = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lyrics = [parseJson componentsSeparatedByString:@"\n"];
    
    return lyrics;
}

- (void)setupLyricsView
{
    self.lyricsView = [UIView new];
    self.lyricsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.lyricsView.clipsToBounds = YES;
    self.lyricsView.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.lyricsView];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.lyricsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[[UIScreen mainScreen] bounds].size.width];
    [self.view addConstraint:widthConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.lyricsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:500];
    [self.view addConstraint:heightConstraint];
    
    NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:self.lyricsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view addConstraint:verticalConstraint];
    
    NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:self.lyricsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraint:horizontalConstraint];
}

- (void)addLyricsTextLayer:(NSArray*)lyrics
{
    for (int i = 0; i < lyrics.count; i++) {
        
        CATextLayer *textLayer = [CATextLayer new];
        textLayer.frame = CGRectMake(0, i * TextLayerHeight, [[UIScreen mainScreen] bounds].size.width, TextLayerHeight);
        
        [textLayer setFont:@"Helvetica"];
        [textLayer setFontSize:20];
        [textLayer setString:lyrics[i]];
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        [textLayer setForegroundColor:[[UIColor whiteColor] CGColor]];
        [textLayer setBackgroundColor:[[UIColor darkGrayColor] CGColor]];

        [self.lyricsView.layer addSublayer:textLayer];
    }
}

- (void)updateLayers
{
    NSArray<CATextLayer *> *textLayers = self.lyricsView.layer.sublayers;
    
    for (int i = 0; i < textLayers.count; i++) {
        
        if (i == self.current) {

            [textLayers[i] setForegroundColor:[[UIColor blackColor] CGColor]];
            [textLayers[i] setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
            
            if (i != 0) {
                [textLayers[i-1] setForegroundColor:[[UIColor whiteColor] CGColor]];
                [textLayers[i-1] setBackgroundColor:[[UIColor darkGrayColor] CGColor]];
            }
        }
        
        if (self.current >= 9) {
            [self moveUpTextLayer:textLayers[i]];
        }
    }
}

- (void)moveUpTextLayer:(CATextLayer*)textlayer
{
    CGPoint originPosition = CGPointMake(textlayer.position.x, textlayer.position.y);
    CGPoint newPosition = CGPointMake(originPosition.x, originPosition.y - TextLayerHeight);

    CABasicAnimation *moveUp = [CABasicAnimation animationWithKeyPath:@"position"];
    moveUp.fromValue = [NSValue valueWithCGPoint:originPosition];
    moveUp.toValue = [NSValue valueWithCGPoint:newPosition];
    moveUp.duration   = 1.0;
    [textlayer addAnimation:moveUp forKey:moveUp.keyPath];
    
    textlayer.position = newPosition;
}

- (void)updateTimer:(NSTimer *)timer
{
    [self updateLayers];
    
    self.current++;
    
    if (self.current == self.lyricsView.layer.sublayers.count) {
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
}

- (void)setupPlayButton
{
    UIButton *button = [UIButton new];
    
    [button setTitle:@"PLAY" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 20;
    
    [button addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addSubview:button];
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(100)-[button]-(100)-|"
                                             options:NSLayoutFormatAlignAllCenterY
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(button)]];
    
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button(50)]-(100)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(button)]];
    
    [self.view addConstraints:constraints];
}

- (void)playButtonClick:(UIButton*)sender
{
    NSString *title = sender.titleLabel.text;
    
    if ([title isEqualToString:@"PLAY"]) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
    } else {
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    NSString *newTitle = [title isEqual:@"PLAY"]? @"PAUSE" : @"PLAY";
    [sender setTitle:newTitle forState:UIControlStateNormal];
}

@end
