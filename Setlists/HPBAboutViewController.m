//
//  HPBAboutViewController.m
//  JamNotes
//
//  Created by Phil Christensen on 8/11/13.
//  Copyright (c) 2013-2019 Phil Christensen. All rights reserved.
//

#import "HPBAboutViewController.h"

@interface HPBAboutViewController ()

@end

@implementation HPBAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
