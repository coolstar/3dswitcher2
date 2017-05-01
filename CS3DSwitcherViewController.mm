//
//  CS3DSwitcherViewController.m
//  SwitcherTest
//
//  Created by CoolStar on 2/21/17.
//  Copyright © 2017 CoolStar. All rights reserved.
//

#import "CS3DSwitcherViewController.h"
#import "CS3DSwitcherPageScrollView.h"

@interface CS3DSwitcherViewController ()

@end

@implementation CS3DSwitcherViewController

- (void)loadView {
    _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"org.coolstar.coverflowswitcher"];
    [_prefs registerDefaults:@{
        @"enabled": @YES,
        @"mode": @0,
        @"fadeIcons": @YES,
        @"scaleIcons": @YES,
        @"rollIcons": @NO
    }];

    self.view = [[UIView alloc] initWithFrame:_initialFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    
    _pageViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_items count]; i++){
        [_pageViews addObject:[NSNull null]];
    }

    [self createDestroyViews:0 isClosingView:NO];
    
    CGFloat itemsWidth = ([self _halfWidth] + 10.0f) * [_pageViews count];
    CGFloat contentWidth = itemsWidth + [self _halfWidth];
    _scrollView.contentSize = CGSizeMake(contentWidth, self.view.frame.size.height);
}

- (CGRect)frameForViewAtIndex:(NSInteger)index {
    CGFloat itemOffset = [self _halfWidth] / 2.0f;
    itemOffset += (([self _halfWidth] + 10.0f) * index);
    return CGRectMake(itemOffset, self.view.bounds.size.height/4.0f, [self _halfWidth], self.view.bounds.size.height / 2.0f);
}

- (void)closeView:(CS3DSwitcherPageScrollView *)scrollView {
    [self closeViewAtIndex:[_pageViews indexOfObject:scrollView] animated:YES];
}

- (void)switchToApp:(UIView *)pageView {
    NSInteger index = [_pageViews indexOfObject:pageView];

    __weak SBDisplayItem *displayItem = [_items objectAtIndex:index];
    SBDeckSwitcherItemContainer *itemContainer = [[objc_getClass("SBDeckSwitcherItemContainer") alloc] initWithFrame:CGRectZero displayItem:displayItem delegate:_deckSwitcher];
    [_deckSwitcher selectedDisplayItemOfContainer:itemContainer];
}

- (void)respringPrompt:(id)sender {
    UIAlertController* respringPrompt = [UIAlertController alertControllerWithTitle:@"Restart SpringBoard?"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* restartButton = [UIAlertAction actionWithTitle:@"Restart" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            _presentedAlertController = nil;
            [(FBSystemApp *)[objc_getClass("FBSystemApp") sharedApplication] sendActionsToBackboard:[NSSet setWithObject:[objc_getClass("BKSRestartAction") actionWithOptions:1]]];
        }];
    [respringPrompt addAction:restartButton];

    UIAlertAction* quitApps = [UIAlertAction actionWithTitle:@"Quit Apps" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            _presentedAlertController = nil;
            NSString *nowPlayingApp = [[((SBMediaController *)[objc_getClass("SBMediaController") sharedInstance]) nowPlayingApplication] bundleIdentifier];
            SBAppSwitcherModel *model = (SBAppSwitcherModel *)[objc_getClass("SBAppSwitcherModel") sharedInstance];
            NSMutableArray *recentDisplayItems = [model valueForKey:@"_recentDisplayItems"];
            NSArray *displayItemsCopy = [recentDisplayItems copy];
            SBApplicationController *controller = (SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance];
            for (SBDisplayItem *item in displayItemsCopy){
                NSString *appID = [item valueForKey:@"_displayIdentifier"];
                if (![appID isEqualToString:nowPlayingApp]){
                    SBApplication *app = [controller applicationWithBundleIdentifier:appID];
                    if ([app isRunning])
                        kill([app pid], SIGTERM); //iOS 9 doesn't kill the app automatically?
                    [model remove:item];
                }
            }
            [self switchToApp:[_pageViews objectAtIndex:0]];
        }];
    [respringPrompt addAction:quitApps];

    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
        handler:^(UIAlertAction * action) {
            _presentedAlertController = nil;
            CS3DSwitcherPageScrollView *homeScreenView = [_pageViews objectAtIndex:0];
            [homeScreenView setContentOffset:CGPointZero animated:YES];
            homeScreenView.iconView.transform = CGAffineTransformIdentity;
            homeScreenView.iconView.alpha = 1;
        }];
    [respringPrompt addAction:cancelBtn];
    [self presentViewController:respringPrompt animated:YES completion:nil];
    _presentedAlertController = respringPrompt;
}

