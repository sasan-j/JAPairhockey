//
//  GameLogic.m
//  AirHockey
//
//  Created by Arash Atashpendar on 5/15/13.
//  Copyright (c) 2013 SHT. All rights reserved.
//

#import "GameLogic.h"
#import "Game.h"

static GameLogic *uniqueInstance;

@implementation GameLogic

//sesion data
@synthesize game;
@synthesize session;
@synthesize connectedPlayers;
@synthesize isServer;
@synthesize serverID;

//player data
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

- (void)moveTheBall
{
    [self recomputeReflectionVector];
    
    if (self.xCoord+self.width > self.fieldWidth || self.xCoord < 0) self.vecXComp = -self.vecXComp;
    if (self.yCoord+self.height > self.fieldHeight || self.yCoord < 0) self.vecYComp = -self.vecYComp;
    
    self.xCoord += self.vecXComp;
    self.yCoord += self.vecYComp;
}

- (void)recomputeReflectionVector
{
    if (self.xCoord+self.width > self.padX &&
        self.xCoord < self.padX+self.padWidth &&
        self.yCoord+self.height > self.padY)
    {
        self.vecXComp += ((self.xCoord+self.width/2) - (self.padX+self.padWidth/2));
/*        if (self.xCoord+self.width/2 > self.padX+self.padWidth/2)
        {
            self.vecXComp += ((self.xCoord+self.width/2) - (self.padX+self.padWidth/2));
        } else {
            self.vecXComp += ((self.xCoord+self.width/2) - (self.padX+self.padWidth/2));
        }*/
        self.vecYComp = -self.vecYComp;
    }
}

+ (GameLogic *)GetInstance
{
    @synchronized(self) {
        if (uniqueInstance == nil) {
            uniqueInstance = [[GameLogic alloc] init];
            uniqueInstance.isServer = NO;
            uniqueInstance.xCoord = 5;
            uniqueInstance.yCoord = 5;
            uniqueInstance.width = 15;
            uniqueInstance.height = 15;
            uniqueInstance.vecXComp = 10;
            uniqueInstance.vecYComp = 4;
            uniqueInstance.transitionPointYComp = -1;
            uniqueInstance.goingLeft = NO;
            uniqueInstance.goingUp = NO;
            uniqueInstance.connectedPlayers = [NSMutableArray array];

            //Retrieve screen dimensions properly and set the field values accordingly
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            uniqueInstance.fieldWidth = (int)roundf(screenRect.size.width);
            uniqueInstance.fieldHeight = (int)roundf(screenRect.size.height);
            
            uniqueInstance.padX = uniqueInstance.fieldWidth / 2;
            uniqueInstance.padY = uniqueInstance.fieldWidth - 50;
            uniqueInstance.padWidth = 60;
            uniqueInstance.padHeight = 20;
            
            uniqueInstance.padDrag = 0;
        }
        return uniqueInstance;
    }
}

@end
