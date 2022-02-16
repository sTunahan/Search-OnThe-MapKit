
import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var mapkitView: MKMapView!
    
    let request = MKLocalSearch.Request() // variable where we get our search result
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = self
        mapkitView.delegate = self
        
        //area to search
        let location = CLLocationCoordinate2D(latitude: 41.0370014, longitude: 28.9763369)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // ZOOM
        
        let area = MKCoordinateRegion(center: location, span: span) // we determined our region
        
        mapkitView.setRegion(area, animated: true) // show on mapview
        
        
        // We specify the area to search
        request.region = mapkitView.region
       
    }
}


extension ViewController:UISearchBarDelegate,MKMapViewDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true) //To close the keyboard when the search icon is pressed
        
        request.naturalLanguageQuery = searchBar.text! // assigning the entered input to the request
        
        
        
        
        //Condition created for clearing the screen every time a call is made
        if mapkitView.annotations.count > 0 {
            mapkitView.removeAnnotations(mapkitView.annotations) // delete all existing pins
        }
    
        let search = MKLocalSearch(request: request)
        
        
        //starting the call
        search.start(completionHandler: {(response,error) in
        
            if error != nil {
                print("error")
            }else if response!.mapItems.count == 0{
                print("no place")
            }else {
                for place  in response!.mapItems{
                    // We use it for precautionary purposes (if let) in case users do not enter the necessary information
                    if let name = place.name,let phone = place.phoneNumber{
                       
                        print("name: \(name)")
                        print("phone: \(phone)")
                        print("latitude: \(place.placemark.coordinate.latitude)")
                        print("longitude: \(place.placemark.coordinate.longitude)")
                        
                      // for pins
                        
                        let pin = MKPointAnnotation()
                        pin.coordinate = place.placemark.coordinate
                        pin.title = name
                        pin.subtitle = phone
                        
                        // for mapkitview
                        self.mapkitView.addAnnotation(pin)
                    }
                }
            }
            
        
        
        })
    }
    
}
