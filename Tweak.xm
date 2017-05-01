#import "Headers.h"
#import "CS3DSwitcherViewController.h"

static CS3DSwitcherViewController *switcher3DController;
static NSUserDefaults *coverFlowSwitcherPrefs;

%hook SBDeckSwitcherViewController

- (void)animatePresentationForTransitionRequest:(id)arg1 withCompletion:(id)arg2 {
	%orig;
	if ([self isKindOfClass:[%c(KazeQuickSwitcherDeckViewController) class]] || [self isKindOfClass:[%c(KazeHomeScreenDeckViewController) class]])
		return;
	if (![coverFlowSwitcherPrefs boolForKey:@"enabled"])
		return;
	UIScrollView *scrollView = [self valueForKey:@"_scrollView"];
	[scrollView setAlpha:0];

	SBDisplayItem *displayItem = [self valueForKey:@"_initialDisplayItem"];

	NSMutableArray *displayItems = [self displayItems];

	switcher3DController = [[CS3DSwitcherViewController alloc] init];
	switcher3DController.items = [displayItems mutableCopy];
	switcher3DController.deckSwitcher = self;
	switcher3DController.initialFrame = self.view.bounds;
    UIView *switcherView = [switcher3DController view];
    switcherView.frame = self.view.bounds;
    [self.view insertSubview:switcherView aboveSubview:scrollView];
    [self addChildViewController:switcher3DController];

    NSUInteger index = [displayItems indexOfObject:displayItem];

    [switcher3DController createDestroyViews:index isClosingView:NO];
    [switcher3DController scrollToIndex:index animated:NO];

    switcherView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);

    NSUInteger presentIndex = index+1;
    if (presentIndex >= [displayItems count])
    	presentIndex = [displayItems count] - 1;

    [UIView animateWithDuration:0.3 animations:^{
        switcherView.transform = CGAffineTransformIdentity;
        [switcher3DController scrollToIndex:presentIndex animated:NO];
    }];
}

- (void)animateDismissalToDisplayItem:(SBDisplayItem *)displayItem forTransitionRequest:(id)arg2 withCompletion:(id)arg3
{
	if (![coverFlowSwitcherPrefs boolForKey:@"enabled"]){
		%orig;
		return;
	}
	if ([self isKindOfClass:[%c(KazeQuickSwitcherDeckViewController) class]] || [self isKindOfClass:[%c(KazeHomeScreenDeckViewController) class]]){
		%orig;
		return;
	}

	NSUInteger index = [switcher3DController.items indexOfObject:displayItem];
	[switcher3DController dismissToIndex:index animated:YES];
	%orig(displayItem, arg2, arg3);
}

- (void)invalidate {
	if (![coverFlowSwitcherPrefs boolForKey:@"enabled"]){
		%orig;
		return;
	}
	if ([self isKindOfClass:[%c(KazeQuickSwitcherDeckViewController) class]] || [self isKindOfClass:[%c(KazeHomeScreenDeckViewController) class]]){
		%orig;
		return;
	}
	[switcher3DController.view removeFromSuperview];
	[switcher3DController removeFromParentViewController];
	switcher3DController.deckSwitcher = nil;
	switcher3DController.items = nil;

	switcher3DController = nil;
	%orig;
}
%end

%ctor
{
	coverFlowSwitcherPrefs = [[NSUserDefaults alloc] initWithSuiteName:@"org.coolstar.coverflowswitcher"];
    [coverFlowSwitcherPrefs registerDefaults:@{
        @"enabled": @YES,
        @"mode": @0,
        @"fadeIcons": @YES,
        @"scaleIcons": @YES,
        @"rollIcons": @NO
    }];
	%init();
}