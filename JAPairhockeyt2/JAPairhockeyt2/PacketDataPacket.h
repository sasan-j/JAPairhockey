//
//  PacketTypeDataPacket.h
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/19/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "Packet.h"
#import "GameData.h"

@interface PacketDataPacket : Packet

@property (nonatomic, strong) GameData *gameData;

+ (id)packetWithData:(GameData *)gameData;

@end


