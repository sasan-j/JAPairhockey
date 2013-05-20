//
//  GameControllerViewController.m
//  JAPairhockeyt2
//
//  Created by JAFARNEJAD Sasan on 5/17/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "GameViewController.h"
#import "GameLogic.h"
#import "Game.h"
#import "Packet.h"

@interface GameViewController ()

@end

@implementation GameViewController


UIAlertView *_alertView;


@synthesize drawTimer;
@synthesize airHockeyView;
@synthesize xCoord;
@synthesize yCoord;
@synthesize middleButton;
@synthesize scoreNameLabels;
@synthesize scoreNumberLabels;

@synthesize delegate = _delegate;
@synthesize game = _game;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)drawGame
{
    GameLogic* gameLogic = [GameLogic GetInstance];
    
    if(!gameLogic.isGamePause)
        [gameLogic moveTheBall];
    [[self airHockeyView] setNeedsDisplay];
    //Score Board Updates Te Scores
    [self scoreBoardUpdateScores];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    GameLogic* gameLogic = [GameLogic GetInstance];
    drawTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawGame) userInfo:nil repeats:YES];
    [drawTimer fire];
    //self.game= [[Game alloc] init];
    _game = gameLogic.game;
    [_game setDelegate:self];
    
    NSLog(@"players from gameLogic.game : %@",gameLogic.game._players);
    NSLog(@"players from _game : %@",_game._players);

    

    self.firstPlayerLabelView.hidden=YES;
    self.firstPlayerScoreView.hidden=YES;
    self.secondPlayerLabelView.hidden=YES;
    self.secondPlayerScoreView.hidden=YES;
    self.thirdPlayerLabelView.hidden=YES;
    self.thirdPlayerScoreView.hidden=YES;
    self.fourthPlayerLabelView.hidden=YES;
    self.fourthPlayerScoreView.hidden=YES;

    //self.scoreNameLabels=scoreNameLabels;
    //self.scoreNumberLabels=scoreNumberLabels;
    
    
    /*
    
    //Score Board Names and initializing
    //[gameLogic scoreBoardInit];
    //NSLog(@"%@",gameLogic.game._players);
    NSMutableArray *playersName = [NSMutableArray arrayWithObjects:gameLogic.playerName,[NSNumber numberWithInt:0], nil];
    [self scoreBoardInitWitNames:playersName];
    //Disable fourth player label and score if the game is in three player mode unless it's n four player mode
    self.fourthPlayerLabelView.hidden=YES;
    self.fourthPlayerScoreView.hidden=YES;
    NSLog(@"%i",gameLogic.numberOfPlayers);
    if (gameLogic.numberOfPlayers==4)
    {
        self.fourthPlayerLabelView.hidden=NO;
        self.fourthPlayerScoreView.hidden=NO;

    }
    */
    
    
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    //Swaping height and width for fixing a bug!
    gameLogic.fieldWidth = (int)roundf(height)*gameLogic.fieldWidthRatio;
    gameLogic.fieldHeight = (int)roundf(width);
    //NSLog(@"w:%d and h:%d",(int)roundf(width),(int)roundf(height));
    gameLogic.padX = gameLogic.fieldWidth / 2;
    gameLogic.padY = gameLogic.fieldHeight - 50;
    
    NSLog(@"session: %@",gameLogic.session);
    NSLog(@"player name: %@",gameLogic.playerName);
    
    //NSArray *array=[gameLogic.connectedPlayers copy];
    middleButton.alpha = 0.4;
    middleButton.enabled = NO;
    if(gameLogic.isServer){
        NSLog(@"connected players: %@",gameLogic.connectedPlayers);
        [gameLogic.game startServerGameWithSession:gameLogic.session playerName:gameLogic.playerName clients:gameLogic.connectedPlayers];
        //[gameLogic.game listPlayers];
        //NSLog(@"after list players in did load");

        NSLog(@"players: %@",gameLogic.game._players);
        //NSLog(@"player name: %@",gameLogic.playerName);
        
        
        
        NSMutableArray *players=[NSMutableArray array];
        //players=[gameLogic.game._players copy];
        for(NSString * key in gameLogic.game._players)
            [players addObject:[gameLogic.game._players objectForKey:key]];
        
        [self scoreBoardInitWitNames:players];
        
        
        [middleButton setTitle:@"LOADING..." forState:UIControlStateNormal];

    }
    else{
        [gameLogic.game startClientGameWithSession:gameLogic.session playerName:gameLogic.playerName server:gameLogic.serverID];
        //_loadingLabel.text=@"CONNECED, WAITING FOR SERVER...";

        [middleButton setTitle:@"WAITING FOR OTHERS..." forState:UIControlStateNormal];
        
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    GameLogic* gameLogic = [GameLogic GetInstance];
    gameLogic.fieldWidth = (int)roundf(width)*gameLogic.fieldWidthRatio;
    gameLogic.fieldHeight = (int)roundf(height);
    
    gameLogic.padX = gameLogic.fieldWidth / 2;
    gameLogic.padY = gameLogic.fieldHeight - 50;
    
}


