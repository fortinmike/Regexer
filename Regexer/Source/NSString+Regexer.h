//
//  NSString+Regexer.h
//  Regexer
//
//  Created by Michaël Fortin on 2014-05-02.
//  Copyright (c) 2014 Michaël Fortin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMatch.h"
#import "RXCapture.h"

@interface NSString (Regexer)

#pragma mark Obtaining Lazily-Compiled, Cached Regexes

- (NSRegularExpression *)rx_regex;
- (NSRegularExpression *)rx_regexWithOptions:(NSRegularExpressionOptions)options;

#pragma mark Checking for Match

- (BOOL)rx_matchesPattern:(NSString *)regexPattern;
- (BOOL)rx_matchesPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options;
- (BOOL)rx_matchesRegex:(NSRegularExpression *)regex;

#pragma mark Capture Groups

- (RXMatch *)rx_captureGroup:(NSInteger)group withPattern:(NSString *)regexPattern;
- (RXMatch *)rx_captureGroup:(NSInteger)group withPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options;
- (NSArray *)rx_matchesWithPattern:(NSString *)regexPattern;
- (NSArray *)rx_matchesWithPattern:(NSString *)regexPattern options:(NSRegularExpressionOptions)options;

@end