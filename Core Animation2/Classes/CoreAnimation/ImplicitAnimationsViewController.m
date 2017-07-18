

#import "ImplicitAnimationsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+Additions.h"

#define ORGINAL_POSITION CGPointMake(160, 250)
#define MOVED_POSITON CGPointMake(200, 290)

@implementation ImplicitAnimationsViewController

+ (NSString *)displayName {
	return @"Animatable Properties";
}

- (id)init {
	if ((self = [super initWithNibName:@"LayerView" bundle:nil])) {
		layer = [CALayer layer];
		layer.bounds = CGRectMake(0, 0, 200, 200);
		layer.position = CGPointMake(160, 250);
		layer.backgroundColor = [UIColor redColor].CGColor;
		layer.borderColor = [UIColor blackColor].CGColor;
		layer.opacity = 1.0f;
		[self.view.layer addSublayer:layer];		
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.actionsSwitch.on = NO;
	self.title = [[self class] displayName];
}

- (IBAction)toggleColor {
	[CATransaction setDisableActions:actionsSwitch.on];
	CGColorRef redColor = [UIColor redColor].CGColor, blueColor = [UIColor blueColor].CGColor;
	layer.backgroundColor = (layer.backgroundColor == redColor) ? blueColor : redColor;
}

- (IBAction)toggleCornerRadius {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.cornerRadius = (layer.cornerRadius == 0.0f) ? 30.0f : 0.0f;
}

- (IBAction)toggleBorder {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.borderWidth = (layer.borderWidth == 0.0f) ? 10.0f : 0.0f;
}

- (IBAction)toggleOpacity {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.opacity = (layer.opacity == 1.0f) ? 0.5f : 1.0f;
}

- (IBAction)toggleBounds {
	[CATransaction setDisableActions:actionsSwitch.on];
    [layer adjustWidthBy:layer.bounds.size.width == layer.bounds.size.height ? 100 : -100];
}

- (IBAction)togglePosition {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.position = layer.position.x == 160 ? MOVED_POSITON : ORGINAL_POSITION;
}

@synthesize actionsSwitch;

@end