// Handles the start of a touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    GameLogic* gameLogic = [GameLogic GetInstance];
  //NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
  //Packet *packet=[Packet packetWithData:data];
    
    UITouch* touch = [touches anyObject];
    CGPoint padStartPosTouchPoint = [touch locationInView:self.view];
    
    NSInteger touchX = (int)roundf(padStartPosTouchPoint.x);
    NSInteger touchY = (int)roundf(padStartPosTouchPoint.y);
    
    if (touchX >= gameLogic.padX-gameLogic.padWidth/2 &&
        touchX <= gameLogic.padX+gameLogic.padWidth/2 &&
        touchY >= gameLogic.padY-gameLogic.padHeight/2 &&
        touchY <= gameLogic.padY+gameLogic.padHeight/2)
    {
        if(!gameLogic.isGamePause)
            gameLogic.dragStarted = YES;
    }
    
    
    if (gameLogic.dragStarted)
    {
        gameLogic.padDragStartXComp = (int)roundf(padStartPosTouchPoint.x);
        
        
        gameLogic.padDragOldXComp = (int)roundf(padStartPosTouchPoint.x);
        gameLogic.padDragNewXComp = (int)roundf(padStartPosTouchPoint.x);
        
        gameLogic.padDragOldYComp = (int)roundf(padStartPosTouchPoint.y);
        gameLogic.padDragNewYComp = (int)roundf(padStartPosTouchPoint.y);
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint padEndPosTouchPoint = [touch locationInView:self.view];
    
    GameLogic* gameLogic = [GameLogic GetInstance];
    
    if (gameLogic.dragStarted)
    {
       /* if ((int)roundf(padEndPosTouchPoint.x)   < gameLogic.fieldWidth &&  (int)roundf(padEndPosTouchPoint.x) > 0
            &&(int)roundf(padEndPosTouchPoint.y) < gameLogic.fieldHeight && (int)roundf(padEndPosTouchPoint.y) > 0 ) {*/
            gameLogic.padDragEndXComp = (int)roundf(padEndPosTouchPoint.x);
            gameLogic.padDragNewXComp = (int)roundf(padEndPosTouchPoint.x);
            gameLogic.padDragNewYComp = (int)roundf(padEndPosTouchPoint.y);
     //   }
        

        
        //gameLogic.padDrag = gameLogic.padDragEndXComp-gameLogic.padDragStartXComp;
      
            gameLogic.padDrag = gameLogic.padDragNewXComp-gameLogic.padDragOldXComp;
        if (((gameLogic.padX + gameLogic.padDrag)<=gameLogic.fieldWidth-gameLogic.padWidth/2)
            &&(gameLogic.padX + gameLogic.padDrag)> gameLogic.padWidth/2) {
            
             gameLogic.padX += gameLogic.padDrag;
        }
 
            gameLogic.padYDrag = gameLogic.padDragNewYComp-gameLogic.padDragOldYComp;
            if (((gameLogic.padY+gameLogic.padYDrag)<=gameLogic.fieldHeight-gameLogic.padHeight/2)
                &&(gameLogic.padY+gameLogic.padYDrag)>gameLogic.padHeight/2) {
                
                  gameLogic.padY += gameLogic.padYDrag;
            }

            gameLogic.padDragOldXComp = (int)roundf(padEndPosTouchPoint.x);
            gameLogic.padDragOldYComp = (int)roundf(padEndPosTouchPoint.y);

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    GameLogic* gameLogic = [GameLogic GetInstance];
    gameLogic.dragStarted = NO;
}


#pragma mark - Actions

- (IBAction)exitAction:(id)sender
{
	if (self.game.isServer)
	{
		_alertView = [[UIAlertView alloc]
                      initWithTitle:NSLocalizedString(@"End Game?", @"Alert title (user is host)")
                      message:NSLocalizedString(@"This will terminate the game for all other players.", @"Alert message (user is host)")
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"No", @"Button: No")
                      otherButtonTitles:NSLocalizedString(@"Yes", @"Button: Yes"),
                      nil];
        
		[_alertView show];
	}
	else
	{
		_alertView = [[UIAlertView alloc]
                      initWithTitle: NSLocalizedString(@"Leave Game?", @"Alert title (user is not host)")
                      message:nil
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"No", @"Button: No")
                      otherButtonTitles:NSLocalizedString(@"Yes", @"Button: Yes"),
                      nil];
        
		[_alertView show];
	}
}

