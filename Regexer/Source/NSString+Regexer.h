//
//  NSString+Regexer.h
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-02.
//  Copyright (c) 2014 Michaël Fortin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regexer)

#pragma mark Obtaining Lazily-Compiled, Cached Regexes

- (NSRegularExpression *)rx_regex;
- (NSRegularExpression *)rx_regexCaseSensitive:(BOOL)caseSensitive;
- (NSRegularExpression *)rx_regexWithOptions:(NSRegularExpressionOptions)options;

#pragma mark Checking for Matches

- (BOOL)rx_matchesPattern:(NSString *)regexPattern;
- (BOOL)rx_matchesPattern:(NSString *)regexPattern caseSensitive:(BOOL)caseSensitive;
- (BOOL)rx_matchesRegex:(NSRegularExpression *)regex;

#pragma mark Groups

- (NSString *)rx_matchedGroup:(NSInteger)group inPattern:(NSString *)regexPattern;
- (NSString *)rx_matchedGroup:(NSInteger)group inPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options;
- (NSArray *)rx_matchedGroupsForPattern:(NSString *)regexPattern;
- (NSArray *)rx_matchedGroupsForPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options;

@end