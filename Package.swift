// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "LinaTeX",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "LinaTeX",
            targets: ["LinaTeX"]
        )
    ],
    targets: [
        .target(
            name: "LinaTeX",
            path: "."
        )
    ]
)
