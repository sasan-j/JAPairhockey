//
//  JoinGameViewController.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/12/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "JoinGameViewController.h"

@interface JoinGameViewController ()

@end

@implementation JoinGameViewController

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

- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
