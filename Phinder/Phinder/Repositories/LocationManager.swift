//  LocationManager.swift
//  Phinder
//
//  Created by Sebastian Hufeld on 02.06.25.

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let apiKey = APIKeys.openCageApiKey.rawValue
    
    @Published var locationDescription: String = "Standort wird ermittelt..."
    @Published var cityOnly: String = "Unbekannt"
    
    override init() {
        super.init()
        manager.delegate = self
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Bereits erlaubt – starte Standortaktualisierung")
            manager.startUpdatingLocation()
        case .notDetermined:
            print("Zugriff unklar – Anfrage senden")
            manager.requestWhenInUseAuthorization()
        default:
            print("Kein Zugriff – Standort wird nicht gestartet")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization: \(manager.authorizationStatus.rawValue)")
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Zugriff erlaubt")
            manager.startUpdatingLocation()
        case .denied:
            print("Zugriff verweigert")
            locationDescription = "Zugriff verweigert – Ort bitte manuell eingeben"
        case .notDetermined:
            print("Noch keine Entscheidung")
        case .restricted:
            print("Zugriff eingeschränkt")
            locationDescription = "Ortungsdienste eingeschränkt"
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Keine gültige Position erhalten")
            return
        }
        
        print("Standort empfangen: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        fetchLocationName(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fehler beim Standort: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.locationDescription = "Standort nicht verfügbar"
        }
    }
    
    private func fetchLocationName(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        print("Anfrage an OpenCage für Koordinaten: \(latitude), \(longitude)")
        
        let urlString = "https://api.opencagedata.com/geocode/v1/json?q=\(latitude)+\(longitude)&key=\(apiKey)&language=de"
        
        guard let url = URL(string: urlString) else {
            print("Ungültige URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fehler bei der Anfrage: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.locationDescription = "Adresse nicht ermittelbar"
                }
                return
            }
            
            guard let data = data else {
                print("Keine Daten erhalten")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let first = results.first,
                   let components = first["components"] as? [String: Any] {
                    
                    let city = components["city"] as? String ??
                               components["town"] as? String ??
                               components["village"] as? String ?? "Unbekannt"
                    let country = components["country"] as? String ?? ""
                    
                    print("Stadt erkannt: \(city), \(country)")
                    
                    DispatchQueue.main.async {
                        self.cityOnly = city
                        self.locationDescription = "\(city), \(country)"
                    }
                } else {
                    print("Unerwartete JSON-Struktur")
                    DispatchQueue.main.async {
                        self.locationDescription = "Adresse nicht ermittelbar"
                    }
                }
            } catch {
                print("Fehler beim JSON-Parsing: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.locationDescription = "Adresse nicht ermittelbar"
                }
            }
        }.resume()
    }
}
