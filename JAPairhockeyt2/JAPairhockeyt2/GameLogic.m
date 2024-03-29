//
//  GameLogic.m
//  JAPairhockeyt2
//
//  Created by Hossein Arshad on 5/11/13.
//  Copyright (c) 2013 Hossein Arshad. All rights reserved.
//

#import "GameLogic.h"
#import "Game.h"
#import "GameData.h"
#import "PacketDataPacket.h"
#import "PacketGameEvent.h"

static GameLogic *uniqueInstance;

@implementation GameLogic

//sesion data
@synthesize game;
@synthesize session;
@synthesize connectedPlayers;
@synthesize isServer;
@synthesize serverID;
@synthesize isGamePause;
@synthesize isGameReady;





//player data
@synthesize peerID;
@synthesize playerName;

//Ball attributes
@synthesize xCoord;
@synthesize yCoord;
@synthesize vecXComp;
@synthesize vecYComp;
@synthesize transitionPointYComp;
@synthesize width;
@synthesize height;
@synthesize goingLeft;
@synthesize goingUp;

//Field attributes
@synthesize fieldHeight;
@synthesize fieldWidth;

//Pad attributes
@synthesize padX;
@synthesize padY;
@synthesize padHeight;
@synthesize padWidth;
@synthesize padDrag;
@synthesize padYDrag;
@synthesize padDragEndXComp;
@synthesize padDragStartXComp;
@synthesize padDragNewXComp;
@synthesize padDragOldXComp;
@synthesize padDragNewYComp;
@synthesize padDragOldYComp;
@synthesize dragStarted;


@synthesize goalX;
@synthesize goalY;
@synthesize goalWidth;
@synthesize goalHeight;

@synthesize lastHit;
@synthesize ballHolded;
@synthesize score;
@synthesize numberOfPlayers;
@synthesize playerPositions;


- (void)moveTheBall
{
    
    if (!(self.vecXComp==0 && self.vecYComp==0)){
    [self computeReflectionVectorForCirclePad];
        
    }
    else{
                
        if ([self detectPadBallCollision]){
            NSLog(@"the COl is fine");
            self.vecXComp=10;
            self.vecYComp=4;
            //We Should Set this parameter to NO when we received the packet 
            self.ballHolded=NO;
            
        }
    }
    
    if ((self.yCoord+self.height >= self.fieldHeight)
        &&(self.xCoord >= self.goalX)
        && (self.xCoord+self.width <= self.goalX+self.goalWidth)) {
        
        // I received a Goal send Packet to the server
        NSLog(@"I Received A GOAL!");
        [self goalScored];
    
    }
    
    //Detect if the ball is going outside of the screen--> send packet to right or left
    switch (self.numberOfPlayers) {
        case 3:
            {
                if (self.yCoord <= (-self.height) && self.vecYComp < 0)
                {
                    if (!ballHolded)
                    {                        
                        
                        if ( (self.xCoord+self.width/2) <= self.fieldWidth/2 )
                        {
                        //Send Packet to the Left player with coordinates
                        NSLog(@"Packet To Left");
                            [self sendBallMovement:self.xCoord destPeerID:[self.playerPositions objectAtIndex:0]];

                        
                          [self holdBall];
                        }
                        else{
                        //Send Packet to the Right Player With Coordinates
                        NSLog(@"Packet To Right");
                            [self sendBallMovement:self.xCoord destPeerID:[self.playerPositions objectAtIndex:1]];

                         [self holdBall];
                        
                        }
                    
                    }
                }
            }
            break;
            
        case 4:
            {
                if (self.yCoord<= (-self.height) && self.vecYComp < 0) {
                    if(!ballHolded)
                    {
                        [self sendBallMovement:self.xCoord destPeerID:[self.playerPositions objectAtIndex:1]];
                        
                       if ((self.xCoord+self.width <= self.fieldWidth/3.5))
                       {
                           //Send Packet To left
                           NSLog(@"Send Packet To Left");
                       }
                        else if ((self.xCoord+self.width/2) > self.fieldWidth/3.5
                                  &&(self.xCoord+self.width/2)<= self.fieldWidth/2)
                           {
                               //Senf Packet To Middle
                               NSLog(@"Send Packet To Middle");
                           }
                           else
                           {
                               //Send Packet To Right
                               NSLog(@"Send Packet To Right");
                           }
                    }
                }
            }
            break;
    }

    
       
       
        

    

    
        if (self.xCoord+self.width > self.fieldWidth || self.xCoord - self.width < 0) self.vecXComp = -self.vecXComp;
        if (self.yCoord+self.height > self.fieldHeight || self.yCoord < -self.height-3) self.vecYComp = -self.vecYComp;
        self.xCoord += self.vecXComp;
        self.yCoord += self.vecYComp;
 

}

