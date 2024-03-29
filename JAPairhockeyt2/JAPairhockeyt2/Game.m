//
//  Game.m
//  Snap
//
//  Created by Ray Wenderlich on 5/25/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Game.h"
#import "Packet.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"
#import "PacketOtherClientQuit.h"
#import "GameLogic.h"
#import "GameViewController.h"
#import "GameData.h"
#import "PacketDataPacket.h"
#import "PacketGameEvent.h"
#import "PacketScoreUpdate.h"



@implementation Game
{
	GameState _state;
    
	GKSession *_session;
	NSString *_serverPeerID;
	NSString *_localPlayerName;
  
    
    NSMutableDictionary *_players;
}

@synthesize _state;
@synthesize delegate = _delegate;
@synthesize isServer = _isServer;
@synthesize _players;



- (id)init
{
	if ((self = [super init]))
	{
		_players = [NSMutableDictionary dictionaryWithCapacity:4];
	}
    
	return self;
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

#pragma mark - Game Logic

- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
	self.isServer = NO;
    
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[_session setDataReceiveHandler:self withContext:nil];
    
	_serverPeerID = peerID;
	_localPlayerName = name;
    
	_state = GameStateWaitingForSignIn;
    
	[self.delegate gameWaitingForServerReady:self];
}

- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
	self.isServer = YES;
    
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[_session setDataReceiveHandler:self withContext:nil];
    
	_state = GameStateWaitingForSignIn;
    
	[self.delegate gameWaitingForClientsReady:self];
    
    // Create the Player object for the server.
	Player *player = [[Player alloc] init];
	player.name = name;
	player.peerID = _session.peerID;
	player.position = PlayerPositionFirst;
	[_players setObject:player forKey:player.peerID];
    
	// Add a Player object for each client.
	int index = 0;
	for (NSString *peerID in clients)
	{
		Player *player = [[Player alloc] init];
		player.peerID = peerID;
		[_players setObject:player forKey:player.peerID];
        
		if (index == 0)
			player.position = ([clients count] == 1) ? PlayerPositionThird : PlayerPositionSecond;
		else if (index == 1)
			player.position = PlayerPositionThird;
		else
			player.position = PlayerPositionForth;
        
		index++;
	}
    
    Packet *packet = [Packet packetWithType:PacketTypeSignInRequest];
	[self sendPacketToAllClients:packet];
    
}

- (void)quitGameWithReason:(QuitReason)reason
{
	_state = GameStateQuitting;
    NSLog(@"Quit Game function in game.m %u",reason);
    
	if (reason == QuitReasonUserQuit)
	{
		if (self.isServer)
		{
			Packet *packet = [Packet packetWithType:PacketTypeServerQuit];
			[self sendPacketToAllClients:packet];
		}
		else
		{
			Packet *packet = [Packet packetWithType:PacketTypeClientQuit];
			[self sendPacketToServer:packet];
		}
	}
    [_delegate quitGame];///quit game hardly!
	[_session disconnectFromAllPeers];
	_session.delegate = nil;
	_session = nil;
    
	[self.delegate game:self didQuitWithReason:reason];
}