- (void)closeViewAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index == 0){
        [self respringPrompt:nil];
        return;
    }

    [self createDestroyViews:index isClosingView:YES];
    
    __weak SBDisplayItem *displayItem = [_items objectAtIndex:index];

    NSString *displayIdentifier = displayItem.displayIdentifier;

    SBApplicationController *controller = (SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance];
    SBApplication *app = [controller applicationWithBundleIdentifier:displayIdentifier];
    if ([app isRunning])
        kill([app pid], SIGTERM); //iOS 9 doesn't kill the app automatically?

    __weak SBDisplayItem *itemToRemove = nil;
    for (SBDisplayItem *item in [_deckSwitcher displayItems]){
        if ([item.displayIdentifier isEqualToString:displayIdentifier])
            itemToRemove = item;
    }

    CS3DSwitcherPageScrollView *view = [_pageViews objectAtIndex:index];
    [view.iconView removeFromSuperview];
    view.iconView = nil;
    [view removeFromSuperview];

    SBMainSwitcherViewController *mainSwitcherController = [objc_getClass("SBMainSwitcherViewController") sharedInstance];

    SBDisplayItem *returnDisplayItem = [mainSwitcherController _returnToDisplayItem];
    NSString *returnDisplayIdentifier = returnDisplayItem.displayIdentifier;

    if ([displayIdentifier isEqualToString:returnDisplayIdentifier]){
        [mainSwitcherController _setReturnToDisplayItem:[[_deckSwitcher displayItems] objectAtIndex:0]];
    }

    [_pageViews removeObjectAtIndex:index];
    [_items removeObject:displayItem];

    [(SBAppSwitcherModel *)[objc_getClass("SBAppSwitcherModel") sharedInstance] remove:itemToRemove];
    
    [UIView animateWithDuration:(animated ? 0.25 : 0.0) animations:^{
        int i = 0;
        for (CS3DSwitcherPageScrollView *pageView in _pageViews) {
            if (i >= index && ![pageView isKindOfClass:[NSNull class]]){
                CGRect frame = [self frameForViewAtIndex:i];
                pageView.frame = frame;

                CGRect iconViewFrame = pageView.iconView.frame;
                iconViewFrame.origin.x = frame.origin.x + (frame.size.width - 100.0f)/2.0f;
                pageView.iconView.frame = iconViewFrame;
            }
            i++;
        }
        [self scrollViewDidScroll:_scrollView];
    } completion:^(BOOL finished) {
        CGFloat itemsWidth = ([self _halfWidth] + 10.0f) * [_pageViews count];
        CGFloat contentWidth = itemsWidth + [self _halfWidth];
        _scrollView.contentSize = CGSizeMake(contentWidth, self.view.frame.size.height);
        [self scrollViewDidScroll:_scrollView];
    }];
}

