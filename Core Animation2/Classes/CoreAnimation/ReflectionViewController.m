

#import "ReflectionViewController.h"

@implementation ReflectionViewController

+ (NSString *)displayName {
	return @"Reflections";
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = [[self class] displayName];
	self.view.backgroundColor = [UIColor whiteColor];
	UIImage *image = [UIImage imageNamed:@"mountains.png"];
	
	// Image Layer
	CALayer *imageLayer = [CALayer layer];
	imageLayer.contents = (id)image.CGImage;
	imageLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	imageLayer.position = CGPointMake(160, 130);
	imageLayer.borderColor = [UIColor darkGrayColor].CGColor;
	imageLayer.borderWidth = 1.0;
	[self.view.layer addSublayer:imageLayer];
	
	// Reflection Layer
	CALayer *reflectionLayer = [CALayer layer];
	reflectionLayer.contents = imageLayer.contents;
	reflectionLayer.bounds = imageLayer.bounds;
	reflectionLayer.position = CGPointMake(160, 330);
	reflectionLayer.borderColor = imageLayer.borderColor;
	reflectionLayer.borderWidth = imageLayer.borderWidth;
	reflectionLayer.opacity = 0.5;
	// Transform X by 180 degrees
	[reflectionLayer setValue:[NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)] forKeyPath:@"transform.rotation.x"];

	// Gradient Layer - Use as mask
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	gradientLayer.bounds = reflectionLayer.bounds;
	gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.65);
	gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor whiteColor] CGColor], nil];
	gradientLayer.startPoint = CGPointMake(0.5, 0.5);
	gradientLayer.endPoint = CGPointMake(0.5, 1.0);

	// Add gradient layer as a mask
	reflectionLayer.mask = gradientLayer;
	[self.view.layer addSublayer:reflectionLayer];
}

@end
