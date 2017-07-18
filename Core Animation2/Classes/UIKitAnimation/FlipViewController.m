
#import "FlipViewController.h"

@implementation FlipViewController

+ (NSString *)displayName {
	return @"Flip Views";
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = [[self class] displayName];
    // Set the background color for the window.  The user will see the window's background color on the transition.
	UIColor *backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
	[UIApplication sharedApplication].keyWindow.backgroundColor = backgroundColor;
	
	frontView = [[UIView alloc] initWithFrame:self.view.bounds];
	frontView.backgroundColor = [UIColor colorWithRed:0.345 green:0.349 blue:0.365 alpha:1.000];
	UIImageView *caLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caLogo.png"]];
	caLogoView.frame = CGRectMake(70, 80, caLogoView.bounds.size.width, caLogoView.bounds.size.height);

	[frontView addSubview:caLogoView];
	
	UIImage *backImage = [UIImage imageNamed:@"backView.png"];
	backView = [[UIImageView alloc] initWithImage:backImage];
	backView.userInteractionEnabled = YES;
	
	[self.view addSubview:backView];
	[self.view addSubview:frontView];
	
	displayingFrontView = YES;
	
	UIGestureRecognizer *frontViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipViews)];
	UIGestureRecognizer *backViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipViews)];
	[frontView addGestureRecognizer:frontViewTapRecognizer];
	[backView addGestureRecognizer:backViewTapRecognizer];
	[frontViewTapRecognizer release];
	[backViewTapRecognizer release];
}

- (void)flipViews {
	[UIView transitionFromView:(displayingFrontView) ? frontView : backView
						toView:(displayingFrontView) ? backView : frontView
					  duration:0.75 
					   options:(displayingFrontView ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft)
					completion:^(BOOL finished) {
						if (finished) {
							displayingFrontView = !displayingFrontView;
						}
					}];
}

- (void)dealloc {
	[frontView release];
	[backView release];
	[UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    [super dealloc];
}


@end
