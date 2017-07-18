
#import "BatmanViewController.h"

#define ROTATE_LEFT_TAG	 3
#define ROTATE_RIGHT_TAG 4

@implementation BatmanViewController

- (id)init {
    self = [super initWithNibName:@"BatmanView" bundle:nil];
    return self;
}

+ (NSString *)displayName {
	return @"I'm Batman";
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	self.title = [[self class] displayName];
	
	UIImage *image = [UIImage imageNamed:@"batman.png"];
	
	logoLayer = [CALayer layer];
	logoLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	logoLayer.position = CGPointMake(160, 180);
	logoLayer.contents = (id)image.CGImage;
	
	// Add layer as a sublayer of the UIView's layer
	[self.view.layer addSublayer:logoLayer];
}

- (IBAction)rotate:(id)sender {
	int direction = [sender tag] == ROTATE_LEFT_TAG ? -1 : 1;
	CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * direction];
	rotationAnimation.duration = 1.0f;
	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[logoLayer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
}

- (void)scaleByFactor:(CGFloat)factor {
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    NSNumber *scaleFactor = [NSNumber numberWithFloat:factor];
	scaleAnimation.toValue = scaleFactor;
	scaleAnimation.duration = 3.0f;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // Set the model layer's property so the animation sticks at the 'toValue' state
	[logoLayer setValue:scaleFactor forKeyPath:@"transform.scale"];
	[logoLayer addAnimation:scaleAnimation forKey:@"transformAnimation"];
}

- (IBAction)scaleDown {
	CGFloat factor = [[logoLayer valueForKeyPath:@"transform.scale"] floatValue] > 1.0 ? 1.0 : 0.5;
	[self scaleByFactor:factor];
}

- (IBAction)scaleUp {
	CGFloat factor = [[logoLayer valueForKeyPath:@"transform.scale"] floatValue] == 0.5 ? 1.0 : 1.5;
	[self scaleByFactor:factor];
}

// Combine scale and rotate transform into group.  Let animation group repeat indefinitely
- (IBAction)doBatmanAnimation {
	CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 3]; // 3 is the number of 360 degree rotations
    // Make the rotation animation duration slightly less than the other animations to give it the feel
    // that it pauses at its largest scale value
	rotationAnimation.duration = 1.9f;
	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
	scaleAnimation.duration = 2.0f;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 2.0f;
	animationGroup.autoreverses = YES;
	animationGroup.repeatCount = HUGE_VALF;
	[animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation, scaleAnimation, nil]];

	[logoLayer addAnimation:animationGroup forKey:@"animationGroup"];
}

@end
