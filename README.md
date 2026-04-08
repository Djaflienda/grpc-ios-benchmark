# gRPC vs REST iOS Benchmark

Companion code for the article ["gRPC на iOS в 2025: три года в продакшне, две миграции"](https://habr.com/).

## What's inside

- `server/` — Go server running both REST (:8080) and gRPC (:50051) endpoints with identical data
- `ios-benchmark/` — UIKit app measuring latency and payload size across network conditions

## Quick start

### Server
```bash
cd server
go run main.go
```

### iOS app
Open `ios-benchmark/ios-benchmark.xcodeproj` in Xcode, select a simulator, run.

## Requirements

- Go 1.21+
- Xcode 16+, iOS 18+ simulator
- protoc + swift-protobuf + grpc-swift-protobuf (for regenerating proto files)
