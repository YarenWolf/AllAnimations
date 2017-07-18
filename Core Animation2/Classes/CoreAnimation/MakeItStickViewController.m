

#import "MakeItStickViewController.h"

@implementation MakeItStickViewController

+ (NSString *)displayName {
	return @"Make it Stick";
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = [[self class] displayName];
	UIImage *image = [UIImage imageNamed:@"heart.png"];
	layer = [CALayer layer];
	layer.contents = (id)image.CGImage;
	layer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	layer.position = CGPointMake(160, 200);
	[self.view.layer addSublayer:layer];
		
	UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeIt)];
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
}

- (void)fadeIt {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.toValue = [NSNumber numberWithFloat:0.0];
	animation.fromValue = [NSNumber numberWithFloat:layer.opacity];
	animation.duration = 1.0;
	layer.opacity = 0.0; // This is required to update the model's value.  Comment out to see what happens.
	[layer addAnimation:animation forKey:@"animateOpacity"];
}

@end
