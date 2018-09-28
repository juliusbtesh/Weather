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
import SnapKit

class FirstViewController: UIViewController {
    
    var currentCityLabel: UILabel!
    var currentSummaryLabel: UILabel!
    var currentTemperatureLabel: UILabel!
    
    var collectionView: UICollectionView!
    
    let allWeatherData = NSMutableArray()
    var currentWeatherData: Weather?
    var currentLocality: String?
    
    let locationManager = CLLocationManager()
    let myActivityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient-background")!)
        
        setupActivityIndicator()
        setupCurrentViews()
        
        setupCollectionView()
        configure(collectionView: collectionView)
        
        myActivityIndicator.startAnimating()
        
//        deleteAllWeatherObjects()
        
        loadWeather()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
    }
    
    func setupActivityIndicator() {
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
    }
    
    func reloadPage() {
        myActivityIndicator.stopAnimating()
        
        setCurrentViewValues {
            self.collectionView.perform(#selector(UICollectionView.reloadData), with: nil, afterDelay: 0.75)
            
//            let appDelegate: AppDelegate
//            if Thread.current.isMainThread {
//                appDelegate = UIApplication.shared.delegate as! AppDelegate
//            } else {
//                appDelegate = DispatchQueue.main.sync {
//                    return UIApplication.shared.delegate as! AppDelegate
//                }
//            }
//
//            let context = appDelegate.persistentContainer.viewContext
//
//            self.currentWeatherData?.temperature = 30
////            let moc = self.currentWeatherData! as NSManagedObject
////            moc.setValue(30, forKey: "temperature")
//
//            do {
//                try context.save()
//                print("Saved")
//            } catch {
//                print("Failed saving")
//            }
        }
    }
    
    func setupCurrentViews() {
        let refreshBtn = UIButton(frame: .zero)
        refreshBtn.setImage(UIImage(named: "refresh"), for: .normal)
        refreshBtn.addTarget(self, action: #selector(FirstViewController.refreshWeather), for: .touchUpInside)
        
        view.addSubview(refreshBtn)
        
        refreshBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(32)
            make.top.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
        }
        
        currentCityLabel = UILabel(frame: CGRect.zero)
        currentCityLabel.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        currentCityLabel.textColor = UIColor.white
        
        view.addSubview(currentCityLabel)
        
        currentSummaryLabel = UILabel(frame: CGRect.zero)
        currentSummaryLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        currentSummaryLabel.textColor = UIColor.white
        
        view.addSubview(currentSummaryLabel)
        
        currentTemperatureLabel = UILabel(frame: CGRect.zero)
        currentTemperatureLabel.font = UIFont.systemFont(ofSize: 100, weight: .thin)
        currentTemperatureLabel.textColor = UIColor.white
        
        view.addSubview(currentTemperatureLabel)
        
        currentCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(64)
        }
        
        currentSummaryLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(currentCityLabel)
            make.top.equalTo(currentCityLabel.snp_bottomMargin).offset(10)
        }
        
        currentTemperatureLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(currentCityLabel)
            make.top.equalTo(currentSummaryLabel.snp_bottomMargin).offset(20)
        }
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        layout.itemSize = CGSize(width: 60, height: 60)
        //layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(currentTemperatureLabel.snp_bottomMargin).offset(20)
            make.left.right.bottom.equalTo(view.safeAreaInsets)
        }
    }
    
    func setCurrentViewValues(completionHandler: @escaping () -> Void) {
        if let data = currentWeatherData {
            let location = CLLocation(latitude: data.latitude, longitude: data.longitude)
            lookUpCurrentLocation(location: location) { (place) in
                self.currentLocality = place?.locality
                self.currentCityLabel.text = self.currentLocality
                self.currentSummaryLabel.text = data.subSummary
                self.currentTemperatureLabel.text = String(describing: data.temperature) + "°"
                
                completionHandler()
            }
        }
    }
    
    func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
                // An error occurred during geocoding.
                print(error)
                completionHandler(nil)
            }
        })
