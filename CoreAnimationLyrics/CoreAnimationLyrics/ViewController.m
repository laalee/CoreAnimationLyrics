//
//  ViewController.m
//  CoreAnimationLyrics
//
//  Created by Annie Lee on 2019/2/15.
//  Copyright © 2019 Annie Lee. All rights reserved.
//

#import "ViewController.h"
#import "LyricsView.h"

#define PlayButtonTitle @"PLAY"
#define PauseButtonTitle @"PAUSE"

@interface ViewController ()
@property LyricsView *lyricsView;
@property NSInteger currentLine;
@property NSTimer *timer;
@property UIButton *playButton;
@property NSArray<NSString*> *lyrics;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentLine = 0;
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    [self setupLyricsView];
    
    [self setLyrics];

    [self setupPlayButton];
}

- (void)setLyrics
{
    self.lyrics = [self parseFile:@"Lyrics" type:@"txt"];
    
    [self.lyricsView addLyricsTextLayer:self.lyrics];
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
    self.lyricsView = [LyricsView new];
    self.lyricsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.lyricsView.clipsToBounds = YES;
    self.lyricsView.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.lyricsView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lyricsView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lyricsView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lyricsView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:150]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lyricsView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-150]];
}

- (void)updateTimer:(NSTimer *)timer
{
    if (self.currentLine >= self.lyrics.count) {
        
        [self.timer invalidate];
        
        self.timer = nil;
        
        [self.playButton setTitle:PlayButtonTitle forState:UIControlStateNormal];
    
    } else {
        
        [self.lyricsView updateLayersWithHighlightLine:self.currentLine];
        
        self.currentLine += 1;
    }
}

- (void)setupPlayButton
{
    UIButton *button = [UIButton new];
    self.playButton = button;
    
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button(50)]-(70)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(button)]];
    
    [self.view addConstraints:constraints];
}

- (void)playButtonClick:(UIButton*)sender
{
    NSString *title = sender.titleLabel.text;
    
    if ([title isEqualToString:PlayButtonTitle]) {

        if (self.currentLine >= self.lyrics.count) {
            
            self.currentLine = 0;
            
            [self setLyrics];
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
    } else {
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    NSString *newTitle = [title isEqual:PlayButtonTitle]? PauseButtonTitle : PlayButtonTitle;
    [sender setTitle:newTitle forState:UIControlStateNormal];
}

@end
