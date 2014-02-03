//
//  IFTTTAnimatedScrollViewController.m
//  JazzHands
//
//  Created by Devin Foley on 9/27/13.
//  Copyright (c) 2013 IFTTT Inc. All rights reserved.
//

#import "IFTTTAnimatedScrollViewController.h"
@interface IFTTTAnimatedScrollViewController ()

@property (nonatomic) BOOL pageControlBeingUsed;

@end

@implementation IFTTTAnimatedScrollViewController

- (id)init:(NSUInteger)numberOfPages
{
    self = [super init];
    
    if (self) {
        self.animator = [IFTTTAnimator new];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+self.iOSViewFrameAdjustment, self.view.bounds.size.width, self.view.bounds.size.height - self.iOSViewFrameAdjustment)];
		self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
		self.pageControl = [[UIPageControl alloc] init];
		self.pageControl.numberOfPages = numberOfPages;
		[self.pageControl sizeToFit];
		self.pageControl.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.scrollView.frame) - 20.0f);
		[self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
		self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:2/3 green:2/3 blue:2/3 alpha:0.3f];
		self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1/3 green:1/3 blue:1/3 alpha:1.0f];
		self.pageControl.currentPage = 0;
		
        [self.view addSubview:self.scrollView];
		[self.view addSubview:self.pageControl];
    }
    
    return self;
}
- (void)viewDidLoad
{
	self.pageControlBeingUsed = NO;
}
- (void)dealloc
{
	if (self.scrollView) {
		self.scrollView.delegate = nil;
	}
}
#pragma mark - ScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self.animator animate:aScrollView.contentOffset.x];
	
	if (self.pageControlBeingUsed == NO) {
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}
- (void)changePage
{
	// update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
	self.pageControlBeingUsed = YES;
}
@end
