//
//  NSData+Base64.h
//  ICM
//
//  Created by adoplh.sun on 2018/5/12.
//  Copyright © 2018年 app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;  

@end
