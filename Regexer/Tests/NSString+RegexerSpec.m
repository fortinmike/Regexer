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
	
	context(@"matching", ^
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
	
	context(@"extracting groups", ^
	{
		it(@"should return an empty array when no groups are present in the pattern", ^
		{
			NSArray *groups = [@"What is your quest?" rx_matchedGroupsWithPattern:@"\\b[a-zA-Z]+?\\b"];
			[[theValue([groups count]) should] equal:theValue(0)];
		});
		
		it(@"should return extracted groups when the pattern contains a single group", ^
		{
			NSArray *groups = [@"What is your quest?" rx_matchedGroupsWithPattern:@"\\b([a-zA-Z]+?)\\b"];
			[[theValue([groups count]) should] equal:theValue(4)];
			[[groups[3] should] equal:@"quest"];
		});
		
		it(@"should return extracted groups as a flattened array when the pattern contains multiple groups", ^
		{
			NSArray *groups = [@"What is your quest?" rx_matchedGroupsWithPattern:@"\\b([a-zA-z])([a-zA-Z]+?)\\b"];
			[[theValue([groups count]) should] equal:theValue(8)];
			[[groups[7] should] equal:@"uest"];
		});
		
		it(@"should return the appropriate element when asked for a specific group", ^
		{
			[[[@"What is your quest?" rx_matchedGroup:3 withPattern:@"\\b([a-zA-Z]+?)\\b"] should] equal:@"quest"];
		});
	});
});

SPEC_END
