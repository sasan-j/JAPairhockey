//
//  HostGameViewController.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/11/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "HostGameViewController.h"
#import "MatchmakingServer.h"
//#import "UIButton+JAPAdditions.h"
#import "PeerCell.h"
#import "GameLogic.h"
#import "Game.h"


@interface HostGameViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;


@end


@implementation HostGameViewController{
	MatchmakingServer *_matchmakingServer;
    QuitReason _quitReason;
}



@synthesize tableView = _tableView;
@synthesize intendedPlayers= _intendedPlayers;
@synthesize startButton = _startButton;
@synthesize hostGameTitleLabel = _hostGameTitleLabel;

@synthesize delegate = _delegate;



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

    _hostGameTitleLabel.text=[NSString stringWithFormat:@"HOSTING A GAME WITH %d PLAYERS...",_intendedPlayers];
    NSLog(@"start matchmaking process");
    NSLog(@"intendedPlayers=%d",_intendedPlayers);
    if (_matchmakingServer == nil)
    {
        _matchmakingServer = [[MatchmakingServer alloc] init];
        _matchmakingServer.maxClients = _intendedPlayers-1;
        //[_matchmakingServer displayNameForPeerID:self.nameTextField.text];
        _matchmakingServer.delegate = self;
        [_matchmakingServer startAcceptingConnectionsForSessionID:SESSION_ID];
        //self.nameTextField.text = _matchmakingServer.session.displayName;
        [self.tableView reloadData];
        //NSLog(@"Starting matchmaking server '%@' for %d players",self.nameTextField.text,_intendedPlayers);
    }
    else {
        //_matchmakingServer.maxClients = _intendedPlayers-1;
        //[_matchmakingServer displayNameForPeerID:self.nameTextField.text];
        //NSLog(@"Starting matchmaking server '%@' for %d players",self.nameTextField.text,_intendedPlayers);
    }
    NSLog(@"maxClients=%d",_matchmakingServer.maxClients);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)startAction:(id)sender
{
    NSLog(@"gfdgffdhggfhdf");

	if (_matchmakingServer != nil && [_matchmakingServer connectedClientCount] >= 0)
	{
        GameLogic *gameLogic=[GameLogic GetInstance];
        Game *game = [[Game alloc] init];
        gameLogic.game = game;
        gameLogic.isServer = YES;
		NSString *name = [gameLogic.playerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([name length] == 0)
			name = _matchmakingServer.session.displayName;
        
		[_matchmakingServer stopAcceptingConnections];
        
		//[self.delegate hostGameViewController:self startGameWithSession:_matchmakingServer.session playerName:name clients:_matchmakingServer.connectedClients];
        NSLog(@"session: %@",_matchmakingServer.session);
        gameLogic.session = _matchmakingServer.session;
        //NSMutableDictionary *array = [_matchmakingServer.connectedClients copy];
        //NSArray *array=[_matchmakingServer.connectedClients copy];
        for(NSString *key in _matchmakingServer.connectedClients){
            [gameLogic.connectedPlayers addObject:key];
        }
        //gameLogic.connectedPlayers=_matchmakingServer.connectedClients;
        gameLogic.peerID = _matchmakingServer.session.peerID;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GameView"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
        
	}
}

- (IBAction)exitAction:(id)sender
{
	_quitReason = QuitReasonUserQuit;
	[_matchmakingServer endSession];
	[self.delegate hostGameViewControllerDidCancel:self];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section
{
	if (_matchmakingServer != nil){
		return [_matchmakingServer connectedClientCount];}
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[PeerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [_matchmakingServer peerIDForConnectedClientAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingServer displayNameForPeerID:peerID];
	return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - MatchmakingServerDelegate

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
	[self.tableView reloadData];
    NSLog(@"client connected and %d clients total",[_matchmakingServer connectedClientCount]);
    
}

- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
	[self.tableView reloadData];
    NSLog(@"client disconnected");

}

- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server
{
	_matchmakingServer.delegate = nil;
	_matchmakingServer = nil;
	[self.tableView reloadData];
	[self.delegate hostGameViewController:self didEndSessionWithReason:_quitReason];
}

- (void)matchmakingServerNoNetwork:(MatchmakingServer *)session
{
	_quitReason = QuitReasonNoNetwork;
}



- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}


@end