- (UIView *)createViewAtIndex:(NSInteger)index {
    SBDisplayItem *displayItem = [_items objectAtIndex:index];

    CS3DSwitcherPageScrollView *pageView = [[CS3DSwitcherPageScrollView alloc] initWithFrame:[self frameForViewAtIndex:index]];
    pageView.switcherController = self;

    UIView *pageSnapshotView = nil;
        if (index == 0){
        SBDeckSwitcherPageViewProvider *provider = [_deckSwitcher valueForKey:@"_pageViewProvider"];
        pageSnapshotView = [provider pageViewForDisplayItem:displayItem synchronously:NO];
    } else {
        pageSnapshotView = [[UIView alloc] initWithFrame:self.view.bounds];
        SBDeckSwitcherPageViewProvider *provider = [_deckSwitcher valueForKey:@"_pageViewProvider"];

        UIView *snapshot = nil;

        NSString *appID = [displayItem valueForKey:@"_displayIdentifier"];
        SBApplication *app = [(SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:appID];
        if ([app isRunning])
            snapshot = [provider pageViewForDisplayItem:displayItem synchronously:NO];
        else
            snapshot = [provider _snapshotViewForDisplayItem:displayItem preferringDownscaledSnapshot:NO synchronously:NO];
        [pageSnapshotView addSubview:snapshot];
    }
    [pageSnapshotView removeFromSuperview];
    [pageView.pageView addSubview:pageSnapshotView];
    pageSnapshotView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    pageSnapshotView.frame = pageView.pageView.bounds;
    pageView.pageView.snapshotView = pageSnapshotView;
    pageSnapshotView.userInteractionEnabled = NO;

    pageView.iconView = [[UIView alloc] initWithFrame:CGRectMake(pageView.frame.origin.x + (pageView.frame.size.width - 100.0f)/2.0f, pageView.frame.origin.y + pageView.frame.size.height + 15, 100, 90)];
    
    pageView.iconView.layer.zPosition = 100;

    if (index != 0){
        SBIconView *iconView = [[objc_getClass("SBIconView") alloc] initWithContentType:0];
        NSString *displayIdentifier = displayItem.displayIdentifier;
        SBApplication *app = [(SBApplicationController *)[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:displayIdentifier];
        iconView.icon = [[objc_getClass("SBApplicationIcon") alloc] initWithApplication:app];
        iconView.delegate = self;
        [pageView.iconView addSubview:iconView];

        CGRect iconViewFrame = iconView.frame;
        iconViewFrame.origin.x = (pageView.iconView.frame.size.width - iconViewFrame.size.width)/2.0f;
        iconViewFrame.origin.y = 0;
        iconView.frame = iconViewFrame;
    }

    [_scrollView addSubview:pageView];
    [_scrollView addSubview:pageView.iconView];
    return pageView;
}

- (void)createDestroyViews:(NSInteger)centerIdx isClosingView:(BOOL)closing {
    NSInteger minIdx = centerIdx - 2;
    NSInteger maxIdx = centerIdx + (closing ? 3 : 2);

    NSInteger minExtendedIdx = centerIdx - 5;
    NSInteger maxExtendedIdx = centerIdx + (closing ? 8 : 6);

    if (minIdx < 0)
        minIdx = 0;
    if (minExtendedIdx < 0)
        minExtendedIdx = 0;
    if (maxIdx > [_items count])
        maxIdx = [_items count];
    if (maxExtendedIdx > [_items count])
        maxExtendedIdx = [_items count];
    
    NSMutableArray *_objectsToRemove = [NSMutableArray array];
    NSMutableArray *_objectsToCreate = [NSMutableArray array];
    
    int x = 0;
    for (id view in _pageViews) {
        if (x < minIdx || x > maxIdx){
            if (x < minExtendedIdx || x > maxExtendedIdx){
                if (![view isKindOfClass:[NSNull class]])
                    [_objectsToRemove addObject:[NSNumber numberWithInt:x]];
            }
        } else {
            if ([view isKindOfClass:[NSNull class]])
                [_objectsToCreate addObject:[NSNumber numberWithInt:x]];
        }
        x++;
    }
    
    for (NSNumber *idxNum in _objectsToRemove){
        NSInteger idx = [idxNum integerValue];
        CS3DSwitcherPageScrollView *view = [_pageViews objectAtIndex:idx];
        [view.iconView removeFromSuperview];
        view.iconView = nil;
        [view removeFromSuperview];
        [_pageViews replaceObjectAtIndex:idx withObject:[NSNull null]];
    }
    
    for (NSNumber *idxNum in _objectsToCreate){
        NSInteger idx = [idxNum integerValue];
        UIView *view = [self createViewAtIndex:idx];
        [_pageViews replaceObjectAtIndex:idx withObject:view];
    }
}

- (CGFloat)_halfWidth {
    return self.view.frame.size.width / 2.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat centerIndex = (scrollView.contentOffset.x) / ([self _halfWidth] + 10.0f);
    NSInteger centerIdxInt = (NSInteger)centerIndex;
    if (centerIndex - centerIdxInt > 0.5)
        centerIdxInt++;
    
    [self createDestroyViews:centerIdxInt isClosingView:NO];

    NSInteger mode = [_prefs integerForKey:@"mode"];
    
    BOOL closerItems = NO;
    BOOL useFull3D = NO;
    BOOL invert3D = NO;
    BOOL useTrueCoverFlow = NO;
    BOOL useHalfAngle = NO;
    BOOL use2DMode = NO;
    
    if (mode == 0){
        useFull3D = YES;
        invert3D = NO;
    } else if (mode == 1){
        useFull3D = NO;
        invert3D = NO;
    } else if (mode == 2){
        useFull3D = NO;
        invert3D = NO;
        useTrueCoverFlow = YES;
    } else if (mode == 3){
        useFull3D = NO;
        invert3D = YES;
        useTrueCoverFlow = YES;
    } else if (mode == 4){
        useFull3D = NO;
        invert3D = NO;
        useTrueCoverFlow = YES;
        useHalfAngle = YES;
    } else if (mode == 5){
        useFull3D = NO;
        invert3D = YES;
        useTrueCoverFlow = YES;
        useHalfAngle = YES;
    } else if (mode == 6){
        use2DMode = YES;
    }
    
    BOOL fadeIcons = [_prefs boolForKey:@"fadeIcons"];
    BOOL rollIcons = [_prefs boolForKey:@"rollIcons"];
    BOOL scaleIcons = [_prefs boolForKey:@"scaleIcons"];
    
    CGFloat center = [scrollView contentOffset].x + (scrollView.frame.size.width/2.0f);
    
    int y = 0;
    for (CS3DSwitcherPageScrollView *pageView in _pageViews){
        if ([pageView isKindOfClass:[NSNull class]]){
            y++;
            continue;
        }
        
        if (y == centerIndex)
            pageView.layer.zPosition = 2;
        else if (y == centerIndex+1)
            pageView.layer.zPosition = 1;
        else if (y == centerIndex-1)
            pageView.layer.zPosition = 1;
        else
            pageView.layer.zPosition = 0;
        
        CGRect frame = pageView.frame;
        CGFloat centerOfView = frame.origin.x + (frame.size.width/2.0f);
        
        CGFloat difference = centerOfView-center;
        
        CGFloat threshold = scrollView.superview.frame.size.width/1.9f;
        if (difference > threshold)
            difference = threshold;
        if (difference < -threshold)
            difference = -threshold;
        
        CGFloat maxAngle = M_PI/6.0f;
        if (useTrueCoverFlow){
            if (useHalfAngle)
                maxAngle = M_PI/8.f;
            else
                maxAngle = M_PI/4.f;
        }
        CGFloat angle = (maxAngle) * (difference/threshold);
        if (angle < 0)
            angle = (M_PI*2.0f)-angle;
        
        CGFloat yShift = 0.0;
        yShift = difference/50.0f;
        if (difference > 50)
            yShift = 1.0;
        if (difference < -50)
            yShift = -1.0;
        
        CGFloat scale = 1.0f - fabsf((float)difference)/600.f;
        
        CATransform3D transform = CATransform3DIdentity;
        if (use2DMode){

        }
        else if (useFull3D){
            transform.m34 = -1/500.0;
            transform = CATransform3DRotate(transform, angle, 1.0f, yShift, 0.0f);
            transform = CATransform3DScale(transform, scale, scale, scale);
            transform = CATransform3DTranslate(transform, 0, -(1.0f-scale)*10.0f, 0);
        } else {
            if (useTrueCoverFlow){
                if (invert3D){
                    if (difference < 0)
                        transform.m34 = 1/500.0;
                    else
                        transform.m34 = -1/500.0;
                } else {
                    if (difference < 0)
                        transform.m34 = -1/500.0;
                    else
                        transform.m34 = 1/500.0;
                }
                transform = CATransform3DRotate(transform, angle, 0.0f, 1.0f, 0.0f);
            }
            else
                transform = CATransform3DRotate(transform, angle, 1.0f, 0.0f, 0.0f);
        }
        if (closerItems){
            float zTransform = fabsf((float)difference*25.0f/(float)threshold*-1.0f);
            transform = CATransform3DTranslate(transform, 0, 0, zTransform);
        }
        pageView.layer.transform = transform;
        
        CGFloat distanceBetweenCenters = [self _halfWidth] + 10.0f;
        
        if (fabs(distanceBetweenCenters - difference) < 1){
            difference = distanceBetweenCenters;
        }

        if (rollIcons)
            pageView.iconView.transform = CGAffineTransformMakeRotation((difference/distanceBetweenCenters)*2.0f*M_PI);
        else
            pageView.iconView.transform = CGAffineTransformIdentity;
        
        if (scaleIcons){
            CGFloat scale = 1.0f - fabsf(0.25f*(float)(difference/distanceBetweenCenters));
            pageView.iconView.transform = CGAffineTransformScale(pageView.iconView.transform, scale, scale);
        }
        
        if (fadeIcons)
            pageView.iconView.alpha = 1.0f - (fabsf((float)difference)/threshold);
        else
            pageView.iconView.alpha = 1.0f;
        y++;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat centerIndex = (targetContentOffset->x) / ([self _halfWidth] + 10.0f);
    NSInteger centerIdxInt = (NSInteger)centerIndex;
    if (centerIndex - centerIdxInt > 0.5)
        centerIdxInt++;
    CGFloat centerPoint = ([self _halfWidth] + 10.0f) * centerIdxInt;
    targetContentOffset->x = centerPoint;
}

- (void)scrollToIndex:(NSInteger)centerIndex animated:(BOOL)animated {
    CGFloat centerPoint = ([self _halfWidth] + 10.0f) * centerIndex;
    [_scrollView setContentOffset:CGPointMake(centerPoint, 0) animated:animated];
    [self scrollViewDidScroll:_scrollView];
}

- (void)dismissToIndex:(NSInteger)centerIndex animated:(BOOL)animated {
    if (_presentedAlertController){
        [_presentedAlertController dismissViewControllerAnimated:YES completion:nil];
        _presentedAlertController = nil;
    }

    _scrollView.userInteractionEnabled = NO;
    [self scrollToIndex:centerIndex animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Icon View delegate
- (void)iconTapped:(SBIconView *)view
{
    NSString *appIdentifier = [[view icon] leafIdentifier];
    __weak SBDisplayItem *itemToSwitchTo = nil;
    for (SBDisplayItem *item in [_deckSwitcher displayItems]){
        if ([item.displayIdentifier isEqualToString:appIdentifier])
            itemToSwitchTo = item;
    }
    SBDeckSwitcherItemContainer *itemContainer = [[objc_getClass("SBDeckSwitcherItemContainer") alloc] initWithFrame:CGRectZero displayItem:itemToSwitchTo delegate:_deckSwitcher];
    [_deckSwitcher selectedDisplayItemOfContainer:itemContainer];
}

- (BOOL)iconShouldAllowTap:(SBIconView *)view {
    return YES;
}

- (void)iconTouchBegan:(SBIconView *)icon {
    [icon setHighlighted:YES];
}

- (void)icon:(SBIconView *)icon touchEnded:(BOOL)ended {
    [icon setHighlighted:NO];
}

@end