//        if let lastLocation = self.locationManager.location {
//            // Use the last reported location.
//            let geocoder = CLGeocoder()
//
//            // Look up the location and pass it to the completion handler
//            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
//                if error == nil {
//                    let firstLocation = placemarks?[0]
//                    completionHandler(firstLocation)
//                }
//                else {
//                    // An error occurred during geocoding.
//                    completionHandler(nil)
//                }
//            })
//        }
//        else {
//            // No location was available.
//            completionHandler(nil)
//        }
    }
    
    func deleteAllWeatherObjects() {
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
        
        var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        comp.timeZone = TimeZone(abbreviation: "UTC")!
        let beginning = Calendar.current.date(from: comp)!
        
        request.predicate = NSPredicate(format: "(time >= %@)", beginning as CVarArg)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print ("Found ", result.count, " to delete")
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
        let sort = NSSortDescriptor(key: #keyPath(Weather.time), ascending: true)
        request.sortDescriptors = [sort]
        
        var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        comp.timeZone = TimeZone(abbreviation: "UTC")!
        let beginning = Calendar.current.date(from: comp)!
        
        request.predicate = NSPredicate(format: "(time >= %@)", beginning as CVarArg)
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print ("Found ", result.count, " results")
            for data in result as! [NSManagedObject] {
                let weather = data as! Weather
                if Calendar.current.isDateInToday(weather.time!) {
                    currentWeatherData = weather
                }
                
                allWeatherData.add(weather)
                //print(data.value(forKey: "temperature") as! Double)
            }
            
            if allWeatherData.count > 0 {
                if Thread.current.isMainThread {
                    reloadPage()
                } else {
                    DispatchQueue.main.sync {
                        reloadPage()
                    }
                }
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
        
        if allWeatherData.count > 0 {
            for moc in allWeatherData {
                context.delete(moc as! NSManagedObject)
            }
            allWeatherData.removeAllObjects()
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
        
        if let daily = response.daily {
            let data = daily.data
            for d in data  {
                let newWeather = NSManagedObject(entity: entity!, insertInto: context)
                setupWeather(object: newWeather, dataBlock: d, latitude: response.latitude, longitude: response.longitude)
                
                if Calendar.current.isDateInToday(d.time) {
                    if let currently = response.currently {
                        newWeather.setValue(currently.temperature, forKey: "temperature")
                        newWeather.setValue(currently.summary, forKey: "subSummary")
                        newWeather.setValue(currently.apparentTemperature, forKey: "apparentTemperature")
                        currentWeatherData = newWeather as? Weather
                    }
                }
                
                allWeatherData.add(newWeather as! Weather)
            }
        }
        
        do {
            try context.save()
            print("Saved")
            
            DispatchQueue.main.sync {
                reloadPage()
            }
        } catch {
            print("Failed saving")
        }
    }
    
    @objc func refreshWeather() {
        locationManager.requestLocation()
    }
    
    func getWeather() {
        if allWeatherData.count == 0 {
           myActivityIndicator.startAnimating()
        }
        if let lastLocation = self.locationManager.location {
            let request = WXKDarkSkyRequest(key: "56caa52a89fd9f85d47aa90beed6d80b")
            let point = WXKDarkSkyRequest.Point(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            
            let options = WXKDarkSkyRequest.Options(exclude: [.minutely, .alerts], extendHourly: true, language: .english, units: .auto)
            
            request.loadData(point: point, time: nil, options: options) { (response, error) in
                if let response = response {
                    // Successful request. Sample to get the current temperature...
                    self.deleteAllWeatherObjects()
                    self.saveWeather(response: response)
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
    
//    func getWeatherForDay(date: Date?, completionHandler: @escaping (Bool) -> Void) {
//        if let lastLocation = self.locationManager.location {
//            let request = WXKDarkSkyRequest(key: "56caa52a89fd9f85d47aa90beed6d80b")
//            let point = WXKDarkSkyRequest.Point(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
//
//            let options = WXKDarkSkyRequest.Options(exclude: [.minutely, .alerts], extendHourly: true, language: .english, units: .auto)
//
//            request.loadData(point: point, time: date, options: options) { (response, error) in
//                if let response = response {
//                    // Successful request. Sample to get the current temperature...
//                    self.saveWeather(response: response)
//                    self.loadWeather()
//                } else if let error = error {
//                    // Encountered an error, handle it here...
//                    print(error)
//                }
//            }
//        }
//        else {
//            print("No location was available")
//        }
//    }
    
    func setupWeather(object: NSManagedObject, dataBlock: WXKDarkSkyDataPoint, latitude: Double, longitude: Double) {
        object.setValue(latitude, forKey: "latitude")
        object.setValue(longitude, forKey: "longitude")
        
        object.setValue(dataBlock.time, forKey: "time")
//        object.setValue(dataBlock.temperature, forKey: "temperature")
        object.setValue(dataBlock.summary, forKey: "summary")
        object.setValue(dataBlock.icon, forKey: "icon")
        object.setValue(dataBlock.sunriseTime, forKey: "sunriseTime")
        object.setValue(dataBlock.sunsetTime, forKey: "sunsetTime")
        
        object.setValue(dataBlock.temperatureHigh, forKey: "temperatureHigh")
        object.setValue(dataBlock.temperatureLow, forKey: "temperatureLow")
        object.setValue(dataBlock.temperatureHighTime, forKey: "temperatureHighTime")
        object.setValue(dataBlock.temperatureLowTime, forKey: "temperatureLowTime")
        
        object.setValue(dataBlock.dewPoint, forKey: "dewPoint")
        object.setValue(dataBlock.humidity, forKey: "humidity")
        object.setValue(dataBlock.windSpeed, forKey: "windSpeed")
        object.setValue(dataBlock.windGust, forKey: "windGust")
        object.setValue(dataBlock.windGustTime, forKey: "windGustTime")
        object.setValue(dataBlock.windBearing, forKey: "windBearing")
        object.setValue(dataBlock.pressure, forKey: "pressure")
        
        object.setValue(dataBlock.apparentTemperatureHigh, forKey: "apparentTemperature")
        object.setValue(dataBlock.precipIntensity, forKey: "precipIntensity")
        object.setValue(dataBlock.precipProbability, forKey: "precipProbability")
        object.setValue(dataBlock.uvIndex, forKey: "uvIndex")
        object.setValue(dataBlock.visibility, forKey: "visibility")
        
    }
}

extension FirstViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("\(lat),\(long)")
            self.getWeather()
        } else {
            print("No coordinates")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.authorizedWhenInUse:
            locationManager.requestLocation()
            break
        case .denied:
            break
        case .restricted:
            break
        case .notDetermined:
            break
        case .authorizedAlways:
            locationManager.requestLocation()
        }
    }
}
