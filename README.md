# Regexer

[![Version](http://cocoapod-badges.herokuapp.com/v/Regexer/badge.png)](http://cocoadocs.org/docsets/Regexer)
[![Platform](http://cocoapod-badges.herokuapp.com/p/Regexer/badge.png)](http://cocoadocs.org/docsets/Regexer)

Your **regex** help**er**. Makes working with regular expressions in Objective-C short, sweet and performant.

## Features

- Implemented as a category on NSString which makes for super-clean regex-using code.
- Regexer caches compiled regexes to prevent unnecessary re-compilation for subsequent uses of the same pattern and options. Use regexes without polluting your classes with regex instantitation and caching logic.
- Uses indexed subscripting to provide succinct access to matches and capture groups (optional).
- Regexes are lazily compiled as needed.
- Regexer is thread-safe.

## Basics

You can perform simple match checks super quickly using Regexer:

	BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-zA-Z ]+?!"];

If you would rather extract strings than perform a boolean check for matches, you can do that too. When searching for matches using Regexer, you will obtain zero or more `RXMatch` instances. Each `RXMatch` represents a single occurrence of the given pattern. An `RXMatch` exposes an array of `RXCapture`s (which is also accessible through indexed subscripting). The first capture in the array is the whole matched pattern ($0) and the following captures correspond to the pattern's capturing groups ($1, $2, ...). Each capture exposes the captured text and its range in the original string.

## Usage

#### Checking for Matches

	BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-zA-Z ]+?!"];
	BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-z ]+?!" options:NSRegularExpressionCaseInsensitive];

#### Extracting Text

The following pattern matches words and captures the first letter of each word using a capturing group, in addition to capturing the whole string matched by the pattern ($0).

	NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
	
	NSString *word1 = [matches[0][0] text]; // @"To" (equivalent to $0 in regex-speak)
	NSString *letter1 = [matches[0][1] text]; // @"T" (equivalent to $1 in regex-speak)
	NSString *remainder1 = [matches[0][2] text]; // @"o" (equivalent to $2 in regex-speak)
	NSRange word1Range = [matches[0][0] range]; // 0..1 (NSRange)
	
	NSString *word2 = [matches[1][0] text]; // @"seek"
	NSString *letter2 = [matches[1][1] text]; // @"s"
	NSString *remainder2 = [matches[1][2] text]; // "eek"
	NSRange word2Range = [matches[0][0] range]; // 3..6 (NSRange)

#### If You're Interested in a Specific Capturing Group Across All Matches

	NSArray *captures = [@"To seek the Holy Grail." rx_capturesForGroup:1 withPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
			
	NSString *firstLetter1 [captures[0] text] // @"T"
	NSString *firstLetter2 [captures[1] text] // @"s"
	NSString *firstLetter3 [captures[2] text] // @"t"
	NSString *firstLetter4 [captures[3] text] // @"H"
	NSString *firstLetter5 [captures[4] text] // @"G"

#### Working With Matches and Captures Directly

	NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
	
	RXMatch *match = [matches firstObject];
	RXCapture *capture = [[match captures] objectAtIndex:0]; // Or: match[0]
	NSString *text = [capture text];
	NSRange range = [capture range];

#### Obtaining Cached NSRegularExpression Instances

If you simply want a pre-compiled, cached `NSRegularExpression` instance to perform some more advanced regex operations that may not be covered by Regexer's API, you can obtain one like this:

	NSRegularExpression *regex = [@"[a-zA-Z0-9]{10}" rx_regex];
	NSRegularExpression *regexWithOptions = [@"[a-zA-Z0-9]{10}" rx_regexWithOptions:NSRegularExpressionCaseInsensitive];

## Implementation Details

- Regexer caches and indexes compiled regexes by their pattern and options, so multiple regexes using the same pattern with different options will not clash.

## Installation

Regexer is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "Regexer"

## Author

Michaël Fortin (fortinmike@irradiated.net)

## License

Regexer is available under the MIT license. See the LICENSE file for more info.

