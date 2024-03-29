//
//  NSData+JAPAdditions.h
//  JAPairhockeyt2
//
//  Created by Tahereh Pazouki on 5/11/13.
//  Copyright (c) 2013 Tahereh Pazouki. All rights reserved.
//

@interface NSData (JAPAdditions)

- (int)rw_int32AtOffset:(size_t)offset;
- (short)rw_int16AtOffset:(size_t)offset;
- (char)rw_int8AtOffset:(size_t)offset;
- (NSString *)rw_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount;

@end

@interface NSMutableData (JAPAdditions)

- (void)rw_appendInt32:(int)value;
- (void)rw_appendInt16:(short)value;
- (void)rw_appendInt8:(char)value;
- (void)rw_appendString:(NSString *)string;

@end
