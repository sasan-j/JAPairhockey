//
//  GameData.h
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/19/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject

@property (nonatomic) NSString *peerID;

@property (nonatomic) int vecXComp;
@property (nonatomic) int vecYComp;
@property (nonatomic) float ballHorizonOffset;

@property (nonatomic) NSString *lastHitPeerID;


@end
