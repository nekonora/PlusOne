// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        //Define any tools you want available from your build phases
        //Here's an example with SwiftFormat
        .package(url: "https://github.com/mac-cain13/R.swift", from: "5.4.0"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)