// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 6.0
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BenchmarkKit",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "BenchmarkKit",
            targets: ["BenchmarkKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/grpc/grpc-swift-2.git",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/grpc/grpc-swift-nio-transport.git",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/grpc/grpc-swift-protobuf.git",
            from: "2.0.0"
        ),
    ],
    targets: [
        .target(
            name: "BenchmarkKit",
            dependencies: [
                .product(name: "GRPCCore", package: "grpc-swift-2"),
                .product(name: "GRPCNIOTransportHTTP2",
                         package: "grpc-swift-nio-transport"),
                .product(name: "GRPCProtobuf",
                         package: "grpc-swift-protobuf"),
            ]
        ),
    ]
)
