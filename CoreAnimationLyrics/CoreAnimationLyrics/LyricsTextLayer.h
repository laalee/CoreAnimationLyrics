//
//  LyricsTextLayer.h
//  CoreAnimationLyrics
//
//  Created by Annie Lee on 2019/3/4.
//  Copyright © 2019 Annie Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface LyricsTextLayer : CATextLayer
@property (strong, nonatomic) UIAccessibilityElement *accessibilityElement;
@end

NS_ASSUME_NONNULL_END
