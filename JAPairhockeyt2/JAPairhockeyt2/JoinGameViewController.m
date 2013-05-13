//
//  JoinGameViewController.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/12/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "JoinGameViewController.h"
#import "PeerCell.h"

@interface JoinGameViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
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
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	if (_matchmakingClient == nil)
	{
        _quitReason = QuitReasonConnectionDropped;
        
		_matchmakingClient = [[MatchmakingClient alloc] init];
        _matchmakingClient.delegate = self;
		[_matchmakingClient startSearchingForServersWithSessionID:SESSION_ID];
        
		self.nameTextField.placeholder = _matchmakingClient.session.displayName;
		[self.tableView reloadData];
	}
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
		[self.view addSubview:self.waitView];
        
		NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
		[_matchmakingClient connectToServerWithPeerID:peerID];
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
	NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([name length] == 0)
		name = _matchmakingClient.session.displayName;
    
	[self.delegate joinGameViewController:self startGameWithSession:_matchmakingClient.session playerName:name server:peerID];
}

- (void)matchmakingClientNoNetwork:(MatchmakingClient *)client
{
	_quitReason = QuitReasonNoNetwork;
}

- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}




- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

@end