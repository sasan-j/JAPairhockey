//
//  HostGameConfigViewController.h
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/13/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchmakingServer.h"

@interface HostGameConfigViewController : UIViewController


@property (weak, nonatomic) IBOutlet UISegmentedControl *hostGameIntendedPlayers;

- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@end
