//
//  MainMenuViewController.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/11/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//heeeeeeeehaaaaa

#import "MainMenuViewController.h"
#import "Game.h"
#import "GameLogic.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

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
    GameLogic* gameLogic = [GameLogic GetInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
