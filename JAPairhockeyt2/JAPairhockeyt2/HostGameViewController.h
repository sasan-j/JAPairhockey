//
//  HostGameViewController.h
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/11/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchmakingServer.h"

@class HostGameViewController;


@protocol HostGameViewControllerDelegate <NSObject>

- (void)hostGameViewControllerDidCancel:(HostGameViewController *)controller;
- (void)hostGameViewController:(HostGameViewController*)controller didEndSessionWithReason:(QuitReason)reason;
- (void)hostGameViewController:(HostGameViewController*)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;

@end

@interface HostGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MatchmakingServerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *hostGameTitleLabel;

//@property int intendedPlayers;
@property (nonatomic, weak) id <HostGameViewControllerDelegate> delegate;
@property (nonatomic) int intendedPlayers;


- (IBAction)goBack:(id)sender;
- (IBAction)startAction:(id)sender;
- (IBAction)exitAction:(id)sender;


@end
