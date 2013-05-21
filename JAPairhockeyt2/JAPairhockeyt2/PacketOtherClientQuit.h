//
//  PacketOtherClientQuit.h
//  JAPairhockeyt2
//
//  Created by Hossein Arshad on 5/11/13.
//  Copyright (c) 2013 Hossein Arshad. All rights reserved.
//

#import "Packet.h"

@interface PacketOtherClientQuit : Packet

@property (nonatomic, copy) NSString *peerID;

+ (id)packetWithPeerID:(NSString *)peerID;

@end
