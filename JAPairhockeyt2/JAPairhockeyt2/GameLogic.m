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
@synthesize isGamePause;
@synthesize isGameReady;



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
    [self computeReflectionVectorForCirclePad];
    
    if (self.xCoord+self.width > self.fieldWidth || self.xCoord < 0) self.vecXComp = -self.vecXComp;
    if (self.yCoord+self.height > self.fieldHeight || self.yCoord < 0) self.vecYComp = -self.vecYComp;
    
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
            self.vecXComp = 2;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle > 90 && incidentAngle <= 120)
        {
            self.vecXComp = -2;
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
            self.vecXComp = 2;
            self.vecYComp = -self.vecYComp;
        } else if (incidentAngle < -90 && incidentAngle >= -120)
        {
            self.vecXComp = -2;
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

+ (GameLogic *)GetInstance
{
    @synchronized(self) {
        if (uniqueInstance == nil) {
            uniqueInstance = [[GameLogic alloc] init];
            uniqueInstance.isServer = NO;
            //uniqueInstance.isGamePause = NO;
            uniqueInstance.isGamePause = YES;
            uniqueInstance.isGameReady = NO;
            uniqueInstance.xCoord = 5;
            uniqueInstance.yCoord = 5;
            uniqueInstance.width = 20;
            uniqueInstance.height = 20;
            uniqueInstance.vecXComp = 10;
            uniqueInstance.vecYComp = 4;
            uniqueInstance.transitionPointYComp = -1;
            uniqueInstance.goingLeft = NO;
            uniqueInstance.goingUp = NO;
            uniqueInstance.dragStarted = NO;
            uniqueInstance.connectedPlayers = [NSMutableArray array];
            uniqueInstance.fieldWidthRatio = 0.8;

            //Retrieve screen dimensions properly and set the field values accordingly
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            uniqueInstance.fieldWidth = (int)roundf(screenRect.size.width)*uniqueInstance.fieldWidthRatio;
            uniqueInstance.fieldHeight = (int)roundf(screenRect.size.height);
            
            uniqueInstance.padX = uniqueInstance.fieldWidth / 2;
            uniqueInstance.padY = uniqueInstance.fieldWidth - 50;
            uniqueInstance.padWidth = 60;
            uniqueInstance.padHeight = 60;
            
            uniqueInstance.padDrag = 0;
        }
        return uniqueInstance;
    }
}

@end
