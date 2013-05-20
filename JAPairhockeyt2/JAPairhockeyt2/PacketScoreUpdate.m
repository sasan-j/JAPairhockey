//
//  PacketScoreUpdate.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/20/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "PacketScoreUpdate.h"
#import "NSData+JAPAdditions.h"
#import "Player.h"

@implementation PacketScoreUpdate

@synthesize players = _players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players
{
	return [[[self class] alloc] initWithPlayers:players];
}

- (id)initWithPlayers:(NSMutableDictionary *)players
{
	if ((self = [super initWithType:PacketTypeScoreUpdate]))
	{
		self.players = players;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
	NSMutableDictionary *players = [NSMutableDictionary dictionaryWithCapacity:4];
    
	size_t offset = PACKET_HEADER_SIZE;
	size_t count;
    
	int numberOfPlayers = [data rw_int8AtOffset:offset];
	offset += 1;
    
	for (int t = 0; t < numberOfPlayers; ++t)
	{
		NSString *peerID = [data rw_stringAtOffset:offset bytesRead:&count];
		offset += count;
        
		NSString *name = [data rw_stringAtOffset:offset bytesRead:&count];
		offset += count;
        
		PlayerPosition position = [data rw_int8AtOffset:offset];
		offset += 1;
        
		int score = [data rw_int8AtOffset:offset];
		offset += 1;
        
		Player *player = [[Player alloc] init];
		player.peerID = peerID;
		player.name = name;
		player.position = position;
        player.score = score;
		[players setObject:player forKey:player.peerID];
	}
    
	return [[self class] packetWithPlayers:players];
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendInt8:[self.players count]];
    
	[self.players enumerateKeysAndObjectsUsingBlock:^(id key, Player *player, BOOL *stop)
     {
         [data rw_appendString:player.peerID];
         [data rw_appendString:player.name];
         [data rw_appendInt8:player.position];
         [data rw_appendInt8:player.score];

     }];
}


@end
