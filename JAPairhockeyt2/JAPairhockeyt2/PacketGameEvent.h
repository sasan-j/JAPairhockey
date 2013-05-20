//
//  PacketGameEvent.h
//  JAPairhockeyt2
//
//  Created by Sasan Jafarnejad on 5/20/13.
//  Copyright (c) 2013 Sasan Jafarnejad. All rights reserved.
//

#import "Packet.h"

@interface PacketGameEvent : Packet

@property (nonatomic, copy) NSString *recPeerID;

+ (id)packetWithRecPeerID:(NSString *)recPeerID;



@end
