//
//  JoinGameViewController.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/12/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "JoinGameViewController.h"
#import "PeerCell.h"
#import "HostGameConfigViewController.h"
#import "MainMenuViewController.h"
#import "GameLogic.h"
#import "Game.h"
#import "Packet.h"

@interface JoinGameViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *waitView;
@property (nonatomic, weak) IBOutlet UILabel *waitLabel;

@end

@implementation JoinGameViewController
{
	MatchmakingClient *_matchmakingClient;
    QuitReason _quitReason;
}

@synthesize nameTextField = _nameTextField;
@synthesize tableView = _tableView;

@synthesize loadingLabel = _loadingLabel;
@synthesize waitView = _waitView;
@synthesize waitLabel = _waitLabel;

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
    
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    
	if (_matchmakingClient == nil)
	{
        _quitReason = QuitReasonConnectionDropped;
        
		_matchmakingClient = [[MatchmakingClient alloc] init];
        _matchmakingClient.delegate = self;
		[_matchmakingClient startSearchingForServersWithSessionID:SESSION_ID];
        
		self.nameTextField.text = _matchmakingClient.session.displayName;
		[self.tableView reloadData];
	}

}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    

}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.waitView = nil;
}

- (IBAction)exitAction:(id)sender
{
	_quitReason = QuitReasonUserQuit;
	[_matchmakingClient disconnectFromServer];
	[self.delegate joinGameViewControllerDidCancel:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_matchmakingClient != nil){
                NSLog(@"datasource number of rows in section!");
		return [_matchmakingClient availableServerCount];}
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[PeerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingClient displayNameForPeerID:peerID];
    
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if (_matchmakingClient != nil)
	{
		//[self.view addSubview:self.waitView];
        
		NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
		[_matchmakingClient connectToServerWithPeerID:peerID];
        [_loadingLabel setHidden:NO];
        
        //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
       // HostGameConfigViewController *viewController = (HostGameConfigViewController *)[storyboard instantiateViewControllerWithIdentifier:@"joinGameLoading"];
        //[self presentViewController:viewController animated:YES completion:nil];
        //HostGameConfigViewController *viewController = [[HostGameConfigViewController alloc] init];
        //[self presentViewController:viewController animated:YES completion:nil];
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

#pragma mark - MatchmakingClientDelegate

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID
{
	_matchmakingClient.delegate = nil;
	_matchmakingClient = nil;
	[self.tableView reloadData];
	[self.delegate joinGameViewController:self didDisconnectWithReason:_quitReason];
}

- (void)matchmakingClient:(MatchmakingClient *)client didConnectToServer:(NSString *)peerID
{
    GameLogic *gameLogic=[GameLogic GetInstance];
    Game *game = [[Game alloc] init];
    gameLogic.game = game;
    
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([name length] == 0)
		name = _matchmakingClient.session.displayName;
    
	[self.delegate joinGameViewController:self startGameWithSession:_matchmakingClient.session playerName:name server:peerID];
    NSLog(@"connected to server");
    _loadingLabel.text=@"CONNECED";
    
    NSLog(@"player name should be: %@",name);
    gameLogic.playerName= name;
    NSLog(@"server name should be: %@",peerID);
    gameLogic.serverID = peerID;
    NSLog(@"session: %@",_matchmakingClient.session);
    gameLogic.session = _matchmakingClient.session;
    gameLogic.peerID = _matchmakingClient.session.peerID;
    NSLog(@"peerID should be: %@",gameLogic.peerID);

    gameLogic.lastHit = gameLogic.peerID;

//    [gameLogic.game startClientGameWithSession:gameLogic.session playerName:gameLogic.playerName server:gameLogic.serverID];
//    _loadingLabel.text=@"CONNECED, WAITING FOR SERVER...";
    

    
   UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GameView"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (void)matchmakingClientNoNetwork:(MatchmakingClient *)client
{
	_quitReason = QuitReasonNoNetwork;
}

- (IBAction)goBack:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MainMenuViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainMenu"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    //[self dismissModalViewControllerAnimated:YES];
}




- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

@end
