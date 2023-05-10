# SwiftyGROQ

A typesafe declarative syntax for making swifty GROQ queries.

## About
GROQ (Graph-Relational Object Queries) is an open source query language created and maintained by [Sanity](https://www.sanity.io). GROQ allows you to filter, sort, paginate and specify which data you want to mention just a subset of its features. You can learn more about GROQ [here](https://www.sanity.io/docs/how-queries-work).

### Supported platforms

This framework is distributed as a Swift Package and supports the following platform versions:  
- iOS 11.0
- macOS 10.13
- tvOS 11.0
- watchOS 4.0

### Motivation

If you use a GROQ enabled database for your Apple platform app, performing queries require you to store the queries as a string in your codebase. This has the following disadvantages:  

- Harder to read and understand the query
- Using variables in the query may require you to use string interpolation
- Queries are stored in plaintext in your app’s binary
- Not validated at compile time
- Has a special syntax you need to learn before using it

SwiftyGROQ attempts to solve many of these considerations by giving you a declarative and typesafe syntax.

In short, a query like this:
```js
*[_type == 'movie' && releaseYear >= 1979 || isFavorite] | order(releaseYear, desc) {
  "id": _id, title, releaseYear 
}[0...10]
```
Can be written like this:
```swift
GROQuery {
    Type("movie")
    "releaseYear" >= 1979 || True(isFavorite)
    Order("releaseYear", .descending)
} fields: {
    Field(renamedTo: "id", SpecialGROQKey.id),
    "title",
    "releaseYear"
}[0..<10]
```

## Installation

To use this package in a SwiftPM project, you need to set it up as a package dependency:

```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      url: "https://github.com/Eskils/SwiftyGROQ.git", 
      .upToNextMinor(from: "1.0.0") // or `.upToNextMajor
    )
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "SwiftyGROQ", package: "SwiftyGROQ")
      ]
    )
  ]
)
```

## Usage

## Roadmap

The most important aspects of building queries can be used id SwiftyGROQ, but some parts have yet to be implemented. 
As an emergency fix, you can use `Custom` to write GROQ as a string:
```swift
// *[@["1"]]
GROQuery() {
    Custom("@[\"1\"]")
}
```

- ✅ Basic filters (!, ==, !=, <, >, <=, >=, in, &&, ||, match)
- ✅ Slice operations [pagination]
- ✅ Ordering
- ✅ Basic Projection
- 🚧 Projection Methods (has: renaming fields, `count`, `coalescing`)
- 🚧 Global functions (has: coalesce, count, lower*)
- 🚧 Data Types (missing: Null, Object, Pair, Range, Path)
- ❌ Special variables (missing: @, ^)
- ❌ Conditionals
- ❌ Joins
- ❌ Object and array traversal
- ❌ Geolocation functions
- ❌ Portable text functions
- ❌ Sanity functions
- ❌ Delta functions
- ❌ Math functions
- ❌ String functions
- ❌ Array functions
- ❌ Query Scoring Pipes