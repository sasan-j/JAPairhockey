//
//  PacketTypeDataPacket.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/19/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "PacketDataPacket.h"
#import "NSData+JAPAdditions.h"
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

        NSString *vecXComp = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
    
        NSString *vecYComp = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
    
        NSString *ballHorizonOffsetStr = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
    
        NSString *lastHitPeerId = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
    
		packetGameData.peerID = peerID;
    packetGameData.vecXComp = [vecXComp integerValue];
    packetGameData.vecYComp = [vecYComp integerValue];
    packetGameData.ballHorizonOffset = [ballHorizonOffsetStr floatValue];
	packetGameData.lastHitPeerID= lastHitPeerId;

	return [[self class] packetWithGameData:packetGameData];
}

- (void)addPayloadToData:(NSMutableData *)data
{
    //NSLog(@"inside addPayload method of GameData packet");

    GameData *gameData = self.gameData;
    //NSLog(@"%@",gameData);
	//data that we want to send
    //[data rw_appendInt8:[self.gameData count]];
        NSString *vecXCompStr = [NSString stringWithFormat:@"%d", gameData.vecXComp];
        NSString *vecYCompStr = [NSString stringWithFormat:@"%d", gameData.vecYComp];
         NSString *ballHorizonOffsetStr = [NSString stringWithFormat:@"%f", gameData.ballHorizonOffset];
         [data rw_appendString:gameData.peerID];
         [data rw_appendString:vecXCompStr];
         [data rw_appendString:vecYCompStr];
         [data rw_appendString:ballHorizonOffsetStr];
         [data rw_appendString:gameData.lastHitPeerID];
}
@end
