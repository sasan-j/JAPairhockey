//
//  PacketServerReady.h
//  JAPairhockeyt2
//
//  Created by Hossein Arshad on 5/11/13.
//  Copyright (c) 2013 Hossein Arshad. All rights reserved.
//

#import "Packet.h"

@interface PacketServerReady : Packet

@property (nonatomic, strong) NSMutableDictionary *players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players;

@end
