

#import "CharlieViewController.h"

static const CGFloat offset = 10.0;
static const CGFloat curve = 5.0;

@implementation CharlieViewController

+ (NSString *)displayName {
	return @"Winning";
}

// This method taken verbatim from Joe Ricciopo's Shadow Demo:
// https://github.com/joericioppo/ShadowDemo

- (UIBezierPath*)bezierPathWithCurvedShadowForRect:(CGRect)rect {
	
	UIBezierPath *path = [UIBezierPath bezierPath];	
	
	CGPoint topLeft		 = rect.origin;
	CGPoint bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(rect) + offset);
	CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect) - curve);	
	CGPoint bottomRight	 = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) + offset);
	CGPoint topRight	 = CGPointMake(CGRectGetWidth(rect), 0.0);
	
	[path moveToPoint:topLeft];	
	[path addLineToPoint:bottomLeft];
	[path addQuadCurveToPoint:bottomRight controlPoint:bottomMiddle];
	[path addLineToPoint:topRight];
	[path addLineToPoint:topLeft];
	[path closePath];
	
	return path;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = [[self class] displayName];
	
	UIImage *charlieImage = [UIImage imageNamed:@"charlie.png"];
	CALayer *layer = [CALayer layer];
	
	layer = [CALayer layer];
	layer.bounds = CGRectMake(0, 0, charlieImage.size.width, charlieImage.size.height);
	layer.position = CGPointMake(160, 200);
	layer.contents = (id)charlieImage.CGImage;	
	
	layer.shadowOffset = CGSizeMake(0, 2);
	layer.shadowOpacity = 0.70;
	
	[self.view.layer addSublayer:layer];
	
	UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglePath)];
	[self.view addGestureRecognizer:tapRecognizer];
	[tapRecognizer release];
}

- (void)togglePath {
	CALayer *layer = [[self.view.layer sublayers] objectAtIndex:0];
	layer.shadowPath = (layer.shadowPath) ? nil : [self bezierPathWithCurvedShadowForRect:layer.bounds].CGPath;
}

@end
