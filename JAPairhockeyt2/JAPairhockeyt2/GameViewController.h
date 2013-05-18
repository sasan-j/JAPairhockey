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

@end

@interface GameViewController : UIViewController <UIAlertViewDelegate, GameDelegate>

@property (nonatomic, retain) NSTimer* drawTimer;
@property (strong, nonatomic) IBOutlet UIView *airHockeyView;

@property (nonatomic, weak) id <GameViewControllerDelegate> delegate;
@property (nonatomic, strong) Game *game;

@property (nonatomic) NSInteger xCoord;
@property (nonatomic) NSInteger yCoord;
- (IBAction)startGame:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;

@end