- (void)clientReceivedPacket:(Packet *)packet
{
    GameLogic *gameLogic = [GameLogic GetInstance];
	switch (packet.packetType)
	{
            
        case PacketTypeDataPacket:
            if (YES)//_state == GameStatePlaying)
			{
                NSLog(@"client received PacketTypeDataPacket");
                GameData *gameData;
				gameData = ((PacketDataPacket *)packet).gameData;
				//Packet *packet = [Packet packetWithType:PacketTypeClientReady];
				//[self sendPacketToServer:packet];
				//[self beginGame];
                [_delegate receivedGameData:gameData];
			}
			break;
            
            
		case PacketTypeSignInRequest:
			if (_state == GameStateWaitingForSignIn)
			{
                NSLog(@"Client received PacketTypeSignInRequest");
				_state = GameStateWaitingForReady;
				Packet *packet = [PacketSignInResponse packetWithPlayerName:_localPlayerName];
                NSLog(@"packet content:%@",packet);
				[gameLogic.game sendPacketToServer:packet];
			}
			break;

            
            
        case PacketTypeScoreUpdate:
            NSLog(@"Client received PacketTypeScoreUpdate");
			if (YES)//_state == GameStateWaitingForReady)
			{
                GameLogic* gameLogic = [GameLogic GetInstance];
                
				_players = ((PacketServerReady *)packet).players;
                
                NSLog(@"game.m : players from gameLogic.game : %@",gameLogic.game._players);

                NSLog(@"player positions: %@",gameLogic.game._players);
                
                [_delegate scoreBoardUpdateScores];
                
                
			}
			break;
            
            
        case PacketTypeServerReady:
            NSLog(@"Client received PacketTypeServerReady");
			if (_state == GameStateWaitingForReady)
			{
                GameLogic* gameLogic = [GameLogic GetInstance];

				_players = ((PacketServerReady *)packet).players;
                //[self changeRelativePositionsOfPlayers];
                
                NSLog(@"game.m : players from gameLogic.game : %@",gameLogic.game._players);                
				//Packet *packet = [Packet packetWithType:PacketTypeClientReady];
				//[self sendPacketToServer:packet];
                
				//[self beginGame];
                NSString * tempPeerID;
                //NSLog(@"gameLogic: %@",gameLogic.peerID);
                for(NSString * key in _players)
                {
                    tempPeerID=[[_players objectForKey:key] peerID];
                    //NSLog(@"tempPeerID: %@",tempPeerID);
                    if([tempPeerID caseInsensitiveCompare:gameLogic.peerID]!=NSOrderedSame)
                        [gameLogic.playerPositions addObject:tempPeerID];
                }
                NSLog(@"player positions: %@",gameLogic.playerPositions);
                
                
                [_delegate receivedServerReady:@"SomeData"];
                NSLog(@"after method");


			}
			break;

            
        case PacketTypePauseGame:
            NSLog(@"Client received PacketTypePauseGame");
            
			if (_state == GameStatePlaying)
			{
            NSLog(@"Client handling PacketTypePauseGame");

                GameLogic* gameLogic = [GameLogic GetInstance];
                gameLogic.isGamePause=YES;
                _state=GameStatePause;
                
                [_delegate pauseDialog];
			}
			break;
         
            
            
        case PacketTypeStartGame:
            NSLog(@"Client received PacketTypeStartGame");

			if (_state == GameStateReady)
			{
                _state = GameStatePlaying;
                //GameLogic* gameLogic = [GameLogic GetInstance];
                //gameLogic.isGamePause=NO;
                [_delegate beginGame];
			}	
			break;
            
        case PacketTypeServerQuit:
            NSLog(@"Client received PacketTypeServerQuit");

			[self quitGameWithReason:QuitReasonServerQuit];
			break;            
            
 
        case PacketTypeOtherClientQuit:
            NSLog(@"Client received PacketTypeOtherClientQuit");

			if (_state != GameStateQuitting)
			{
                [_delegate quitGame];
			}
			break;
            

            
		default:
			NSLog(@"Client received unexpected packet: %@", packet);
			break;
	}
}

- (BOOL)receivedResponsesFromAllPlayers
{
    NSLog(@"inside receivedResponsesFromAllPlayers");
    NSLog(@"these are players %@",_players);

	for (NSString *peerID in _players)
	{
		Player *player = [self playerWithPeerID:peerID];
        NSLog(@"inside for player: %@",player);
		if (!player.receivedResponse)
			return NO;
	}
	return YES;
}

