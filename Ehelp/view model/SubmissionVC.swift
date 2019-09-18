import UIKit
import MapKit
import CoreLocation
import NaturalLanguage
import UIKit.UIAlertController

class SubmissionVC: UIViewController {
    
    var report: Report!
    
    @IBOutlet weak var message: UITextView!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func gesRec(_ sender: Any) {
        
        if (sender as AnyObject).state == .began {
            let locationInView = (sender as AnyObject).location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            addAnnotation(location: locationOnMap)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add border to the description text view
        self.message.layer.borderColor = UIColor.lightGray.cgColor
        self.message.layer.borderWidth = 1
        
        // keyboard observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.subtitle = "Current Location"
        mapView.addAnnotation(annotation)
        report.addLocation(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        //        annotation.title = "Some Title"
        //        annotation.subtitle = "Some Subtitle"
        self.mapView.addAnnotation(annotation)
        
        report.addLocation(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude)
    }
    

    

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        // add date, message, location to the repor array
        
        report.date = "23-2-2020"
        
        // check if description length is less than 10 or greater than 160
        // if so, then alert user to meet the specified length
        if message.text.count < 10 || message.text.count > 160 {
            
            let alertController:UIAlertController = UIAlertController(title: "Error", message: "Make sure you description is more than 10 characters and less than 160 characters", preferredStyle: UIAlertController.Style.alert)
            
            let alertAction:UIAlertAction = UIAlertAction(title: "Message", style: UIAlertAction.Style.default, handler:nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else {
            
            // language detection
            let detectedLang = languageDetection(for: message.text)
            
            // Add message after validation
            report.addMessage(msg: message.text)

            Global.shared.reports.append(report)
        }
        
        
        // show message if criteria are met
        let alertController:UIAlertController = UIAlertController(title: "Message", message: "Report has been filed successfully", preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(title: "Back", style: .cancel, handler:
        { action in
            //switch tab bar
            //            let vc: UITabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            //            vc.selectedIndex = 1
            //            self.present(vc, animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        } )
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func languageDetection(for string: String) -> String? {
        let recog = NLLanguageRecognizer()
        recog.processString(string)
        guard let languageCode = recog.dominantLanguage?.rawValue else { return nil }
        let detectedLangauge = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLangauge
    }
    
}


extension SubmissionVC: CLLocationManagerDelegate,MKMapViewDelegate {
    
}
