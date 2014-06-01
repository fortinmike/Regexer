# Regexer

[![Build Status](https://travis-ci.org/fortinmike/Regexer.svg?branch=master)](https://travis-ci.org/fortinmike/Regexer)
[![Coverage Status](https://coveralls.io/repos/fortinmike/Regexer/badge.png?branch=master)](https://coveralls.io/r/fortinmike/Regexer?branch=master)
[![Version](http://cocoapod-badges.herokuapp.com/v/Regexer/badge.png)](http://cocoadocs.org/docsets/Regexer)
[![Platform](http://cocoapod-badges.herokuapp.com/p/Regexer/badge.png)](http://cocoadocs.org/docsets/Regexer)

Your regex helper. Makes working with regular expressions in Objective-C short, sweet and performant.

## Features

- Implemented as a category on NSString which makes for super-clean regex-using code.
- Regexer caches compiled regexes to prevent unnecessary re-compilation for subsequent uses of the same pattern and options. Use regexes without polluting your classes with regex instantitation and caching logic.
- Uses indexed subscripting to provide succinct access to matches and capture groups (optional).
- Regexes are lazily compiled as needed.
- Regexer is thread-safe.

## Basics

You can perform simple match checks super quickly using Regexer:

```objc
BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-zA-Z ]+?!"];
```

If you would rather extract strings than perform a boolean check for matches, you can do that too. When searching for matches using Regexer, you will obtain zero or more `RXMatch` instances. Each `RXMatch` represents a single occurrence of the given pattern. An `RXMatch` exposes its text, range and an array of `RXCapture`s (which are also accessible through indexed subscripting, i.e. square brackets syntax). The first capture in the array is the whole matched pattern ($0) and the following captures correspond to the pattern's capturing groups ($1, $2, ...). Each capture exposes the captured text and its range in the original string.

## Usage

#### Checking for Matches

If you simply want to know whether a given string matches a pattern, you can do it like so:

```objc
BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-zA-Z ]+?!"];
BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-z ]+?!" options:NSRegularExpressionCaseInsensitive];
```
	
#### Extracting Text

You can quickly obtain the strings and ranges of text matched by your pattern:

```objc
NSString *someText = @"What is your quest?";
NSString *pattern = @"\\b[a-zA-Z]+?\\b";

NSArray *texts = [someText rx_textsForMatchesWithPattern:pattern];
NSArray *ranges = [someText rx_rangesForMatchesWithPattern:pattern];
```

If you're interested in both texts and ranges, it is more efficient to benefit from the fact that Regexer also exposes the matched text and range at the `RXMatch` level. This is equivalent to accessing the first capture ($0) in the match, which always corresponds to the whole matched pattern. This is a great way to work with matches if you don't use capturing groups:

```objc
NSArray *matches = [someText rx_matchesWithPattern:pattern];

for (RXMatch *match in matches)
{
	NSLog(@"Text: %@, Range: [location: %d, length: %d]", [match text],
	                                                      [match range].location,
	                                                      [match range].length);
}
```

#### Advanced Text Extraction Using Capturing Groups

The following pattern matches words and captures the first letter of each word using a capturing group, in addition to capturing the whole string matched by the pattern ($0). Using indexed subscripting (the square brackets operator), you can quickly extract any required info:

```objc
NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];

NSString *word1 = [matches[0][0] text]; // @"To" (equivalent to $0 in regex-speak)
NSString *letter1 = [matches[0][1] text]; // @"T" (equivalent to $1 in regex-speak)
NSString *remainder1 = [matches[0][2] text]; // @"o" (equivalent to $2 in regex-speak)
NSRange word1Range = [matches[0][0] range]; // 0..1 (NSRange)
```

You can also iterate over matches and/or captures as required:

```objc
for (RXCapture *capture in [matches[1] captures])
{
	NSLog(@"Text: %@, Range: [location: %d, length: %d]", [capture text],
	                                                      [capture range].location,
	                                                      [capture range].length);
}
```

#### Obtaining a Specific Capturing Group Across All Matches

If you are interested in a single capturing group across all matches of your pattern, you can obtain an array of `RXCapture`s for that group, then extract any required info:

```objc
NSArray *captures = [@"To seek the Holy Grail." rx_capturesForGroup:1 withPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
		
NSString *firstLetter1 [captures[0] text] // @"T"
NSString *firstLetter2 [captures[1] text] // @"s"
NSString *firstLetter3 [captures[2] text] // @"t"
NSString *firstLetter4 [captures[3] text] // @"H"
NSString *firstLetter5 [captures[4] text] // @"G"
```
	
#### Obtaining the Texts for a Capturing Group Across All Matches

... or if you're only interested in the text of those captures, you can ask for it directly:

```objc
NSArray *texts = [@"To seek the Holy Grail." rx_textsForGroup:1 withPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
// texts == @[@"T", @"s", @"t", @"H", @"G"]
```
	
#### Obtaining the Ranges for a Capturing Group Across All Matches

... same goes for ranges:

```objc
NSArray *ranges = [@"To seek the Holy Grail." rx_rangesForGroup:1 withPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];
// ranges == 0..1, 3..6, ... (NSRange's boxed in NSValue instances)
```

#### Working With Matches and Captures Directly

If you prefer being more explicit and avoid indexed subscripting, you can also manipulate `RXMatch` and `RXCapture` instances directly:

```objc
NSArray *matches = [@"To seek the Holy Grail." rx_matchesWithPattern:@"\\b([a-zA-Z])([a-zA-Z]+?)\\b"];

RXMatch *match = [matches firstObject];
RXCapture *capture = [[match captures] objectAtIndex:0]; // Or: match[0]
NSString *text = [capture text];
NSRange range = [capture range];
```

#### Obtaining Cached NSRegularExpression Instances

If you simply want a pre-compiled, cached `NSRegularExpression` instance to perform some more advanced regex operations that may not be covered by Regexer's API, you can obtain one like this:

```objc
NSRegularExpression *regex = [@"[a-zA-Z0-9]{10}" rx_regex];
NSRegularExpression *regexWithOptions = [@"[a-zA-Z0-9]{10}" rx_regexWithOptions:NSRegularExpressionCaseInsensitive];
```

#### Replacements

Performing regex-based replacement using Regexer is easy:

```objc
NSString *altered = [@"What is your quest?" rx_stringByReplacingMatchesOfPattern:@"\\b([a-zA-Z]+?)\\b" withTemplate:@"$1-hello"];
// Result: @"What-hello is-hello your-hello quest-hello?"
```

## Implementation Details

- Regexer indexes cached compiled regexes by their pattern and options, so rest assured that multiple regexes with the same pattern but with different options will not clash.

## Installation

Regexer is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "Regexer"

## Author

Michaël Fortin (fortinmike@irradiated.net)

## License

Regexer is available under the MIT license. See the LICENSE file for more info.

