//
//  GameControllerViewController.h
//  JAPairhockeyt2
//
//  Created by JAFARNEJAD Sasan on 5/17/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

//@class Game;
@class GameViewController;

@protocol GameViewControllerDelegate <NSObject>

- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason;
- (void)receivedServerReady:(NSString *)data;
- (void)allClientsReady:(NSString *)data;
- (void)beginGame;

@end

@interface GameViewController : UIViewController <GameDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) NSTimer* drawTimer;
@property (strong, nonatomic) IBOutlet UIView *airHockeyView;

@property (nonatomic, weak) id <GameViewControllerDelegate> delegate;
@property (nonatomic, strong) Game *game;

@property (nonatomic) NSInteger xCoord;
@property (nonatomic) NSInteger yCoord;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerScoreView; 
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerScoreView;
@property (weak, nonatomic) IBOutlet UILabel *thirdPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *thirdPlayerScoreView;
@property (weak, nonatomic) IBOutlet UILabel *fourthPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *fourthPlayerScoreView;

- (IBAction)startGame:(id)sender;
- (void)receivedServerReady:(NSString *)data;
- (void)allClientsReady:(NSString *)data;
- (void)beginGame;
- (IBAction)pauseGame:(id)sender;

-(void)scoreBoardInitWitNames:(NSMutableArray*)playerNames;
-(void)scoreBoardUpdateScores;

@end