#pragma mark - GameDelegate

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
	[self.delegate gameViewController:self didQuitWithReason:reason];
}

- (void)gameWaitingForServerReady:(Game *)game
{
	//self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}

- (void)gameWaitingForClientsReady:(Game *)game
{
	//self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}

- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer
{
	//[self hidePlayerLabelsForPlayer:disconnectedPlayer];
	//[self hideActiveIndicatorForPlayer:disconnectedPlayer];
	//[self hideSnapIndicatorForPlayer:disconnectedPlayer];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
		[self.game quitGameWithReason:QuitReasonUserQuit];
	}
}

-(void)scoreBoardInitWitNames:(NSArray*)playerNames{
    
    GameLogic* gameLogic = [GameLogic GetInstance];
    
    NSLog(@"score board init : %@",playerNames);
    int count = [playerNames count];
    NSLog(@"score board init : playernames count %d",count);
    Player *tempPlayer;
    
    [gameLogic scoreBoardInit];
    
    
    if(count>=1){
        tempPlayer = [playerNames objectAtIndex:0];
        self.firstPlayerLabelView.text=tempPlayer.name;
        self.firstPlayerLabelView.hidden=NO;
        self.firstPlayerScoreView.text=@"0";
        self.firstPlayerScoreView.hidden=NO;
    }
    if(count>=2){
        tempPlayer = [playerNames objectAtIndex:1];
        self.secondPlayerLabelView.text=tempPlayer.name;
        self.secondPlayerLabelView.hidden=NO;
        self.secondPlayerScoreView.text=@"0";
        self.secondPlayerScoreView.hidden=NO;
    }
    if(count>=3){
        tempPlayer = [playerNames objectAtIndex:2];
        self.thirdPlayerLabelView.text=tempPlayer.name;
        self.thirdPlayerLabelView.hidden=NO;
        self.thirdPlayerScoreView.text=@"0";
        self.thirdPlayerScoreView.hidden=NO;
    }
        if(count==4){
            tempPlayer = [playerNames objectAtIndex:3];
            self.fourthPlayerLabelView.text=tempPlayer.name;
            self.fourthPlayerLabelView.hidden=NO;
            self.fourthPlayerScoreView.text=@"0";
            self.fourthPlayerScoreView.hidden=NO;
    }
        
}


-(void)scoreBoardUpdateScores{
    
    GameLogic *gameLogic = [GameLogic GetInstance];
    
    NSNumber *temp = [gameLogic.score objectAtIndex:0];
    NSString *format = [NSString stringWithFormat:@"%@",temp];
    self.firstPlayerScoreView.text= format;
    
    temp = [gameLogic.score objectAtIndex:1];
    format = [NSString stringWithFormat:@"%@",temp];
    self.secondPlayerScoreView.text=format;
    
    temp = [gameLogic.score objectAtIndex:2];
    format = [NSString stringWithFormat:@"%@",temp];
    self.thirdPlayerScoreView.text=format;
    
    if (gameLogic.numberOfPlayers==4) {
        
        temp = [gameLogic.score objectAtIndex:3];
        format = [NSString stringWithFormat:@"%@",temp];
        self.fourthPlayerScoreView.text=format;
    }

    

}

- (IBAction)startGame:(id)sender {
    GameLogic* gameLogic = [GameLogic GetInstance];

    
    if(gameLogic.isServer){
        
        NSLog(@"YOU WANNA STARTING SOMETHING?");
        //WE SHOULD CALL START GAME FUNCTION
        gameLogic.isGamePause=NO;
        [middleButton setEnabled:NO];
        [middleButton setHidden:YES];
        Packet *packet=[Packet packetWithType:PacketTypeStartGame];
        [_game sendPacketToAllClients:packet];
    }
    else if(!gameLogic.isServer && _game._state==GameStateWaitingForReady){
        NSLog(@"Start Game Client Ready");
        Packet *packet = [Packet packetWithType:PacketTypeClientReady];
        [_game sendPacketToServer:packet];
        [middleButton setEnabled:NO];
        [middleButton setAlpha:0.4];
        [middleButton setTitle:@"JUST A SECOND..." forState:UIControlStateNormal];
        _game._state= GameStateReady;
    }
}

- (void)receivedServerReady:(NSString *)data
{
	NSLog(@"%@",data);
    //[_game beginGame];
    GameLogic* gameLogic = [GameLogic GetInstance];

    [middleButton setEnabled:YES];
    [middleButton setAlpha:1.0];
    [middleButton setTitle:@"READY?" forState:UIControlStateNormal];
    NSMutableArray *players=[NSMutableArray array];
    //players=[gameLogic.game._players copy];
    for(NSString * key in gameLogic.game._players)
        [players addObject:[gameLogic.game._players objectForKey:key]];
    
    [self scoreBoardInitWitNames:players];

}

- (void)allClientsReady:(NSString *)data
{
    NSLog(@"%@",data);
    //[_game beginGame];
    [middleButton setEnabled:YES];
    [middleButton setAlpha:1.0];
    [middleButton setTitle:@"START..." forState:UIControlStateNormal];
    NSLog(@"end of method");
}

- (void)beginGame{
    GameLogic* gameLogic = [GameLogic GetInstance];
    gameLogic.isGamePause = NO;
    //else if(!gameLogic.isServer && _game._state==GameStateWaitingForReady){
    NSLog(@"Starting Game on Clients");
    //Packet *packet = [Packet packetWithType:PacketTypeClientReady];
    //[_game sendPacketToServer:packet];
    //hidden the button
    [middleButton setEnabled:NO];
    [middleButton setHidden:YES];
    _game._state= GameStatePlaying;
    //}
    
    
    NSData *myData=[NSData data];
    NSMutableArray *array=[[NSMutableArray alloc] initWithCapacity:5];
    NSString *text=@"sasan";
    NSNumber *number=[NSNumber numberWithFloat:1.23];
    [array addObject:number];
    [array addObject:text];
    myData = [NSKeyedArchiver archivedDataWithRootObject:array];
 //   Packet *packet=[Packet packetWithData:myData];
 //   packet.packetType = PacketTypeClientQuit;
  //  [_game sendPacketToServer:packet];
}


- (IBAction)pauseGame:(id)sender {
    GameLogic* gameLogic = [GameLogic GetInstance];
    gameLogic.isGamePause=!gameLogic.isGamePause;
    
    if (gameLogic.isGamePause==YES) {
        [self pauseDialog];
    }

}

- (void) pauseDialog {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pause"
                                                    message:@"Game is paused, what's your decision?"
                                                   delegate:self
                                          cancelButtonTitle:@"Resume"
                                          otherButtonTitles:@"Quit", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"Resume shod");
        [self resumeGame];
    }
    else
        NSLog(@"quit shod");
}

-(void)resumeGame
{
    GameLogic *gameLogic = [GameLogic GetInstance];
    gameLogic.isGamePause = ! gameLogic.isGamePause;
}


-(void)quitGame
{
    NSLog(@"Quit Game Fired");
    [self.game quitGameWithReason:QuitReasonUserQuit];
}

-(void)receivedGameData:(GameData *)gameData{
    
    NSLog(@"method in gameView: %@",gameData);
    
}

@end
