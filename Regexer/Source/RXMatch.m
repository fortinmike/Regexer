//
//  RXMatch.m
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-03.
//  Copyright (c) 2014 Michaël Fortin. All rights reserved.
//

#import "RXMatch.h"

@implementation RXMatch

#pragma mark Lifetime

- (id)initWithCaptures:(NSArray *)captures
{
	self = [super init];
	if (self)
	{
		_captures = captures ?: [NSArray array];
	}
	return self;
}

#pragma mark NSObject Overrides

- (NSString *)description
{
	return [_captures description];
}

#pragma mark Debugging

- (id)debugQuickLookObject
{
	return [self description];
}

@end