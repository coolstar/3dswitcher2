#import <Twitter/Twitter.h>

@interface PSListController : UITableViewController {
	NSArray *_specifiers;
}
- (NSArray *)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
- (UITableView *)table;
@end

@interface CS3DSwitcherEEController : UIViewController
@end

@interface CS3DSwitcherListController: PSListController {
}
@end

@implementation CS3DSwitcherListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"3DSwitcher" target:self] retain];
	}
	return _specifiers;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,-495,self.view.bounds.size.width, [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 570 : 550)];
	headerView.tag = 23491234;
	headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[headerView setBackgroundColor:[UIColor whiteColor]];

	UIView *titleContainer = [[UIView alloc] initWithFrame:CGRectMake(0,505,320,55)];
	titleContainer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,30)];
	[button setTitle:@"totally not CoolStar working on 3DSwitcher2" forState:UIControlStateNormal];
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	button.exclusiveTouch = YES;
	[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(easterEgg:) forControlEvents:UIControlEventTouchDown];
	[headerView addSubview:[button autorelease]];

	UILabel *okFine = [[UILabel alloc] initWithFrame:CGRectMake(0,75,self.view.bounds.size.width,30)];
	okFine.text = @"ok, fine. Scroll further to find it. Happy?";
	okFine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	okFine.textAlignment = UITextAlignmentCenter;
	[headerView addSubview:[okFine autorelease]];

	UILabel *lookingForSomething = [[UILabel alloc] initWithFrame:CGRectMake(0,150,self.view.bounds.size.width,30)];
	lookingForSomething.text = @"lost something up here?";
	lookingForSomething.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	lookingForSomething.textAlignment = UITextAlignmentCenter;
	[headerView addSubview:[lookingForSomething autorelease]];

	UILabel *fine = [[UILabel alloc] initWithFrame:CGRectMake(0,225,self.view.bounds.size.width,30)];
	fine.text = @"fine, that's all here";
	fine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	fine.textAlignment = UITextAlignmentCenter;
	[headerView addSubview:[fine autorelease]];

	UILabel *getBackDownthere = [[UILabel alloc] initWithFrame:CGRectMake(0,350,self.view.bounds.size.width,30)];
	getBackDownthere.text = @"get back down there!";
	getBackDownthere.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	getBackDownthere.textAlignment = UITextAlignmentCenter;
	[headerView addSubview:[getBackDownthere autorelease]];

	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 55, 55)];
	[imageView setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/3DSwitcher.bundle/3DSwitcher-large.png"]];
	[titleContainer addSubview:[imageView autorelease]];

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(85,0,225,55)];
	label.text = @"3D Switcher 2";
	label.font = [UIFont systemFontOfSize:36];
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	[titleContainer addSubview:[label autorelease]];

	[headerView addSubview:[titleContainer autorelease]];
	[[self table] addSubview:[headerView autorelease]];
	[[self table] setContentOffset:CGPointMake(0,0)];

	[[self navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/3DSwitcher.bundle/heart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tweet:)] autorelease]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	CGPoint offset = [scrollView contentOffset];
	if (offset.y < -550)
		[scrollView setContentInset:UIEdgeInsetsMake(570, 0, 0, 0)];
	else
		[scrollView setContentInset:UIEdgeInsetsMake(60, 0, 0, 0)];
}

- (void)tweet:(id)sender {
	if ([TWTweetComposeViewController canSendTweet])
	{
		TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
    	[tweetSheet setInitialText:@"I am loving #3DSwitcher2 by @coolstarorg!"];
    	[self presentModalViewController:[tweetSheet autorelease] animated:YES];
    } else {
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"You don't have any accounts configured. Please configure an account in Settings > Twitter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    	[alert show];
    	[alert release];
    }
}

- (void)coolstarTwitter:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/coolstarorg"]];
}

- (void)jeremyGouletTwitter:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/JeremyGoulet"]];
}

- (void)easterEgg:(id)sender {
	CS3DSwitcherEEController *easterEggController = [[CS3DSwitcherEEController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[easterEggController autorelease]];
	[self presentViewController:navController animated:YES completion:nil];
}

@end

// vim:ft=objc
