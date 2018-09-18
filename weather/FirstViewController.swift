//
//  FirstViewController.swift
//  weather
//
//  Created by Julius Btesh on 9/18/18.
//

import UIKit
import WXKDarkSky
import CoreLocation
import CoreData
import Cards

class FirstViewController: UIViewController {
    
    //@IBOutlet weak
    var collectionView: UICollectionView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configure(collectionView: collectionView)
        
//        let card = CardPlayer(frame: CGRect(x: 40, y: 50, width: 300 , height: 360))
//        card.textColor = UIColor.black
//        card.videoSource = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        card.shouldDisplayPlayer(from: self)    //Required.
//
//        card.playerCover = UIImage(named: "gradient-background")!  // Shows while the player is loading
//        card.playImage = UIImage(named: "app-icon")!  // Play button icon
//
//        card.isAutoplayEnabled = true
//        card.shouldRestartVideoWhenPlaybackEnds = true
//
//        card.title = "Big Buck Bunny"
//        card.subtitle = "Inside the extraordinary world of Buck Bunny"
//        card.category = "today's movie"

//        view.addSubview(card)
        
//        let icons: [UIImage] = [
//
//            UIImage(named: "gradient-background")!,
//            UIImage(named: "monument-valley")!,
//            UIImage(named: "gradient-background")!,
//            UIImage(named: "monument-valley")!,
//            UIImage(named: "gradient-background")!,
//            UIImage(named: "monument-valley")!
//
//        ]   // Data source for CardGroupSliding
//
//        let card = CardGroupSliding(frame: CGRect(x: 40, y: 50, width: 300 , height: 360))
//        card.textColor = UIColor.black
//
//        card.icons = icons
//        card.iconsSize = 60
//        card.iconsRadius = 30
//
//        card.title = "from the editors"
//        card.subtitle = "Welcome to XI Cards !"
//
//        view.addSubview(card)
        
//        let card = CardHighlight(frame: CGRect(x: 10, y: 30, width: 200 , height: 240))
//
//        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
//        card.icon = UIImage(named: "app-icon")
//        card.title = "Welcome \nto \nCards !"
//        card.itemTitle = "Flappy Bird"
//        card.itemSubtitle = "Flap That !"
//        card.textColor = UIColor.white
//
//        card.hasParallax = true
        
//        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
//        card.shouldPresent(cardContentVC, from: self, fullscreen: false)
//        
//        view.addSubview(card)
        
        deleteAllWeatherObjects()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    func deleteAllWeatherObjects() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print (result.count)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                try context.save()
            }
            
        } catch {
            print("Failed")
        }
    }
    
    func loadWeather() {
        let appDelegate: AppDelegate
        if Thread.current.isMainThread {
            appDelegate = UIApplication.shared.delegate as! AppDelegate
        } else {
            appDelegate = DispatchQueue.main.sync {
                return UIApplication.shared.delegate as! AppDelegate
            }
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print (result.count)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "temperature") as! Double)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func saveWeather(response: WXKDarkSkyResponse) {
        let appDelegate: AppDelegate
        if Thread.current.isMainThread {
            appDelegate = UIApplication.shared.delegate as! AppDelegate
        } else {
            appDelegate = DispatchQueue.main.sync {
                return UIApplication.shared.delegate as! AppDelegate
            }
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
        let newWeather = NSManagedObject(entity: entity!, insertInto: context)
        
        if let currently = response.currently {
            if let temperature = currently.temperature {
                print("Current temperature: " + String(describing: temperature))
                newWeather.setValue(temperature, forKey: "temperature")
            }
            let time = currently.time
            print("Current time: " + String(describing: DateFormatter.localizedString(from: time, dateStyle: DateFormatter.Style.full, timeStyle: DateFormatter.Style.full)))
            
            newWeather.setValue(time, forKey: "date")
            
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func getWeather() {
        if let lastLocation = self.locationManager.location {
            let request = WXKDarkSkyRequest(key: "56caa52a89fd9f85d47aa90beed6d80b")
            let point = WXKDarkSkyRequest.Point(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            
            let options = WXKDarkSkyRequest.Options(exclude: [.minutely, .alerts], extendHourly: true, language: .english, units: .auto)
            
            request.loadData(point: point, time: Date.init(), options: options) { (response, error) in
                if let response = response {
                    // Successful request. Sample to get the current temperature...
                    self.saveWeather(response: response)
                    self.loadWeather()
                } else if let error = error {
                    // Encountered an error, handle it here...
                    print(error)
                }
            }
            //        request.loadData(point: point) { (data, error) in
            //            if let error = error {
            //                // Handle errors here...
            //                print(error)
            //            } else if let data = data {
            //                // Handle the received data here...
            //                print(data)
            //            }
            //        }
        }
        else {
            print("No location was available")
        }
    }
}

extension FirstViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("\(lat),\(long)")
//            lookUpCurrentLocation { geoLoc in
//                print(geoLoc?.locality ?? "unknown Geo location")
//            }
            getWeather()

        } else {
            print("No coordinates")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