- (float)computeIncidentAngle
{
    float angle1 = atan2f(0, self.width);
    float angle2 = atan2f(self.yCoord - self.padY, self.xCoord - self.padX);
    
    //NSLog(@"Incident angle: %f", (angle1-angle2)*180/M_PI);
    
    return (angle1-angle2)*180/M_PI;
}

- (void)computeReflectionVectorForCirclePad
{
    if ([self detectPadBallCollision])
    {
        //setting last hit to current player for computing Goal event later in game
        self.lastHit=self.peerID;

        float incidentAngle = [self computeIncidentAngle];
        if (incidentAngle > 0 && incidentAngle <= 30)
        {
            //self.vecXComp = 20*log10(90/incidentAngle);
            self.vecXComp = 8;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle > 30 && incidentAngle <= 60)
        {
            self.vecXComp = 5;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle > 60 && incidentAngle <= 90)
        {
            self.vecXComp = 4;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle > 90 && incidentAngle <= 120)
        {
            self.vecXComp = -4;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle > 120 && incidentAngle <= 150)
        {
            self.vecXComp = -5;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle > 150 && incidentAngle <= 180)
        {
            self.vecXComp = -8;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle < 0 && incidentAngle >= -30)
        {
            self.vecXComp = 8;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle < -30 && incidentAngle >= -60)
        {
            self.vecXComp = 5;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle < -60 && incidentAngle >= -90)
        {
            self.vecXComp = 4;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle < -90 && incidentAngle >= -120)
        {
            self.vecXComp = -4;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle < -120 && incidentAngle >= -150)
        {
            self.vecXComp = -5;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle < -150 && incidentAngle >= -180)
        {
            self.vecXComp = -8;
            self.vecYComp = -self.vecYComp;
        }
    }
}

- (void)recomputeReflectionVectorForRectPad
{
    if (self.xCoord+self.width > self.padX &&
        self.xCoord < self.padX+self.padWidth &&
        self.yCoord+self.height > self.padY)
    {
        self.vecXComp += ((self.xCoord+self.width/2) - (self.padX+self.padWidth/2));
        self.vecYComp = -self.vecYComp;
    }
}

- (BOOL)detectPadBallCollision
{
    
    NSInteger bX = self.xCoord;
    NSInteger bY = self.yCoord;
    NSInteger pX = self.padX;
    NSInteger pY = self.padY;
    NSInteger bRad = self.width/2;
    NSInteger pRad = self.padWidth/2;
    if (sqrt(pow(pX-bX, 2.0)+pow(pY-bY, 2.0)) < (bRad + pRad))
    {
        
        return YES;
    }

    return NO;
}

-(void)goalScored
{
    NSLog(@"Scored A Goal");
        
    if(!self.isServer){
        Packet *packet=[Packet packetWithType:PacketTypeReceivedGoal];
        [self.game sendPacketToServer:packet];
        
        packet=[PacketGameEvent packetWithRecPeerID:self.lastHit];
        [self.game sendPacketToServer:packet];
    }
    else{
       // NSInteger add;
       // add=0;
       // add=[[score objectAtIndex:0] integerValue];
       // add+=1;
        //[score setObject:[NSNumber numberWithInt:add] atIndexedSubscript:0];
        //NSLog(@"UP player's Score is : %@",[score objectAtIndex:0]);
        [game receiveGoal:self.peerID lastHitPeerID:self.lastHit];
    }
    [self resetBallPosition];
   /*
    if (isServer==YES)
    {
        [self scoreBoard:score];
        
    }
    */
}

- (void) scoreBoardInit
{
    
    self.score = [NSMutableArray array];
    //self.score = [[NSMutableArray alloc]initWithObjects:(id), ..., nil];
    for (NSInteger i = 0; i < self.numberOfPlayers ; i++){
        [self.score addObject:[NSNumber numberWithInteger:0]];
        NSLog(@"%@",[[self score]objectAtIndex:i]);
        NSLog(@"numbe of players is: %i",numberOfPlayers);
    }
    Player *player;
    for(NSString * key in game._players){
        player=[game._players objectForKey:key];
    player.score = 0;
    }
    NSLog(@"after initializing score with zero: %@",game._players);
    
}


