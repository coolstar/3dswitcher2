//
//  CS3DSwitcherPageScrollView.m
//  SwitcherTest
//
//  Created by CoolStar on 2/22/17.
//  Copyright © 2017 CoolStar. All rights reserved.
//

#import "CS3DSwitcherPageScrollView.h"
#import "CS3DSwitcherViewController.h"

@implementation CS3DSwitcherPageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = NO;
        self.delegate = self;
        
        CGRect pageFrame = self.bounds;
        _pageView = [[CS3DSwitcherPageView alloc] initWithFrame:pageFrame];
        [self addSubview:_pageView];
        
        self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height * 3);
    }
    return self;
}

- (void)setSwitcherController:(CS3DSwitcherViewController *)switcherController {
    _switcherController = switcherController;
    _pageView.switcherController = switcherController;
    
}

- (void)animateClose {
    CGPoint offset = CGPointMake(0, self.bounds.size.height * 2);
    [UIView animateWithDuration:0.35 animations:^{
        [self setContentOffset:offset animated:NO];
        self.iconView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.iconView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_switcherController closeView:self];
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset->y > self.bounds.size.height * 0.75){
        targetContentOffset->y = self.bounds.size.height * 2;
        [self animateClose];
    } else {
        targetContentOffset->y = 0;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.bounds.size.height){
        [self animateClose];
    } else {
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
