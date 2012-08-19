//
//  ViewController.m
//  CustomSelectView
//
//  Created by wgdadmin on 12-8-19.
//  Copyright (c) 2012年 wgdadmin. All rights reserved.
//

#import "ViewController.h"
#import "SelectedView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SelectedView *sView = [[SelectedView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    sView.backgroundColor = [UIColor redColor];
    [self.view addSubview:sView];
    [sView release];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
