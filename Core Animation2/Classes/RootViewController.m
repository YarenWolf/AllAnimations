#import "RootViewController.h"

#import "TachometerViewController.h"
#import "BatmanViewController.h"
#import "PacmanViewController.h"
#import "ImplicitAnimationsViewController.h"
#import "CharlieViewController.h"
#import "SimpleViewPropertyAnimation.h"
#import "StickyNotesViewController.h"
#import "AVPlayerLayerViewController.h"
#import "ReflectionViewController.h"
#import "FlipViewController.h"
#import "PulseViewController.h"
#import "MakeItStickViewController.h"
#import "SublayerTransformViewController.h"

@interface UIViewController (Private)
+ (NSString *)displayName;
@end

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	items = [[NSMutableArray alloc] init];
	
	NSMutableArray *layersList = [NSMutableArray array];
	[layersList addObject:[ImplicitAnimationsViewController class]];
	[layersList addObject:[MakeItStickViewController class]];
	[layersList addObject:[TachometerViewController class]];
	[layersList addObject:[BatmanViewController class]];
	[layersList addObject:[PacmanViewController class]];
	[layersList addObject:[SublayerTransformViewController class]];
	[layersList addObject:[AVPlayerLayerViewController class]];
	[layersList addObject:[CharlieViewController class]];
	[layersList addObject:[ReflectionViewController class]];
	[layersList addObject:[PulseViewController class]];

	NSDictionary *layers = [NSDictionary dictionaryWithObject:layersList forKey:@"Core Animation"];
	[items addObject:layers];
	
	NSMutableArray *uiKitList = [NSMutableArray array];
	[uiKitList addObject:[SimpleViewPropertyAnimation class]];
	[uiKitList addObject:[StickyNotesViewController class]];
	[uiKitList addObject:[FlipViewController class]];

	
	NSDictionary *uiKits = [NSDictionary dictionaryWithObject:uiKitList forKey:@"UIKit Animation"];
	[items addObject:uiKits];
	
	self.title = @"Animations";
}

#pragma mark -
#pragma mark Table view data source

- (NSArray *)valuesForSection:(NSUInteger)section {
	NSDictionary *dictionary = [items objectAtIndex:section];
	NSString *key = [[dictionary allKeys] objectAtIndex:0];
	return [dictionary objectForKey:key];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[[items objectAtIndex:section] allKeys] objectAtIndex:0];	
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self valuesForSection:section] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	
	NSArray *values = [self valuesForSection:indexPath.section];
	cell.textLabel.text = [[values objectAtIndex:indexPath.row] displayName];
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *values = [self valuesForSection:indexPath.section];
	Class clazz = [values objectAtIndex:indexPath.row];
	id controller = [[[clazz alloc] init] autorelease];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc {
    CARelease(items);
    [super dealloc];
}

@end

