//
//  PacketGameEvent.m
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/20/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "PacketGameEvent.h"
#import "NSData+SnapAdditions.h"


@implementation PacketGameEvent



@synthesize recPeerID = _recPeerID;

+ (id)packetWithData:(NSData *)data
{
	size_t count;
	NSString *recPeerID = [data rw_stringAtOffset:PACKET_HEADER_SIZE bytesRead:&count];
	return [[self class] packetWithRecPeerID:recPeerID];
}

+ (id)packetWithRecPeerID:(NSString *)recPeerID
{
	return [[[self class] alloc] initWithPeerID:recPeerID];
}

- (id)initWithPeerID:(NSString *)recPeerID
{
	if ((self = [super initWithType:PacketTypeGameEvent]))
	{
		self.recPeerID = recPeerID;
	}
	return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.recPeerID];
}


@end
