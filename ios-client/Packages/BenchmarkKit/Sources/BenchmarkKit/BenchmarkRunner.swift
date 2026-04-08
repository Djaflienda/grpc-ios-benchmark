//
//  File.swift
//  BenchmarkKit
//
//  Created by Igor Tumanov on 08.04.2026.
//

import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2

public struct BenchmarkResult: Sendable {
    public let latencies: [Double]
    public let payloadSizes: [Int]

    public var p50: Double { percentile(50) }
    public var p95: Double { percentile(95) }
    public var p99: Double { percentile(99) }
    public var avgPayloadKB: Double {
        Double(payloadSizes.reduce(0, +)) / Double(payloadSizes.count) / 1024
    }

    private func percentile(_ p: Int) -> Double {
        let sorted = latencies.sorted()
        let idx = max(0, Int(Double(sorted.count) * Double(p) / 100) - 1)
        return sorted[min(idx, sorted.count - 1)]
    }
}

public final class BenchmarkRunner: Sendable {

    private let clock = ContinuousClock()
    private let restURL: URL
    private let grpcHost: String
    private let grpcPort: Int

    public init(
        restURL: URL = URL(string: "http://127.0.0.1:8080/products")!,
        grpcHost: String = "127.0.0.1",
        grpcPort: Int = 50051
    ) {
        self.restURL = restURL
        self.grpcHost = grpcHost
        self.grpcPort = grpcPort
    }

    private func toMilliseconds(_ duration: Duration) -> Double {
        Double(duration.components.seconds) * 1000
        + Double(duration.components.attoseconds) / 1_000_000_000_000_000
    }

    public func measureREST(iterations: Int) async throws -> BenchmarkResult {
        var latencies: [Double] = []
        var sizes: [Int] = []

        for _ in 0..<50 {
            _ = try await URLSession.shared.data(from: restURL)
        }

        for _ in 0..<iterations {
            let start = clock.now
            let (data, _) = try await URLSession.shared.data(from: restURL)
            latencies.append(toMilliseconds(start.duration(to: clock.now)))
            sizes.append(data.count)
        }
        return BenchmarkResult(latencies: latencies, payloadSizes: sizes)
    }

    public func measureGRPC(iterations: Int) async throws -> BenchmarkResult {
        var latencies: [Double] = []
        var sizes: [Int] = []

        try await withGRPCClient(
            transport: .http2NIOPosix(
                target: .ipv4(address: grpcHost, port: grpcPort),
                transportSecurity: .plaintext
            )
        ) { grpcClient in
            let client = PBProductService.Client(wrapping: grpcClient)
            let request = PBProductRequest.with { $0.limit = 50 }

            for _ in 0..<50 {
                _ = try await client.getProducts(request)
            }

            for _ in 0..<iterations {
                let start = self.clock.now
                let response = try await client.getProducts(request)
                latencies.append(
                    self.toMilliseconds(start.duration(to: self.clock.now))
                )
                sizes.append(try response.serializedData().count)
            }
        }
        return BenchmarkResult(latencies: latencies, payloadSizes: sizes)
    }
}
