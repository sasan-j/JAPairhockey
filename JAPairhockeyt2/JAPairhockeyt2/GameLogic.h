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
@property (nonatomic) NSString *peerID;
@property (nonatomic) NSMutableArray *connectedPlayers;
@property (nonatomic) 	GKSession *session;
@property (nonatomic) BOOL isServer;
@property (nonatomic) NSString *serverID;
@property (nonatomic) BOOL isGamePause;
@property (nonatomic) BOOL isGameReady;

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
@property (nonatomic) float fieldWidthRatio;

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

@property (nonatomic) NSInteger goalX;
@property (nonatomic) NSInteger goalY;
@property (nonatomic) NSInteger goalWidth;
@property (nonatomic) NSInteger goalHeight;

@property (nonatomic) BOOL ballHolded;
@property (nonatomic) NSString *lastHit;
@property (nonatomic) NSMutableArray *score;
@property (nonatomic) int numberOfPlayers;



- (void)recomputeReflectionVectorForRectPad;

- (void)computeReflectionVectorForCirclePad;

- (void)moveTheBall;

- (void)scoreBoardInit;
- (void)goalScored;
- (void)holdBall;
-(void)sendBallMovement:(NSInteger)xPos;



+ (GameLogic *)GetInstance;


@end
