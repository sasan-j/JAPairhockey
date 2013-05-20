//
//  Packet.m
//  Snap
//
//  Created by Ray Wenderlich on 5/25/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "Packet.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"
#import "PacketOtherClientQuit.h"
#import "PacketDataPacket.h"
#import "NSData+SnapAdditions.h"


const size_t PACKET_HEADER_SIZE = 10;

@implementation Packet

@synthesize packetType = _packetType;

+ (id)packetWithType:(PacketType)packetType
{
	return [[[self class] alloc] initWithType:packetType];
}

+ (id)packetWithData:(NSData *)data
{
	if ([data length] < PACKET_HEADER_SIZE)
	{
		NSLog(@"Error: Packet too small");
		return nil;
	}
    
	if ([data rw_int32AtOffset:0] != 'JAP!')
	{
		NSLog(@"Error: Packet has invalid header");
		return nil;
	}
    
	int packetNumber = [data rw_int32AtOffset:4];
	PacketType packetType = [data rw_int16AtOffset:8];
    
	Packet *packet;
    
	switch (packetType)
	{
		case PacketTypeSignInRequest:
        case PacketTypeClientReady:
        case PacketTypeStartGame:
        case PacketTypeReceivedGoal:
        case PacketTypeServerQuit:
		case PacketTypeClientQuit:            
			packet = [Packet packetWithType:packetType];
			break;
            
		case PacketTypeSignInResponse:
			packet = [PacketSignInResponse packetWithData:data];
			break;
            
        case PacketTypeDataPacket:
            packet = [PacketDataPacket packetWithData:data];
            break;
            
        case PacketTypeServerReady:
			packet = [PacketServerReady packetWithData:data];
			break;
            
        case PacketTypeOtherClientQuit:
			packet = [PacketOtherClientQuit packetWithData:data];
			break;
            
		default:
			NSLog(@"Error: Packet has invalid type");
			return nil;
	}
    
    //Packet *packet=[Packet packetWithType:PacketTypeSignInRequest];

	return packet;
}

- (id)initWithType:(PacketType)packetType
{
	if ((self = [super init]))
	{
		self.packetType = packetType;
	}
	return self;
}

- (NSData *)data
{
    //NSLog(@"inside data method");
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    //NSLog(@"after data allocation");

	[data rw_appendInt32:'JAP!'];   //
	[data rw_appendInt32:0];
	[data rw_appendInt16:self.packetType];
    //NSLog(@"before calling add payloadToData");

    [self addPayloadToData:data];
    
	return data;
}

- (void)addPayloadToData:(NSMutableData *)data
{
	// base class does nothing
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

@end
