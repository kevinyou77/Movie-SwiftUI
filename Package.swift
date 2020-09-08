// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DicodingMovieFirst",
    dependencies: [

    ],
    targets: [
        .target(
            name: "DicodingMovieFirst",
            dependencies: []),
        .testTarget(
            name: "DicodingMovieFirstTests",
            dependencies: ["DicodingMovieFirst"])
    ]
)
