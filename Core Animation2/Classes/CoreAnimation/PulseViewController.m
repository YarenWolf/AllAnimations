

#import "PulseViewController.h"

@implementation PulseViewController

+ (NSString *)displayName {
	return @"Pulse";
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = [[self class] displayName];
	
	UIImage *image = [UIImage imageNamed:@"heart.png"];
	CALayer *layer = [CALayer layer];
	layer.contents = (id)image.CGImage;
	layer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	layer.position = CGPointMake(160, 200);

	// Shrink down to 90% of its original value
	layer.transform = CATransform3DMakeScale(0.90, 0.90, 1);
	
	[self.view.layer addSublayer:layer];
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	animation.autoreverses = YES;
	animation.duration = 0.35;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.repeatCount = HUGE_VALF;
	[layer addAnimation:animation forKey:@"pulseAnimation"];
}

@end
