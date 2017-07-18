
#import "SimpleViewPropertyAnimation.h"


@implementation SimpleViewPropertyAnimation

+ (NSString *)displayName {
	return @"Block-based Animations";
}

- (UIGestureRecognizer *)createTapRecognizerWithSelector:(SEL)selector {
    return [[[UITapGestureRecognizer alloc] initWithTarget:self action:selector] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = [[self class] displayName];
    
    fadeMeView = [[UIView alloc] initWithFrame:CGRectMake(55, 40, 210, 160)];
    fadeMeView.backgroundColor = [UIColor colorWithRed:0.580 green:0.706 blue:0.796 alpha:1.000];
    [self.view addSubview:fadeMeView];
    
    moveMeView = [[UIView alloc] initWithFrame:CGRectMake(55, 220, 210, 160)];
    moveMeView.backgroundColor = [UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000];
    [self.view addSubview:moveMeView];
                  
	[fadeMeView addGestureRecognizer:[self createTapRecognizerWithSelector:@selector(fadeMe)]];
	[moveMeView addGestureRecognizer:[self createTapRecognizerWithSelector:@selector(moveMe)]];
}

- (void)fadeMe {
	[UIView animateWithDuration:1.0 animations:^{
		fadeMeView.alpha = 0.0f;	
	}];
}

- (void)moveMe {
	[UIView animateWithDuration:0.5 animations:^{
		moveMeView.center = CGPointMake(moveMeView.center.x, moveMeView.center.y - 200);	
	}];
}

- (void)dealloc {
    CARelease(fadeMeView);
    CARelease(moveMeView);
    [super dealloc];
}

@end
