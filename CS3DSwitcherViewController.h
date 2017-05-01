//
//  CS3DSwitcherViewController.h
//  SwitcherTest
//
//  Created by CoolStar on 2/21/17.
//  Copyright © 2017 CoolStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"

@class CS3DSwitcherPageScrollView;
@class SBDeckSwitcherViewController;
@interface CS3DSwitcherViewController : UIViewController <UIScrollViewDelegate, SBIconViewDelegate> {
	CGRect _initialFrame;
    UIScrollView *_scrollView;
    NSMutableArray *_items;
    NSMutableArray *_pageViews;
    SBDeckSwitcherViewController *_deckSwitcher;
    NSUserDefaults *_prefs;
    UIAlertController *_presentedAlertController;
}

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) SBDeckSwitcherViewController *deckSwitcher;
@property (nonatomic, assign) CGRect initialFrame;

- (void)closeView:(CS3DSwitcherPageScrollView *)scrollView;
- (void)closeViewAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToIndex:(NSInteger)centerIndex animated:(BOOL)animated;
- (void)switchToApp:(UIView *)pageView;
- (void)dismissToIndex:(NSInteger)centerIndex animated:(BOOL)animated;
- (void)createDestroyViews:(NSInteger)centerIdx isClosingView:(BOOL)closing;

@end
