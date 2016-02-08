//
//  RXMatch.h
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-03.
//  Copyright (c) 2014 Michaël Fortin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXMatch : NSObject

@property (readonly) NSArray *captures;
@property (readonly) NSString *text;
@property (readonly) NSRange range;

#pragma mark Lifetime

- (instancetype)initWithCaptures:(NSArray *)captures /*NS_DESIGNATED_INITIALIZER*/;

#pragma mark Templating

- (NSString *)stringByApplyingTemplate:(NSString *)templateString;

#pragma mark Subscripting Support

- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end