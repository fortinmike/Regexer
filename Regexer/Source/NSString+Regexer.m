//
//  NSString+Regexer.m
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-02.
//  Copyright (c) 2014 Michaël Fortin. All rights reserved.
//

#import "NSString+Regexer.h"
#import "RXRegexCache.h"

@implementation NSString (Regexer)

static RXRegexCache *_regexCache;

#pragma mark Lifetime

+ (void)load
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ _regexCache = [[RXRegexCache alloc] init]; });
}

#pragma mark Obtaining Lazily-Compiled, Cached Regexes

- (NSRegularExpression *)rx_regex
{
	return [self rx_regexWithOptions:0];
}

- (NSRegularExpression *)rx_regexCaseSensitive:(BOOL)caseSensitive
{
	return [self rx_regexWithOptions:NSRegularExpressionCaseInsensitive];
}

- (NSRegularExpression *)rx_regexWithOptions:(NSRegularExpressionOptions)options
{
	return [_regexCache regexForPattern:self options:options];
}

#pragma mark Checking for Matches

- (BOOL)rx_matchesPattern:(NSString *)regexPattern
{
	return [self rx_matchesPattern:regexPattern caseSensitive:YES];
}

- (BOOL)rx_matchesPattern:(NSString *)regexPattern caseSensitive:(BOOL)caseSensitive
{
	return [self rx_matchesRegex:[regexPattern rx_regexWithOptions:(caseSensitive ? 0 : NSRegularExpressionCaseInsensitive)]];
}

- (BOOL)rx_matchesRegex:(NSRegularExpression *)regex
{
	return ([regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])] > 0);
}

#pragma mark Groups

- (NSString *)rx_matchedGroup:(NSInteger)group inPattern:(NSString *)regexPattern
{
	return [self rx_matchedGroup:group inPattern:regexPattern options:0];
}

- (NSString *)rx_matchedGroup:(NSInteger)group inPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options
{
	NSArray *matchedGroups = [self rx_matchedGroupsForPattern:regexPattern];
	if (group >= [matchedGroups count]) return nil;
	return [matchedGroups objectAtIndex:group];
}

- (NSArray *)rx_matchedGroupsForPattern:(NSString *)regexPattern
{
	return [self rx_matchedGroupsForPattern:regexPattern options:0];
}

- (NSArray *)rx_matchedGroupsForPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options
{
	NSRegularExpression *regex = [_regexCache regexForPattern:regexPattern options:options];
	
	NSArray *textCheckingResults = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
	
	NSMutableArray *strings = [NSMutableArray array];
	for (NSTextCheckingResult *result in textCheckingResults)
	{
		NSInteger numberOfRanges = [result numberOfRanges];
		
		if (numberOfRanges <= 1) return nil; // The first range is the whole string
		
		for (int rangeIndex = 1; rangeIndex < numberOfRanges; rangeIndex++)
		{
			NSRange range = [result rangeAtIndex:rangeIndex];
			if (range.location == NSNotFound) continue;
			
			NSString *group = [self substringWithRange:range];
			[strings addObject:group];
		}
	}
	
	return strings;
}

@end