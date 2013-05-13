//
//  JoinGameViewController.h
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/12/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchmakingClient.h"


@class JoinGameViewController;


@protocol JoinGameViewControllerDelegate <NSObject>

- (IBAction)goBack:(id)sender;
- (void)joinGameViewControllerDidCancel:(JoinGameViewController *)controller;
- (void)joinGameViewController:(JoinGameViewController *)controller didDisconnectWithReason:(QuitReason)reason;
- (void)joinGameViewController:(JoinGameViewController *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;

@end


@interface JoinGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MatchmakingClientDelegate>

@property (nonatomic, weak) id <JoinGameViewControllerDelegate> delegate;


- (IBAction)goBack:(id)sender;
- (IBAction)exitAction:(id)sender;

@end