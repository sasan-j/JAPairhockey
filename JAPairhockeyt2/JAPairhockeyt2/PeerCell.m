//
//  PeerCell.m
//  JAPairhockeyt2
//
//  Created by Tahereh Pazouki on 5/11/13.
//  Copyright (c) 2013 Tahereh Pazouki. All rights reserved.

#import "PeerCell.h"

@implementation PeerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground"]];
		self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundSelected"]];
        
		self.textLabel.font = [UIFont fontWithName:@"Arial" size:24.0f];
		self.textLabel.textColor = [UIColor colorWithRed:116/255.0f green:192/255.0f blue:97/255.0f alpha:1.0f];
		self.textLabel.highlightedTextColor = self.textLabel.textColor;
	}
	return self;
}

@end