- (void)serverReceivedPacket:(Packet *)packet fromPlayer:(Player *)player
{
	switch (packet.packetType)
	{
  		case PacketTypeSignInResponse:
			if (_state == GameStateWaitingForSignIn)
			{
				player.name = ((PacketSignInResponse *)packet).playerName;
                NSLog(@"received sign in response for %@",player.name);

                
				if ([self receivedResponsesFromAllPlayers])
                    
				{
                    NSLog(@"received sign in response for all");

					_state = GameStateWaitingForReady;
                    
					Packet *packet = [PacketServerReady packetWithPlayers:_players];
                    NSLog(@"server ready sent");
                    
                //setting player positions
                    GameLogic* gameLogic = [GameLogic GetInstance];
  
                    //[self beginGame];
                    NSString * tempPeerID;
                    //NSLog(@"gameLogic: %@",gameLogic.peerID);
                    for(NSString * key in _players)
                    {
                        tempPeerID=[[_players objectForKey:key] peerID];
                        //NSLog(@"tempPeerID: %@",tempPeerID);
                        if([tempPeerID caseInsensitiveCompare:gameLogic.peerID]!=NSOrderedSame)
                            [gameLogic.playerPositions addObject:tempPeerID];
                    }
                    
                    //NSLog(@"player positions: %@",gameLogic.playerPositions);
                    
                    

					[self sendPacketToAllClients:packet];
				}
			}
			break;
        case PacketTypeDataPacket:

			if (YES)//_state == GameStatePlaying)
			{
                NSLog(@"Server received PacketTypeDataPacket");
                GameData *gameData;
                NSLog(@"GameStatePlaying");
				gameData = ((PacketDataPacket *)packet).gameData;
				//Packet *packet = [Packet packetWithType:PacketTypeClientReady];
				//[self sendPacketToServer:packet];
				//[self beginGame];
                if([gameData.peerID caseInsensitiveCompare:_session.peerID]==NSOrderedSame)
                    [_delegate receivedGameData:gameData];
                else{
                    [self sendPacketToClient:packet destPeerID:gameData.peerID];

                }
                //NSLog(@"after method");
			}
			break;
            
            
        case PacketTypeGameEvent:
            if (YES)//_state == GameStatePlaying)
			{
                NSLog(@"server received PacketTypeGameEvent");
                NSString *recPeerID;
				recPeerID = ((PacketGameEvent *)packet).recPeerID;
				//Packet *packet = [Packet packetWithType:PacketTypeClientReady];
				//[self sendPacketToServer:packet];
				//[self beginGame];
                //[_delegate receivedGameData:gameData];
                Player *tempPlayer;
                tempPlayer=player;
                [self receiveGoal:player.peerID lastHitPeerID:recPeerID];
			}
			break;
            
        case PacketTypeClientReady:
            NSLog(@"State: %d, received Responses: %d", _state, [self receivedResponsesFromAllPlayers]);
			if (_state == GameStateWaitingForReady && [self receivedResponsesFromAllPlayers])
			{
                _state = GameStateReady;
                NSLog(@"Server Beginning game");
				//[self beginGame];
                [_delegate allClientsReady:@"Now you are able to begin that fucking game"];
			}
			break;
            
        case PacketTypeReceivedGoal:
            NSLog(@"Player received GOAL");

            NSLog(@"Player %@ received GOAL",player.name);
            //[self receiveGoal:player.peerID];
			//[self clientDidDisconnect:player.peerID];
			break;
 
            
        case PacketTypePauseRequest:
            NSLog(@"Server received PacketTypePauseRequest");
            if(self._state==GameStatePlaying){
            NSLog(@"Handling PacketTypePauseRequest");

            GameLogic* gameLogic = [GameLogic GetInstance];
            Packet *packet=[Packet packetWithType:PacketTypePauseGame];
            [self sendPacketToAllClients:packet];
            self._state = GameStatePause;
            gameLogic.isGamePause=YES;
            [_delegate pauseDialog];
            //[self receiveGoal:player.peerID];
			//[self clientDidDisconnect:player.peerID];
            }
			break;
            

            
            
        case PacketTypeClientQuit:
            NSLog(@"Server received PacketTypeClientQuit");
			[self clientDidDisconnect:player.peerID];
            _state = GameStateQuitting;
            [_delegate quitGame];
            [_delegate clearGameData];
			break;            
            
		default:
			NSLog(@"Server received unexpected packet: %@", packet);
			break;
	}
}

- (Player *)playerWithPeerID:(NSString *)peerID
{
	return [_players objectForKey:peerID];
}

- (void)beginGame
{
    GameLogic *gameLogic=[GameLogic GetInstance];
	_state = GameStatePlaying;
    gameLogic.isGameReady = YES;
	[self.delegate gameDidBegin:self];//
    
}

- (void)changeRelativePositionsOfPlayers
{
	NSAssert(!self.isServer, @"Must be client");
    
	Player *myPlayer = [self playerWithPeerID:_session.peerID];
	int diff = myPlayer.position;
	myPlayer.position = PlayerPositionFirst;
    
	[_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop)
     {
         if (obj != myPlayer)
         {
             obj.position = (obj.position - diff) % 4;
         }
     }];
}

- (Player *)playerAtPosition:(PlayerPosition)position
{
	NSAssert(position >= PlayerPositionFirst && position <= PlayerPositionForth, @"Invalid player position");
    
	__block Player *player;
	[_players enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         player = obj;
         if (player.position == position)
             *stop = YES;
         else
             player = nil;
     }];
    
	return player;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"Game: peer %@ changed state %d", peerID, state);
