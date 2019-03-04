//
//  LyricsView.h
//  CoreAnimationLyrics
//
//  Created by Annie Lee on 2019/2/18.
//  Copyright © 2019 Annie Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TextLayerHeight 30
#define firstLine 6

NS_ASSUME_NONNULL_BEGIN

@interface LyricsView : UIView
- (void)addLyricsTextLayer:(NSArray*)lyrics;
- (void)updateLayersWithHighlightLine:(NSInteger)line;
@end

NS_ASSUME_NONNULL_END
