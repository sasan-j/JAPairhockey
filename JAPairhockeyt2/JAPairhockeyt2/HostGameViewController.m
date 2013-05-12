//
//  HostGameViewController.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/11/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "HostGameViewController.h"
#import "MatchmakingServer.h"
//#import "UIButton+SnapAdditions.h"
#import "PeerCell.h"


@interface HostGameViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UIButton *startButton;


@end



@implementation HostGameViewController{
	MatchmakingServer *_matchmakingServer;
    QuitReason _quitReason;
}



@synthesize nameTextField = _nameTextField;
@synthesize tableView = _tableView;
@synthesize intendedPlayers;
@synthesize delegate = _delegate;
@synthesize startButton = _startButton;



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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    NSLog(@"host game view did apear");

	if (_matchmakingServer == nil)
	{
		_matchmakingServer = [[MatchmakingServer alloc] init];
		_matchmakingServer.maxClients = 3;
        _matchmakingServer.delegate = self;
		[_matchmakingServer startAcceptingConnectionsForSessionID:SESSION_ID];
        
		self.nameTextField.text = _matchmakingServer.session.displayName;
		[self.tableView reloadData];
	}
}


- (IBAction)startAction:(id)sender
{
	if (_matchmakingServer != nil && [_matchmakingServer connectedClientCount] > 0)
	{
		NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([name length] == 0)
			name = _matchmakingServer.session.displayName;
        
		[_matchmakingServer stopAcceptingConnections];
        
		[self.delegate hostGameViewController:self startGameWithSession:_matchmakingServer.session playerName:name clients:_matchmakingServer.connectedClients];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_matchmakingServer != nil)
		return [_matchmakingServer connectedClientCount];
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
    NSLog(@"client connected");
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
- (IBAction)setGameName:(id)sender {
    //_matchmakingServer.session.    peerID=self.nameTextField.text;

}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

@end
