//
//  PacketTypeDataPacket.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/19/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "PacketDataPacket.h"
#import "NSData+SnapAdditions.h"
#import "GameData.h"

@implementation PacketDataPacket

@synthesize gameData = _gameData;

+ (id)packetWithGameData:(GameData *)gameData
{
	return [[[self class] alloc] initWithGameData:gameData];
}

- (id)initWithGameData:(GameData *)gameData
{
	if ((self = [super initWithType:PacketTypeDataPacket]))
	{
		self.gameData = gameData;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
	//NSMutableDictionary *packetGameData = [NSMutableDictionary dictionaryWithCapacity:4];
    
    GameData *packetGameData=[[GameData alloc] init];
    
	size_t offset = PACKET_HEADER_SIZE;
	size_t count;
    
	//int numberOfPlayers = [data rw_int8AtOffset:offset];
	//offset += 1;

		NSString *peerID = [data rw_stringAtOffset:offset bytesRead:&count];
		offset += count;
        
        NSInteger vecXComp = [data rw_int16AtOffset:offset];
		offset += count;

        NSInteger vecYComp = [data rw_int16AtOffset:offset];
        offset += count;
    
    
        NSString *ballHorizonOffsetStr = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
    
        NSString *lastHitPeerId = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
    
		packetGameData.peerID = peerID;
    packetGameData.vecXComp = vecXComp;
    packetGameData.vecYComp = vecYComp;
    packetGameData.ballHorizonOffset = [ballHorizonOffsetStr floatValue];
	packetGameData.lastHitPeerID= lastHitPeerId;

	return [[self class] packetWithGameData:packetGameData];
}

- (void)addPayloadToData:(NSMutableData *)data
{
    GameData *gameData = self.gameData;
	//data that we want to send
    //[data rw_appendInt8:[self.gameData count]];
         NSString *ballHorizonOffsetStr = [NSString stringWithFormat:@"%f", gameData.ballHorizonOffset];
         [data rw_appendString:gameData.peerID];
         [data rw_appendInt16:(short)gameData.vecXComp];
         [data rw_appendInt16:(short)gameData.vecYComp];
         [data rw_appendString:ballHorizonOffsetStr];
         [data rw_appendString:gameData.lastHitPeerID];
}
@end
