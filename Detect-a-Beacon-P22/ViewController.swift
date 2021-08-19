//
//  ViewController.swift
//  Detect-a-Beacon-P22
//
//  Created by Łukasz Nycz on 19/08/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconUUID: UILabel!
    @IBOutlet var circle: UIView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circle.backgroundColor = .blue
        circle.layer.cornerRadius = 128
        circle.isHidden = false
        circle.alpha = 0.8
        circle.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                    
                }
            }
        }
    }
    func startScanning() {
        let uuidString = "NO BEACON"
        guard let uuid = UUID(uuidString: uuidString) else {return}
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
        switch uuidString {
        case "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5":
            guard UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") != nil else {return}
            self.beaconUUID.text = uuidString
        case "5A4BCFCE-174E-4BAC-A814-11111111111":
            guard UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-11111111111") != nil else {return}
            beaconUUID.text = uuidString
        case "5A4BCFCE-174E-4BAC-A814-2222222222":
            guard UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-11111111111") != nil else {return}
            beaconUUID.text = uuidString
        default:
            break
        }
        
    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.circle.backgroundColor = .blue
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.circle.backgroundColor = .orange
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.circle.backgroundColor = .red
                self.alert()
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.circle.backgroundColor = .gray
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    func alert() {
        let ac = UIAlertController(title: "Your beacon Found!", message: "Beacon is right here!", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }
}

