//
//  ViewController.swift
//  NotiMe
//
//  Created by Olarn U. on 23/6/2564 BE.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var requestToggle: UISwitch!
    @IBOutlet weak var pushPermissionLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getNotificationSettings),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    @objc func getNotificationSettings() {
        UNUserNotificationCenter
            .current()
            .getNotificationSettings { [weak self] settings in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .authorized {
                        self?.requestToggle.isOn = LocalStore().pushIsEnabled
                    } else {
                        self?.requestToggle.isOn = false
                    }

                    self?.pushPermissionLabel.text = "Push noti Permission: " + settings.authorizationStatus.toString()
                    self?.alertLabel.text = "Alert: \(settings.alertSetting == .enabled ? "Yes" : "No")"
                    self?.soundLabel.text = "Sound: \(settings.soundSetting == .enabled ? "Yes" : "No")"
                    self?.badgeLabel.text = "Badge: \(settings.badgeSetting == .enabled ? "Yes" : "No")"
                }
            }
    }
    
    @IBAction func toggleValueChanged(_ sender: Any) {
        LocalStore().set(pushEnable: requestToggle.isOn)
        if !requestToggle.isOn {
            // call server to set noti OFF
            return
        }
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.sound, .alert, .badge]) { [weak self] granted, _ in
                self?.getNotificationSettings()
                
                if granted {
                    // call server to set noti ON
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Permission Denined",
                            message: "Permission Denined. You can enable in App Settings.",
                            preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Settings", style: .default) { action in
                          
                            // navigate to home
                            // and ...
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                            }
                        })
                        self?.present(alert, animated: true)
                    }
                }
            }
    }
}

extension UNAuthorizationStatus {
    
    func toString() -> String {
        switch self {
        case .authorized:
            return "Permitted"
        case .denied:
            return "Denined"
        case .notDetermined:
            return "Not Determind"
        default:
            return "Unknow"
        }

    }
}

