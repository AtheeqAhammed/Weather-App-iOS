//
//  BaseViewController.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 04/06/23.
//

import UIKit
import ProgressHUD
import Alamofire
import SystemConfiguration

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class BaseViewController: UIViewController {
    
    var alertMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            self.showAlertMessage("Internet not connected", title: NSLocalizedString("Alert_Title", comment: ""), ok: NSLocalizedString("OK_Title", comment: ""), cancel: nil)
        case .unavailable: break
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(_ msg: String?, title: String?, ok okTitle: String?, cancel cancelTitle: String?) {
        self.alertMessage = msg ?? ""
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        controller.view.tintColor = UIColor.red
        if cancelTitle != nil {
            let cancel = UIAlertAction(title: cancelTitle, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
                self.cancelButtonClicked()
            })
            controller.addAction(cancel)
        } else {
            // NSLog(@"nil");
        }
        
        if okTitle != nil {
            let ok = UIAlertAction(title: okTitle, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
                self.okButtonClicked()
            })
            controller.addAction(ok)
        } else {
            //  NSLog(@"nil");
        }
        if self.presentedViewController == nil {
            self.present(controller, animated: true) {() -> Void in }
            
        }
    }
    
    func okButtonClicked()  {
        
    }
    
    func cancelButtonClicked()  {
        
    }
    
    func displayAlert(with message:String,title:String,completion:(() -> Void)?) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: completion)
        }
    }
    
    func startAnimation() {
        ProgressHUD.show()
    }
    
    func stopAnimation() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}
