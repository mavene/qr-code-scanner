//import UIKit
//import QRScanner // Your Carthage framework
//
//// Protocol that acts as the bridge back to the MainViewController
//protocol CameraScanHandlerDelegate: AnyObject {
//    func didCaptureQRCode(urlString: String, date: String, time: String)
//}
//
//class CameraScanHandler: NSObject, QRScannerViewControllerDelegate {
//    
//    weak var delegate: CameraScanHandlerDelegate?
//    private weak var presentingViewController: UIViewController?
//    
//    init(presentingViewController: UIViewController) {
//        self.presentingViewController = presentingViewController
//    }
//    
//    // MainViewController will call this when their scan button is clicked
//    func launchCamera() {
//        let scannerVC = QRScannerViewController()
//        scannerVC.delegate = self
//        presentingViewController?.present(scannerVC, animated: true)
//    }
//    
//    // QRScanner Delegate: Runs automatically when a QR code is read
//    func qrScanner(_ controller: QRScannerViewController, didScanResult result: String) {
//        controller.dismiss(animated: true) { [weak self] in
//            guard let self = self else { return }
//            
//            // Format current date and time
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let dateStr = formatter.string(from: Date())
//            
//            formatter.dateFormat = "h:mm a"
//            let timeStr = formatter.string(from: Date())
//            
//            // Send the scanned data back to the MainViewController safely
//            self.delegate?.didCaptureQRCode(urlString: result, date: dateStr, time: timeStr)
//        }
//    }
//    
//    func qrScanner(_ controller: QRScannerViewController, didFailWithError error: Error) {
//        print("Camera Scan failed: \(error.localizedDescription)")
//        controller.dismiss(animated: true)
//    }
//}
//