#endif
    
	if (state == GKPeerStateDisconnected)
	{
		if (self.isServer)
		{
			[self clientDidDisconnect:peerID];
		}
        else if ([peerID isEqualToString:_serverPeerID])
		{
			[self quitGameWithReason:QuitReasonConnectionDropped];
		}
	}
}
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"Game: connection request from peer %@", peerID);
#endif
    
	[session denyConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: connection with peer %@ failed %@", peerID, error);
#endif
    
	// Not used.
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: session failed %@", error);
#endif
    
	if ([[error domain] isEqualToString:GKSessionErrorDomain])
	{
		if (_state != GameStateQuitting)
		{
			[self quitGameWithReason:QuitReasonConnectionDropped];
		}
	}
}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
    NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);

#ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil)
	{
		NSLog(@"Invalid packet: %@", data);
		return;
	}
    
	Player *player = [self playerWithPeerID:peerID];
    if (player != nil)
	{
        NSLog(@"Received packed- response from %@ is turned to yes",peerID);
		player.receivedResponse = YES;  // this is the new bit
	}
    
	if (self.isServer)
		[self serverReceivedPacket:packet fromPlayer:player];
	else
		[self clientReceivedPacket:packet];
}

#pragma mark - Networking

- (void)sendPacketToAllClients:(Packet *)packet
{
	GKSendDataMode dataMode = GKSendDataReliable;
	NSData *data = [packet data];
	NSError *error;

    //NSLog(@"data mode is:%u",dataMode);
    //NSLog(@"packet is:%@",data);
    //NSLog(@"error is:%@",error);
    
    //NSLog(@"players are:%@",_players);
    
    [_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop)
     {
         obj.receivedResponse = [_session.peerID isEqualToString:obj.peerID];
     }];
    
	if (![_session sendDataToAllPeers:data withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to clients: %@", error);
	}
}

- (void)sendPacketToClient:(Packet *)packet  destPeerID:(NSString *)peerID;
{
    //NSLog(@"sendPacketToServer");
	GKSendDataMode dataMode = GKSendDataReliable;
    //NSLog(@"data mode is:%u",dataMode);
    
	NSData *data = [packet data];
    //NSLog(@"packet is:%@",data);
    
	NSError *error;
    
    //NSLog(@"error is:%@",error);
    
    //NSLog(@"players are:%@",_players);
    
	if (![_session sendData:data toPeers:[NSArray arrayWithObject:peerID] withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to client: %@", error);
	}
}

- (void)sendPacketToServer:(Packet *)packet
{
    //NSLog(@"sendPacketToServer");
	GKSendDataMode dataMode = GKSendDataReliable;
    //NSLog(@"data mode is:%u",dataMode);

	NSData *data = [packet data];
    //NSLog(@"packet is:%@",data);

	NSError *error;
    
    NSLog(@"error is:%@",error);
    
    NSLog(@"players are:%@",_players);
    NSLog(@"server is %@",_serverPeerID);

	if (![_session sendData:data toPeers:[NSArray arrayWithObject:_serverPeerID] withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to server: %@", error);
	}
}

- (void)clientDidDisconnect:(NSString *)peerID
{
    NSLog(@"Client did disconnect function");
	if (_state != GameStateQuitting)
	{
		Player *player = [self playerWithPeerID:peerID];
		if (player != nil)
		{
			[_players removeObjectForKey:peerID];
            
			if (_state != GameStateWaitingForSignIn)
			{
				// Tell the other clients that this one is now disconnected.
				if (self.isServer)
				{
					PacketOtherClientQuit *packet = [PacketOtherClientQuit packetWithPeerID:peerID];
					[self sendPacketToAllClients:packet];
				}			
                
				//[self.delegate game:self playerDidDisconnect:player];
			}
		}
	}
}


-(void)receiveGoal:(NSString *)receiverPeerID lastHitPeerID:(NSString *)lastHitPeerID{
    //GameLogic* gameLogic = [GameLogic GetInstance];
    NSLog(@"%@ scores one over %@",lastHitPeerID,receiverPeerID);
    Player *player=[_players objectForKey:lastHitPeerID];
    if(lastHitPeerID!=receiverPeerID){
    player.score= player.score+1;
    }
    player=[_players objectForKey:receiverPeerID];
    player.score= player.score-1;
    NSLog(@"Send Packet for score update : %@",_players);
    Packet *packet=[PacketScoreUpdate packetWithPlayers:_players ];
    [self sendPacketToAllClients:packet];
    
    
    [_delegate scoreBoardUpdateScores];
}


-(void)listPlayers{
    //NSString *id;
    NSLog(@"inside list players");
    for (id key in _players) {
        NSLog(@"Player name is : %@",[_players objectForKey:key]);
    }
}

@end
