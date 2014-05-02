# Regexer

[![Version](http://cocoapod-badges.herokuapp.com/v/Regexer/badge.png)](http://cocoadocs.org/docsets/Regexer)
[![Platform](http://cocoapod-badges.herokuapp.com/p/Regexer/badge.png)](http://cocoadocs.org/docsets/Regexer)

Your regex helper. Makes working with regular expressions in Objective-C short, sweet and performant.

## Features

- As you most probably know, there is a non-negligible cost to regex compilation. Regexer keeps compiled regexes around to prevent unnecessary re-compilation for subsequent uses of the same regex.
- Implemented as a category on NSString which makes for super-clean, regex-using code.
- Use regexes without polluting your classes with regex instantitation, compilation and caching logic.
- Regexes are lazily compiled for you, automatically. If you want to precompile them for performance reasons, Regexer enables that, too.

## Usage

#### Some Examples

...

#### Obtaining Cached NSRegularExpression Instances For More Complex Needs

	NSRegularExpression *regex = [@"[a-zA-Z0-9]{10}" rx_regex];
	NSRegularExpression *regexWithOptions = [@"[a-zA-Z0-9]{10}" rx_regexWithOptions:NSMatchingAnchored];
	NSRegularExpression *caseInsensitiveRegex = [@"[a-zA-Z0-9]{10}" rx_caseInsensitiveRegex];
	...

## Implementation Details

- Regexer caches and indexes compiled regexes by a hash of their pattern and options, so multiple regexes using the same pattern with different options will not clash.

## Installation

Regexer is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "Regexer"

## Author

Michaël Fortin (fortinmike@irradiated.net)

## License

Regexer is available under the MIT license. See the LICENSE file for more info.

