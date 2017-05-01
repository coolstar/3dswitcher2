//
//  CS3DSwitcherPageView.h
//  SwitcherTest
//
//  Created by CoolStar on 2/22/17.
//  Copyright © 2017 CoolStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CS3DSwitcherViewController;
@interface CS3DSwitcherPageView : UIView {
    UIView *_iconView;
    UIView *_snapshotView;
}
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) UIView *snapshotView;
@property (nonatomic, weak) CS3DSwitcherViewController *switcherController;
@end
