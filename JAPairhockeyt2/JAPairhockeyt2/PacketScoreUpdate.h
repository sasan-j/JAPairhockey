//
//  PacketScoreUpdate.h
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/20/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "Packet.h"

@interface PacketScoreUpdate : Packet

@property (nonatomic, strong) NSMutableDictionary *players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players;


@end
