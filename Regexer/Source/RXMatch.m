//
//  RXMatch.m
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-03.
//  Copyright (c) 2014 Michaël Fortin. All rights reserved.
//

#import "RXMatch.h"
#import "NSString+Regexer.h"

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

#pragma mark Templating

- (NSString *)stringByApplyingTemplate:(NSString *)templateString
{
	NSMutableString *altered = [templateString mutableCopy];
	
	while (YES)
	{
		RXMatch *match = [altered rx_firstMatchWithPattern:@"\\$(\\d)"];
		if (!match) break;
		
		NSUInteger groupNumber = [[match[1] text] integerValue];
		
		if (groupNumber >= [_captures count])
		{
			NSString *reason = [NSString stringWithFormat:@"There is no capture for group $%d in this match", groupNumber];
			@throw [NSException exceptionWithName:@"Invalid Operation" reason:reason userInfo:nil];
		}
		
		NSString *captureText = [_captures[groupNumber] text];
		[altered replaceCharactersInRange:match.range withString:captureText];
	}
	
	return altered;
}

#pragma mark Accessor Overrides

- (NSString *)text
{
	return [[_captures firstObject] text];
}

- (NSRange)range
{
	return [[_captures firstObject] range];
}

#pragma mark Subscripting Support

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
	if (index >= [_captures count])
	{
		NSString *reason = [NSString stringWithFormat:@"There is no capture group with index %lu", (unsigned long)index];
		@throw [NSException exceptionWithName:@"Invalid Operation" reason:reason userInfo:nil];
	}
	
	return _captures[index];
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