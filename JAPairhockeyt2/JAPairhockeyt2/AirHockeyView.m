//
//  AirHockeyView.m
//  JAPairhockeyt2
//
//  Created by JAFARNEJAD Sasan on 5/17/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "AirHockeyView.h"
#import "GameLogic.h"

@implementation AirHockeyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    GameLogic* gameLogic = [GameLogic GetInstance];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGColorRef unitColor = [UIColor blueColor].CGColor;
    
    CGContextSetStrokeColorWithColor(context,
                                     unitColor);
    CGContextSetFillColorWithColor(context,
                                   unitColor);
    
    CGRect rectangle = CGRectMake(gameLogic.xCoord-gameLogic.width/2, gameLogic.yCoord-gameLogic.height/2,gameLogic.width,gameLogic.height);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextFillPath(context);
    
    CGColorRef fieldColor = [UIColor redColor].CGColor;
    
    CGContextSetStrokeColorWithColor(context,
                                     fieldColor);
    CGContextSetLineWidth(context, 3.0);
    
    rectangle = CGRectMake(0, 0,gameLogic.fieldWidth, gameLogic.fieldHeight);
    CGContextAddRect(context, rectangle);
    CGContextStrokeRect(context,rectangle);
    
    CGColorRef padColor = [UIColor greenColor].CGColor;
    
    CGContextSetStrokeColorWithColor(context,
                                     padColor);
    CGContextSetFillColorWithColor(context,
                                   padColor);
    CGContextSetLineWidth(context, 3.0);
    
    rectangle = CGRectMake(gameLogic.padX-gameLogic.padWidth/2, gameLogic.padY-gameLogic.padHeight/2,gameLogic.padWidth, gameLogic.padHeight);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextFillPath(context);
    
    ///// Random stuff
    //    CGContextSetLineWidth(context, 2.0);
    //    CGContextSetStrokeColorWithColor(context, [UIColor
    //                                               blueColor].CGColor);
    //    CGContextMoveToPoint(context, 0, 0);
    //    CGContextAddLineToPoint(context, 300, 400);
    //    CGContextStrokePath(context);
    //
    //    CGContextSetLineWidth(context, 4.0);
    //    CGContextSetStrokeColorWithColor(context,
    //                                     [UIColor blueColor].CGColor);
    //    CGContextMoveToPoint(context, 100, 100);
    //    CGContextAddLineToPoint(context, 150, 150);
    //    CGContextAddLineToPoint(context, 100, 200);
    //    CGContextAddLineToPoint(context, 50, 150);
    //    CGContextAddLineToPoint(context, 100, 100);
    //    CGContextStrokePath(context);
    
}

@end
