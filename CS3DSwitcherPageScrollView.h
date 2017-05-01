//
//  CS3DSwitcherPageScrollView.h
//  SwitcherTest
//
//  Created by CoolStar on 2/22/17.
//  Copyright © 2017 CoolStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CS3DSwitcherPageView.h"

@class CS3DSwitcherViewController;
@interface CS3DSwitcherPageScrollView : UIScrollView <UIScrollViewDelegate> {
    UIView *_iconView;
    CS3DSwitcherPageView *_pageView;
    __weak CS3DSwitcherViewController *_switcherController;
}
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) CS3DSwitcherPageView *pageView;
@property (nonatomic, weak) CS3DSwitcherViewController *switcherController;
@end
