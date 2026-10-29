import UIKit

// to pass values to ViewController cleanly
protocol CameraScanHandlerDelegate: AnyObject {
    func didCaptureQRCode(urlString: String)
}

class CameraScanHandler: NSObject {
    
    weak var delegate: CameraScanHandlerDelegate?
    private weak var presentingViewController: UIViewController?
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func launchCamera() {
        // UI simulation
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

