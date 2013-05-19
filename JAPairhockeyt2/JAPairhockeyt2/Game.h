//
//  Game.h
//  Snap
//
//  Created by Ray Wenderlich on 5/25/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Player.h"

@class Game;
@class Packet;


typedef enum
{
	GameStateWaitingForSignIn,
	GameStateWaitingForReady,
    GameStateReady,
	GameStatePlaying,
    GameStatePause,
	GameStateGameOver,
	GameStateQuitting,
}
GameState;

@protocol GameDelegate <NSObject>

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason;
- (void)gameWaitingForServerReady:(Game *)game;
- (void)gameWaitingForClientsReady:(Game *)game;
- (void)gameDidBegin:(Game *)game;
- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer;
- (void)gameShouldDealCards:(Game *)game startingWithPlayer:(Player *)startingPlayer;
- (void)game:(Game *)game didActivatePlayer:(Player *)player;
- (void)game:(Game *)game didRecycleCards:(NSArray *)recycledCards forPlayer:(Player *)player;
- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer redistributedCards:(NSDictionary *)redistributedCards;
- (void)game:(Game *)game playerCalledSnapWithNoMatch:(Player *)player;


//gameViewController
- (void)receivedServerReady:(NSString *)data;
- (void)allClientsReady:(NSString *)data;
- (void)beginGame;



@end

@interface Game : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <GameDelegate> delegate;
@property (nonatomic, assign) BOOL isServer;
@property (nonatomic) GameState _state;


- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;
- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;
- (void)quitGameWithReason:(QuitReason)reason;
- (Player *)playerAtPosition:(PlayerPosition)position;
- (void)sendPacketToServer:(Packet *)packet;
- (void)sendPacketToAllClients:(Packet *)packet;

- (void)beginGame;




-(void)listPlayers;

@end
