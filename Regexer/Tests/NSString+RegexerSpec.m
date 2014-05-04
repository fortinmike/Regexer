//
//  NSString+RegexerSpec.m
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-02.
//  Copyright 2014 Michaël Fortin. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSString+Regexer.h"
#import "RXRegexCache.h"

SPEC_BEGIN(NSString_RegexerSpec)

describe(@"NSString+Regexer", ^
{
	beforeEach(^
	{
		[[RXRegexCache sharedCache] clear];
	});
	
	context(@"asking for an NSRegularExpression", ^
	{
		it(@"should create an instance given a valid pattern", ^
		{
			NSRegularExpression *regex = [@"[a-zA-Z0-9_]{12}" rx_regex];
			[[regex should] beNonNil];
		});
		
		it(@"should throw given an invalid pattern", ^
		{
			[[theBlock(^{ [@"\\" rx_regex]; }) should] raise];
		});
	});
	
	context(@"caching", ^
	{
		it(@"should return the same regex instance if asked for the same pattern and options multiple times", ^
		{
			NSRegularExpression *regex1 = [@"ABC" rx_regex];
			NSRegularExpression *regex2 = [@"ABC" rx_regex];
			[[theValue(regex1 == regex2) should] beYes];
		});
		
		it(@"should return different regex instances if asked for the same pattern but with different options", ^
		{
			NSRegularExpression *regex1 = [@"ABC" rx_regexWithOptions:NSRegularExpressionIgnoreMetacharacters];
			NSRegularExpression *regex2 = [@"ABC" rx_regexWithOptions:NSRegularExpressionCaseInsensitive];
			[[theValue(regex1 == regex2) should] beNo];
		});
		
		it(@"should return a different regex instance after clearing the cache if asked for the exact same thing", ^
		{
			NSRegularExpression *regex1 = [@"ABC" rx_regex];
			[[RXRegexCache sharedCache] clear];
			NSRegularExpression *regex2 = [@"ABC" rx_regex];
			[[theValue(regex1 == regex2) should] beNo];
		});
	});
	
	context(@"verifying match", ^
	{
		it(@"should perform case sensitive pattern matching", ^
		{
			[[theValue([@"Hello World" rx_matchesPattern:@"^[a-z0-9 ]+?$"]) should] beNo];
		});
		
		it(@"should perform case insensitive pattern matching", ^
		{
			[[theValue([@"Hello World" rx_matchesPattern:@"^[a-z0-9 ]+?$" options:NSRegularExpressionCaseInsensitive]) should] beYes];
		});
	});
	
	context(@"capture groups", ^
	{
		it(@"should return an empty array when the pattern doesn't match anything", ^
		{
			NSArray *matches = [@"What is your quest?" rx_matchesWithPattern:@"\\bknight\\b"];
			[[theValue([matches count]) should] equal:theValue(0)];
		});
		
		it(@"should return appropriate matches and captures when the pattern contains no capturing group", ^
		{
			NSArray *matches = [@"What is your quest?" rx_matchesWithPattern:@"\\b[a-zA-Z]+?\\b"];
			
			[[theValue([matches count]) should] equal:theValue(4)];
			
			[[[matches[0][0] text] should] equal:@"What"];
			[[[matches[1][0] text] should] equal:@"is"];
			[[[matches[2][0] text] should] equal:@"your"];
			[[[matches[3][0] text] should] equal:@"quest"];
		});
		
		it(@"should return appropriate matches and captures when the pattern contains capturing groups", ^
		{
			NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
			
			[[theValue([matches count]) should] equal:theValue(5)];
			
			[[[matches[0][0] text] should] equal:@"To"];
			[[[matches[0][1] text] should] equal:@"T"];
			[[[matches[0][2] text] should] equal:@"o"];
			[[[matches[1][0] text] should] equal:@"seek"];
			[[[matches[1][1] text] should] equal:@"s"];
			[[[matches[1][2] text] should] equal:@"eek"];
			[[[matches[2][0] text] should] equal:@"the"];
			[[[matches[2][1] text] should] equal:@"t"];
			[[[matches[2][2] text] should] equal:@"he"];
			[[[matches[3][0] text] should] equal:@"Holy"];
			[[[matches[3][1] text] should] equal:@"H"];
			[[[matches[3][2] text] should] equal:@"oly"];
			[[[matches[4][0] text] should] equal:@"Grail"];
			[[[matches[4][1] text] should] equal:@"G"];
			[[[matches[4][2] text] should] equal:@"rail"];
		});
		
		it(@"should throw when asked for a capture that doesn't exist in the pattern", ^
		{
			// Note: There is only one capturing group in this regex
			NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b([a-zA-Z])[a-zA-Z]+?\\b"];
			
			[[theBlock(^{ [matches[0][2] text]; }) should] raise];
		});
		
		it(@"matches should expose their text and range", ^
		{
			NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b[a-zA-Z]+?\\b"];
			
			[[[matches[0] text] should] equal:@"To"];
			[[[matches[1] text] should] equal:@"seek"];
		});
		
		it(@"matches' text and range should be the same as that match's first capture ($0)", ^
		{
			NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b[a-zA-Z]+?\\b"];
			
			[[[matches[0] text] should] equal:[matches[0][0] text]];
			[[[matches[1] text] should] equal:[matches[1][0] text]];
		});
		
		it(@"should return the captures for the specified group across matches", ^
		{
			NSArray *captures = [@"To seek the Holy Grail." rx_capturesForGroup:1 withPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
			
			[[[captures[0] text] should] equal:@"T"];
			[[[captures[1] text] should] equal:@"s"];
			[[[captures[2] text] should] equal:@"t"];
			[[[captures[3] text] should] equal:@"H"];
			[[[captures[4] text] should] equal:@"G"];
		});
	});
});

SPEC_END
