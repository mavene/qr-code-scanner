import UIKit
import AVFoundation
import QRScanner

// To pass values to ViewController cleanly
protocol CameraScanHandlerDelegate: AnyObject {
    func didCaptureQRCode(urlString: String)
}

// @MainActor is required because the framework's views and protocols are pinned to the main thread
@MainActor
class CameraScanHandler: NSObject, QRScannerViewDelegate {
    
    weak var delegate: CameraScanHandlerDelegate?
    private weak var presentingViewController: UIViewController?
    
    // Set to true for simulator mock testing, or false for live production camera scanning
    private let isMockMode = false
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func launchCamera() {
        if isMockMode {
            launchMockScanner()
        } else {
            launchProductionScanner()
        }
    }
    
    // MARK: - Production Camera Implementation
    private func launchProductionScanner() {
        guard let presenter = presentingViewController else { return }
        
        // Build a fresh, blank view controller container to host the camera canvas view
        let containerVC = UIViewController()
        containerVC.view.backgroundColor = .black
        
        // Instantiate the official QRScannerView matching the dimensions of the screen layout
        let qrScannerView = QRScannerView(frame: presenter.view.bounds)
        qrScannerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Configure using the exact framework input initialization rules you extracted
        qrScannerView.configure(delegate: self, input: QRScannerView.Input(isBlurEffectEnabled: true))
        
        containerVC.view.addSubview(qrScannerView)
        
        // Present the camera shell sheet
        presenter.present(containerVC, animated: true) {
            // Start the hardware camera session right after presentation animation completes
            qrScannerView.startRunning()
        }
    }
    
    // MARK: - Official QRScannerViewDelegate Implementations
    
    // Matches the exact successful camera capture signature contract (Must be public)
    public func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        qrScannerView.stopRunning()
        
        presentingViewController?.dismiss(animated: true) { [weak self] in
            // Safely push the raw text value back over the delegate layout bridge to MainViewController
            self?.delegate?.didCaptureQRCode(urlString: code)
        }
    }
    
    // Matches the exact signature contract for handling camera failures (Must be public)
    public func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print("Camera Scan layout error details: \(error)")
        qrScannerView.stopRunning()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Required protocol hook to satisfy the framework system fully (Must be public)
    public func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        // Left blank or print hook for flashlight status adjustments if needed later
    }
    
    // MARK: - Mock Simulator Implementation
    private func launchMockScanner() {
        let alert = UIAlertController(
            title: "[Mock Camera Scanner]",
            message: "Simulating QR code capture via Carthage package setup.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Scan Google", style: .default, handler: { [weak self] _ in
            self?.delegate?.didCaptureQRCode(urlString: "https://google.com")
        }))
        
        alert.addAction(UIAlertAction(title: "Scan Apple", style: .default, handler: { [weak self] _ in
            self?.delegate?.didCaptureQRCode(urlString: "https://apple.com")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        presentingViewController?.present(alert, animated: true)
    }
}

