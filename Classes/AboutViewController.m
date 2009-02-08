//
//  AboutViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

- (id)initWithWindow:(UIWindow*)window {
	if (self = [super init]) {
		// Initialization code
		[window retain];
		_window = window;
		self.title = @"About";
		[self setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"About"
														  image:[UIImage imageNamed:@"About2.png"]
															tag:3]];
	}
	
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([[[request URL] absoluteString] isEqual:@"http://arashpayan.com/projects/PrayerBook/AboutiPhone/"])
		return YES;
	
	[[UIApplication sharedApplication] openURL:[request URL]];
	
	return NO;
}


// Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
	webView = [[UIWebView alloc] init];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.delegate = self;
	self.view = webView;
}


// If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
	NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]
											   encoding:NSUTF8StringEncoding
												  error:nil];
	[webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://arashpayan.com/projects/PrayerBook/AboutiPhone/"]];
	//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:
	//												   @"http://arashpayan.com/projects/PrayerBook/AboutiPhone/"]]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
}


- (void)didReceiveMemoryWarning {
	printf("AboutViewController didReceiveMemoryWarning\n");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[webView release];
	[_window release];
	[super dealloc];
}


@end