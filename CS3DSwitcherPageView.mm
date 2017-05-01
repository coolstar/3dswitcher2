//
//  CS3DSwitcherPageView.m
//  SwitcherTest
//
//  Created by CoolStar on 2/22/17.
//  Copyright © 2017 CoolStar. All rights reserved.
//

#import "CS3DSwitcherPageView.h"
#import "CS3DSwitcherViewController.h"

@implementation CS3DSwitcherPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewTapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)pageViewTapped:(id)sender {
    [_switcherController switchToApp:self.superview];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect snapshotViewFrame = _snapshotView.frame;
	if (snapshotViewFrame.origin.x != 0 || snapshotViewFrame.origin.y != 0)
		_snapshotView.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
