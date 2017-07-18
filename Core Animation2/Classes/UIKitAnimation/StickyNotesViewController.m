

#import "StickyNotesViewController.h"
#import "NoteView.h"

@implementation StickyNotesViewController

+ (NSString *)displayName {
	return @"Sticky Notes";
}

- (void)viewDidLoad {
    [super viewDidLoad];    
	self.title = [[self class] displayName];
	self.noteView = [[[NoteView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)] autorelease];
	self.noteView.delegate = self;
	self.noteView.text = @"A computer once beat me at chess, but it was no match for me at kick boxing.\n-Emo Philips";
	self.nextText = @"A lot of people are afraid of heights. Not me, I'm afraid of widths.\n-Steven Wright";
	
	UIImage *corkboard = [UIImage imageNamed:@"corkboard.png"];
	self.view.backgroundColor = [UIColor colorWithPatternImage:corkboard];

    // Shadow needs to be applied to the containing layer so it doesn't blip when the animation occurs.
    // Hat tip to Troy for pointing that out!
    UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 300)] autorelease];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.layer.shadowOffset = CGSizeMake(0, 2);
    containerView.layer.shadowOpacity = 0.80;
    [containerView addSubview:noteView];
	[self.view addSubview:containerView];
}

- (void)addNoteTapped {
	[UIView transitionWithView:noteView duration:0.6
					   options:UIViewAnimationOptionTransitionCurlUp
					animations:^{
						NSString *currentText = noteView.text;
						noteView.text = nextText;
						self.nextText = currentText;
					} completion:^(BOOL finished){
						
					}];
}

- (void)dealloc {
    self.noteView = nil;
    self.nextText = nil;
    [super dealloc];
}

@synthesize noteView, nextText;

@end
