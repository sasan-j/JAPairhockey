//
//  Packet.h
//  Snap
//
//  Created by Ray Wenderlich on 5/25/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

const size_t PACKET_HEADER_SIZE;

typedef enum
{
	PacketTypeSignInRequest = 0x64,    // server to client
	PacketTypeSignInResponse,          // client to server
    
    PacketTypeStartGame,               // server to client
    PacketTypeDataPacket,
    
	PacketTypeServerReady,             // server to client
	PacketTypeClientReady,             // client to server
    
	PacketTypeOtherClientQuit,         // server to client
	PacketTypeServerQuit,              // server to client
	PacketTypeClientQuit,              // client to server
}
PacketType;

@interface Packet : NSObject

@property (nonatomic, assign) PacketType packetType;

+ (id)packetWithType:(PacketType)packetType;
- (id)initWithType:(PacketType)packetType;
+ (id)packetWithData:(NSData *)data;

- (NSData *)data;

@end
