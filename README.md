# String.re

`String.re` is an opinionated swift Regex Library which employ [NSRegularExpression](https://developer.apple.com/documentation/foundation/nsregularexpression) 
under the hood but with its main goal
enhancing the API friendliness and getting rid of the cumbersomeness usability

if you came from other language like javascript / ruby / kotlin, you'll find it easy to master as they share similar API sets and common concepts

`contains(_ haystack:)` 
 
 return whether `haystack` contains the specified pattern

`find(_ haystack:)` 

return the optional first match result of the specified pattern in `haystack`

`scan(_ haystack:)` 

return all match result of specified pattern in `haystack`

`matchEntire(_ haystack:)` 

return whether given pattern matches the entire string of haystack

`explode(_ haystack:)`
 
 split haystack by given pattern

`substitute(_ haystack:replacement:limitation)` 

replace the first `limitation` occurrences to given replacement

`substitute(_ haystack:limitation:replacement:limitation)`
 
 replace the first `limitation` occurrences to given closure, which will be provided with the match result and occurrences sequence (zero indexed)
the result of the closure will be the replacement for the corresponding occurrence








