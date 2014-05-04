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
	dispatch_once(&onceToken, ^
	{
		// Note: It's important that we use the shared cache so
		// that we can clear the cache for testing purposes.
		_regexCache = [RXRegexCache sharedCache];
	});
}

#pragma mark Obtaining Lazily-Compiled, Cached Regexes

- (NSRegularExpression *)rx_regex
{
	return [self rx_regexWithOptions:0];
}

- (NSRegularExpression *)rx_regexWithOptions:(NSRegularExpressionOptions)options
{
	return [_regexCache regexForPattern:self options:options];
}

#pragma mark Checking for Match

- (BOOL)rx_matchesPattern:(NSString *)regexPattern
{
	return [self rx_matchesPattern:regexPattern options:NSRegularExpressionCaseInsensitive];
}

- (BOOL)rx_matchesPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options;
{
	return [self rx_matchesRegex:[regexPattern rx_regexWithOptions:options]];
}

- (BOOL)rx_matchesRegex:(NSRegularExpression *)regex
{
	return ([regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])] > 0);
}

#pragma mark Capture Groups

- (RXMatch *)rx_captureGroup:(NSInteger)group withPattern:(NSString *)regexPattern
{
	return [self rx_captureGroup:group withPattern:regexPattern options:0];
}

- (RXMatch *)rx_captureGroup:(NSInteger)group withPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options
{
	NSArray *matchedGroups = [self rx_matchesWithPattern:regexPattern];
	if (group >= [matchedGroups count]) return nil;
	return [matchedGroups objectAtIndex:group];
}

- (NSArray *)rx_matchesWithPattern:(NSString *)regexPattern
{
	return [self rx_matchesWithPattern:regexPattern options:0];
}

- (NSArray *)rx_matchesWithPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options
{
	NSRegularExpression *regex = [_regexCache regexForPattern:regexPattern options:options];
	
	NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
	
	NSMutableArray *matches = [NSMutableArray array];
	for (NSTextCheckingResult *textCheckingResult in results)
	{
		NSInteger numberOfRanges = [textCheckingResult numberOfRanges];
		
		// The first range is the whole matched string, which we
		// don't care about when extracting capture groups.
		if (numberOfRanges <= 1) continue;
		
		NSMutableArray *captures = [NSMutableArray array];
		for (int rangeIndex = 1; rangeIndex < numberOfRanges; rangeIndex++)
		{
			NSRange range = [textCheckingResult rangeAtIndex:rangeIndex];
			if (range.location == NSNotFound)
			{
				[captures addObject:[RXCapture notFoundCapture]];
				continue;
			}
			
			NSString *text = [self substringWithRange:range];
			RXCapture *capture = [[RXCapture alloc] initWithRange:range text:text];
			
			[captures addObject:capture];
		}
		
		[matches addObject:[[RXMatch alloc] initWithCaptures:[captures copy]]];
	}
	
	return matches;
}

@end