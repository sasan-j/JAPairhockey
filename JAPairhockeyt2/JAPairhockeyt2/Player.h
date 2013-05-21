//
//  Player.h
//  JAPairhockeyt2
//
//  Created by Hossein Arshad on 5/11/13.
//  Copyright (c) 2013 Hossein Arshad. All rights reserved.
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
