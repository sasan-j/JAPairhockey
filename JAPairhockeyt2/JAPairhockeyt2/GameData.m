//
//  GameData.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/19/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "GameData.h"

@implementation GameData

@synthesize peerID = _position;
@synthesize vecXComp = _vecXComp;
@synthesize vecYComp = _vecYComp;
@synthesize ballHorizonOffset = _ballHorizonOffset;
@synthesize lastHitPeerID = _lastHitPeerID;

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ ReceiverID = %@, XComp = %d, YComp = %d, XOffset=%f, Last Hit =%@", [super description], self.peerID, self.vecXComp, self.vecYComp,self.ballHorizonOffset,self.lastHitPeerID];
}

@end
