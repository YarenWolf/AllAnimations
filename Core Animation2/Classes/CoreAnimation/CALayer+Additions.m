
#import "CALayer+Additions.h"


@implementation CALayer (Additions)

- (void)adjustWidthBy:(CGFloat)value {
	self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width + value, self.bounds.size.height);
}


@end
