//
//  CAEmitterDemoViewController.m
//  CAEmitterDemo
//
//  Created by Shawn Welch on 10/6/11.
//  Copyright (c) 2011 anythingsimple.com. All rights reserved.
//

#import "CAEmitterDemoViewController.h"

@implementation CAEmitterDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor blackColor];
    
    
    // Create the Fireworks View
    FireworksView *fireworks = [[FireworksView alloc] initWithFrame:self.view.bounds];
    fireworks.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    fireworks.backgroundColor = [UIColor blackColor];
    [self.view addSubview:fireworks];
    
    [fireworks launchFirework];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fireworksTapped:)];
    [fireworks addGestureRecognizer:tap];


}

- (void)fireworksTapped:(UITapGestureRecognizer*)tap{

    // Here you could do something special by recognizing a tap on the view

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}


@end
