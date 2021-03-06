//
//  RecentViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/27/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "RecentViewController.h"
#import "PrayerViewController.h"

@interface RecentViewController ()

@property (nonatomic, strong) NSArray *recentPrayers;

@end


@implementation RecentViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		self.title = NSLocalizedString(@"RECENTS", nil);
		[self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2]];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CLEAR", nil)
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(clearRecent)];
	}
	return self;
}

- (void)clearRecent {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"CLEAR_ALL_RECENTS", nil)
                                                    otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[PrayerDatabase sharedInstance] clearRecents];
		self.recentPrayers = [[PrayerDatabase sharedInstance] getRecent];

		[self.tableView reloadData];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.recentPrayers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	PrayerTableCell *cell = (PrayerTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[PrayerTableCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	NSNumber *entry = [self.recentPrayers objectAtIndex:indexPath.row];
	Prayer *thePrayer = [[PrayerDatabase sharedInstance] prayerWithId:[entry longValue]];
	cell.title.text = thePrayer.title;
	cell.subtitle.text = thePrayer.category;
	cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@", thePrayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *prayerId = [self.recentPrayers objectAtIndex:indexPath.row];
	Prayer *prayer = [[PrayerDatabase sharedInstance] prayerWithId:[prayerId longValue]];
	if (prayer == nil) {
		printf("Unable to find recent prayer\n");
		return;
	}
	
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:prayer backButtonTitle:NSLocalizedString(@"RECENTS", NULL)];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)loadSavedState:(NSMutableArray*)savedState {
	NSNumber *prayerId = [savedState objectAtIndex:0];
	Prayer *prayer = [[PrayerDatabase sharedInstance] prayerWithId:[prayerId longValue]];
	
	PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:prayer backButtonTitle:NSLocalizedString(@"RECENTS", NULL)];
	[[self navigationController] pushViewController:pvc animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.recentPrayers = [[PrayerDatabase sharedInstance] getRecent];
	
	if ([self.recentPrayers count] > 0)
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	else
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	
	// force the reload, because UIKit caches the table
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end

