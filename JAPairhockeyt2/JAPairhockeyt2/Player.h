//
//  Player.h
//  Snap
//
//  Created by Ray Wenderlich on 5/25/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

typedef enum
{
	PlayerPositionFirst,  // the user
	PlayerPositionSecond,
	PlayerPositionThird,
	PlayerPositionForth
}
PlayerPosition;

@interface Player : NSObject

@property (nonatomic, assign) PlayerPosition position;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) BOOL receivedResponse;
@property (nonatomic, assign) int gamesWon;
@property (nonatomic) int score;

@end
