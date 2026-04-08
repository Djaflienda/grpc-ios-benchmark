//
//  ViewController.swift
//  ios-client
//
//  Created by Igor Tumanov on 08.04.2026.
//

import UIKit
import BenchmarkKit

final class ViewController: UIViewController {

    // MARK: - UI

    private lazy var runButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Run Benchmark"
        config.baseBackgroundColor = .systemBlue
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(runBenchmark), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var resultsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.text = "Press Run to start benchmark"
        return label
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    // MARK: - Properties

    private let runner = BenchmarkRunner()
    private let iterations = 300

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "gRPC vs REST Benchmark"
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    // MARK: - Layout

    private func setupLayout() {
        scrollView.addSubview(resultsLabel)
        view.addSubview(scrollView)
        view.addSubview(runButton)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            runButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            runButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(
                equalTo: runButton.bottomAnchor, constant: 16),

            scrollView.topAnchor.constraint(
                equalTo: activityIndicator.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            resultsLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            resultsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            resultsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            resultsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            resultsLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func runBenchmark() {
        runButton.isEnabled = false
        activityIndicator.startAnimating()
        resultsLabel.text = "Running benchmark...\n(50 warmup + \(iterations) iterations each)"

        Task {
            do {
                let restResult = try await runner.measureREST(iterations: iterations)
                await updateLabel("✅ REST done, running gRPC...")

                let grpcResult = try await runner.measureGRPC(iterations: iterations)
                await showResults(rest: restResult, grpc: grpcResult)
            } catch {
                await showError(error)
            }
        }
    }

    // MARK: - Results

    @MainActor
    private func updateLabel(_ text: String) {
        resultsLabel.text = text
    }

    @MainActor
    private func showResults(rest: BenchmarkResult, grpc: BenchmarkResult) {
        runButton.isEnabled = true
        activityIndicator.stopAnimating()

        let output = """
        ━━━━━━━━━━━━━━━━━━━━━━━━━━
        PAYLOAD SIZE
        ━━━━━━━━━━━━━━━━━━━━━━━━━━
        REST:  \(String(format: "%.1f", rest.avgPayloadKB)) KB
        gRPC:  \(String(format: "%.1f", grpc.avgPayloadKB)) KB
        Ratio: \(String(format: "%.1fx", rest.avgPayloadKB / grpc.avgPayloadKB)) smaller
        
        ━━━━━━━━━━━━━━━━━━━━━━━━━━
        LATENCY — REST (ms)
        ━━━━━━━━━━━━━━━━━━━━━━━━━━
        p50:  \(String(format: "%.1f", rest.p50))
        p95:  \(String(format: "%.1f", rest.p95))
        p99:  \(String(format: "%.1f", rest.p99))
        
        ━━━━━━━━━━━━━━━━━━━━━━━━━━
        LATENCY — gRPC (ms)
        ━━━━━━━━━━━━━━━━━━━━━━━━━━
        p50:  \(String(format: "%.1f", grpc.p50))
        p95:  \(String(format: "%.1f", grpc.p95))
        p99:  \(String(format: "%.1f", grpc.p99))
        """

        resultsLabel.text = output
    }

    @MainActor
    private func showError(_ error: Error) {
        runButton.isEnabled = true
        activityIndicator.stopAnimating()
        resultsLabel.text = "❌ Error: \(error.localizedDescription)\n\nMake sure the server is running:\ncd server && go run ."
    }
}
