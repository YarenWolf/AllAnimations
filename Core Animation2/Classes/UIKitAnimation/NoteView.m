

#import "NoteView.h"

@implementation NoteView

@synthesize delegate, text;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		UIColor *greenBackgroundColor = [UIColor colorWithRed:0.733 green:0.976 blue:0.722 alpha:1.000];
		self.backgroundColor = greenBackgroundColor;
		self.layer.borderColor = [UIColor colorWithRed:0.513 green:0.688 blue:0.505 alpha:1.000].CGColor;
        self.layer.borderWidth = 1.0f;
        
		// Add Text View
		textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 44)];
		textView.editable = NO;
		textView.font = [UIFont fontWithName:@"Marker Felt" size:36];
		textView.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
		textView.backgroundColor = [UIColor clearColor];
		[self addSubview:textView];
		
		// Add New Button
		UIImage *newNoteImage = [UIImage imageNamed:@"new_note_icon.png"];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(self.bounds.size.width - 34, self.bounds.size.height - 36, 24, 26);
		[button setBackgroundImage:newNoteImage forState:UIControlStateNormal];
		[button addTarget:self action:@selector(addNote) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
    }
    return self;
}

- (void)addNote {
	if ([self.delegate respondsToSelector:@selector(addNoteTapped)]) {
		[self.delegate performSelector:@selector(addNoteTapped)];
	}
}

- (NSString *)text {
	return [textView text];
}

- (void)setText:(NSString *)newText {
	[textView setText:newText];
}

- (void)dealloc {
    CARelease(textView);
    [super dealloc];
}

@end
