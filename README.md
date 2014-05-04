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

If you would rather extract strings than perform a boolean check for matches, you can do that too. When searching for matches using Regexer, you will obtain one or more `RXMatch` instance. Each `RXMatch` represents a single occurrence of the given pattern. An `RXMatch` exposes an array of `RXCapture`s. The first capture in the array is the whole matched pattern ($0) and the following captures correspond to the pattern's capturing groups ($1, $2, ...). Each capture exposes the captured text and its range in the original string.

## Usage

#### Checking For Matches

	BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-zA-Z ]+?!"];
	BOOL match = [@"Hello World!" rx_matchesPattern:@"[a-z ]+?!" options:NSRegularExpressionCaseInsensitive];

#### Extracting Text Using Capturing Groups

	

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

