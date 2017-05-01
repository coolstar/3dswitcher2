#import "Selfie.h"

@interface CS3DSwitcherEEController : UIViewController <UIAlertViewDelegate>
@end

@implementation CS3DSwitcherEEController
- (void)loadView {
	self.title = @"totally not coolstar";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)] autorelease];

	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,568)] autorelease];
	self.view.backgroundColor = [UIColor whiteColor];

	UIImageView *selfieImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
	selfieImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:selfieURL]]];
	selfieImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	selfieImage.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:selfieImage];

	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
	tapRecognizer.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer:[tapRecognizer autorelease]];
}

- (void)dismiss:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageTapped:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fine" message:@"You really don't stop, do you? Fine, here's CoolStar's favorite songs." delegate:self cancelButtonTitle:nil otherButtonTitles:@"a",@"b",@"c",nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex){
		case 0:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=LSZb70G33M8"]];
			break;
		case 1:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=jT2ceoLrGPY"]];
			break;
		case 2:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=L1BJS3qSHfQ"]];
			break;
	}
}
@end