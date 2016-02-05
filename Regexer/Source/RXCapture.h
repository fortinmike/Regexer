//
//  RXCapture.h
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-03.
//  Copyright (c) 2014 Michaël Fortin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXCapture : NSObject

@property (readonly) BOOL found;
@property (readonly) NSRange range;
@property (readonly) NSString *text;

+ (instancetype)notFoundCapture;

- (instancetype)initWithRange:(NSRange)range text:(NSString *)text /*NS_DESIGNATED_INITIALIZER*/;

@end