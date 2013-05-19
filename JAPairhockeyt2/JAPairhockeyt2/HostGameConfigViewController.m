//
//  HostGameConfigViewController.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/13/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "HostGameConfigViewController.h"
#import "MatchmakingServer.h"
#import "HostGameViewController.h"
#import "GameLogic.h"

@interface HostGameConfigViewController ()
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;


@end

@implementation HostGameConfigViewController{
    MatchmakingServer *_matchmakingServer;
}

@synthesize nameTextField = _nameTextField;
@synthesize hostGameIntendedPlayers = _hostGameIntendedPlayers;


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
    NSLog(@"host game view did load");
    
    
    ///for dissmissing keyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"hostGame view did apear");
    
    //if there is no match making server it gets the device name and put into text field
    //otherwise get the match making displayName
    if (_matchmakingServer == nil)
    {
    self.nameTextField.text = [[UIDevice currentDevice] name];
    }
    else self.nameTextField.text = _matchmakingServer.session.displayName;
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //if the next view is hostGame it will call host a game function
    NSLog(@"prepare for segue");

    if([segue.identifier isEqualToString:@"hostGame"]){
        NSLog(@"hostGame identifier");

        HostGameViewController *dvc =[segue destinationViewController];
        //[dvc setIntendedPlayers:3+[_hostGameIntendedPlayers selectedSegmentIndex]];
        dvc.intendedPlayers=3+[_hostGameIntendedPlayers selectedSegmentIndex];
        
        
        GameLogic* gameLogic = [GameLogic GetInstance];
        gameLogic.playerName = self.playerNameTextField.text;
        //gameLogic.numberOfPlayers = 3+[_hostGameIntendedPlayers selectedSegmentIndex];
    }
}




- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
