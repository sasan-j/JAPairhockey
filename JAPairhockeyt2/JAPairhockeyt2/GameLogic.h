//
//  GameLogic.h
//  AirHockey
//
//  Created by Arash Atashpendar on 5/15/13.
//  Copyright (c) 2013 SHT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@interface GameLogic : NSObject

@property (nonatomic) Game *game;
@property (nonatomic) NSString *playerName;
@property (nonatomic) NSMutableArray *connectedPlayers;
@property (nonatomic) 	GKSession *session;
@property (nonatomic) BOOL isServer;
@property (nonatomic) NSString *serverID;

@property (nonatomic) NSInteger xCoord;
@property (nonatomic) NSInteger yCoord;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;

@property (nonatomic) NSInteger vecXComp;
@property (nonatomic) NSInteger vecYComp;

@property (nonatomic) NSInteger transitionPointYComp;

@property (nonatomic) BOOL goingLeft;
@property (nonatomic) BOOL goingUp;

@property (nonatomic) NSInteger fieldWidth;
@property (nonatomic) NSInteger fieldHeight;

@property (nonatomic) NSInteger padX;
@property (nonatomic) NSInteger padY;
@property (nonatomic) NSInteger padWidth;
@property (nonatomic) NSInteger padHeight;

@property (nonatomic) NSInteger padDrag;
@property (nonatomic) NSInteger padYDrag;
@property (nonatomic) NSInteger padDragStartXComp;
@property (nonatomic) NSInteger padDragOldXComp;

@property (nonatomic) NSInteger padDragOldYComp;
@property (nonatomic) NSInteger padDragNewYComp;

@property (nonatomic) NSInteger padDragNewXComp;
@property (nonatomic) NSInteger padDragEndXComp;
@property (nonatomic) BOOL dragStarted;

- (void)recomputeReflectionVector;

- (void)moveTheBall;

+ (GameLogic *)GetInstance;


@end
