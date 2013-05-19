//
//  GameControllerViewController.h
//  JAPairhockeyt2
//
//  Created by JAFARNEJAD Sasan on 5/17/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@class GameViewController;

@protocol GameViewControllerDelegate <NSObject>

- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason;

@end

@interface GameViewController : UIViewController <UIAlertViewDelegate, GameDelegate>

@property (nonatomic, retain) NSTimer* drawTimer;
@property (strong, nonatomic) IBOutlet UIView *airHockeyView;

@property (nonatomic, weak) id <GameViewControllerDelegate> delegate;
@property (nonatomic, strong) Game *game;

@property (nonatomic) NSInteger xCoord;
@property (nonatomic) NSInteger yCoord;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerScoreView; 
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerScoreView;
@property (weak, nonatomic) IBOutlet UILabel *thirdPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *thirdPlayerScoreView;
@property (weak, nonatomic) IBOutlet UILabel *fourthPlayerLabelView;
@property (weak, nonatomic) IBOutlet UILabel *fourthPlayerScoreView;


-(void)scoreBoardInitWitNames:(NSMutableArray*)playerNames;
-(void)scoreBoardUpdateScores;

@end