-(void)resetBallPosition{

    self.xCoord = self.fieldWidth/2;
    self.yCoord = self.fieldHeight/2;
    self.vecYComp = 0;
    self.vecXComp = 0;
}

-(void)holdBall{
    self.xCoord = self.fieldWidth/2;
    self.yCoord = -20;
    self.vecXComp =0;
    self.vecYComp =0;
    self.ballHolded = TRUE;
    //[self resetBallPosition];
}



+ (GameLogic *)GetInstance
{
    @synchronized(self) {
        if (uniqueInstance == nil) {
            uniqueInstance = [[GameLogic alloc] init];
            uniqueInstance.playerScores = [NSMutableDictionary dictionary];
            uniqueInstance.isServer = NO;
            //uniqueInstance.isGamePause = NO;
            uniqueInstance.isGamePause = YES;
            // Definition of Ball
            uniqueInstance.isGameReady = NO;
            uniqueInstance.lastHit = @"Undefined Player";
            uniqueInstance.width = 20;
            uniqueInstance.height = 20;
            uniqueInstance.xCoord = 0;//- uniqueInstance.width;
            uniqueInstance.yCoord = 0;//- uniqueInstance.height;

            
            //Deifnition of the movement vectors
            uniqueInstance.vecXComp = 0;
            uniqueInstance.vecYComp = 0;
            uniqueInstance.transitionPointYComp = -1;
            uniqueInstance.goingLeft = NO;
            uniqueInstance.goingUp = NO;
            uniqueInstance.dragStarted = NO;
            uniqueInstance.connectedPlayers = [NSMutableArray array];
            uniqueInstance.fieldWidthRatio = 0.8;
       
            //Retrieve screen dimensions properly and set the field values accordingly
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            uniqueInstance.fieldWidth = (int)roundf(screenRect.size.height *uniqueInstance.fieldWidthRatio);
            NSLog(@"%f  width",screenRect.size.width);
            uniqueInstance.fieldHeight = (int)roundf(screenRect.size.width);
            
            
            //Goal Definition
            uniqueInstance.goalWidth = 150;
            uniqueInstance.goalX = uniqueInstance.fieldWidth/2 - uniqueInstance.goalWidth/2;
            NSLog(@"%i  width",uniqueInstance.fieldWidth);
            NSLog(@"%i  height",uniqueInstance.fieldHeight);
            
            uniqueInstance.goalY = uniqueInstance.fieldHeight - 5;
            uniqueInstance.goalHeight = 5;
            
            
            //Definition Pad 
            uniqueInstance.padX = uniqueInstance.fieldWidth / 2;
            uniqueInstance.padY = uniqueInstance.fieldWidth - 50;
            uniqueInstance.padWidth = 60;
            uniqueInstance.padHeight = 60;
            
            //uniqueInstance.lastHit = @"nil";
            uniqueInstance.padDrag = 0;
            uniqueInstance.numberOfPlayers=3;
            uniqueInstance.playerPositions = [NSMutableArray array];
            
        }
        return uniqueInstance;
    }
}

-(void)sendBallMovement:(NSInteger)xPos destPeerID:(NSString *)peerID{
    NSLog(@"sending ball position to server");
    GameData *gameData = [[GameData alloc] init];
    gameData.peerID=peerID;
    
    gameData.vecXComp = self.vecXComp;
    gameData.vecYComp = -self.vecYComp;
    gameData.ballHorizonOffset=0.3;
    gameData.lastHitPeerID = self.lastHit;
    NSLog(@"game data to send: %@",gameData);
    
    PacketDataPacket *packet=[PacketDataPacket packetWithGameData:gameData];
    if(!self.isServer)
        [self.game sendPacketToServer:packet];
    else{
        [self.game sendPacketToClient:packet destPeerID:peerID];
    }
}

-(void)initGameStartingState
{
    if (!self.isServer)
    {
        [self holdBall];
    }
    else{
        self.xCoord=fieldWidth/2;
        self.yCoord=fieldHeight/2;
    }
}



@end
