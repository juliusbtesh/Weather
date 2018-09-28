//
//  WeatherDetailViewController.swift
//  weather
//
//  Created by Julius Btesh on 9/27/18.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var weatherData: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient-background")!)
        
        setupPage()
    }
    
    @IBAction func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupPage() {
        if weatherData == nil {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM d"
        
        dateLabel.text = String(describing: formatter.string(from: weatherData.time!))
//        dateLabel.text = DateFormatter.localizedString(from: weatherData.time!, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
        
        highTemperatureLabel.text = String(describing: weatherData.temperatureHigh) + "°"
        lowTemperatureLabel.text = String(describing: weatherData.temperatureLow) + "°"
        
        summaryLabel.text = weatherData.summary
        
        setupDetailLabelView(tag: 21,
                             title: "Sunrise",
                             description: DateFormatter.localizedString(from: weatherData.sunriseTime!, dateStyle: .none, timeStyle: .short))
        setupDetailLabelView(tag: 22,
                             title: "Sunset",
                             description: DateFormatter.localizedString(from: weatherData.sunsetTime!, dateStyle: .none, timeStyle: .short))
        
        setupDetailLabelView(tag: 23, title: "Chance Of Rain", description: String(describing: weatherData.precipProbability * 100) + "%" )
        setupDetailLabelView(tag: 24, title: "Humidity", description: String(describing: weatherData.humidity * 100) + "%")
        
        setupDetailLabelView(tag: 25, title: "Wind", description: String(describing: weatherData.windSpeed) + " mph")
        setupDetailLabelView(tag: 26, title: "Feels Like", description: String(describing: weatherData.apparentTemperature) + "°")
        
        setupDetailLabelView(tag: 27, title: "Precipitation", description: String(describing: weatherData.precipIntensity))
        setupDetailLabelView(tag: 28, title: "Pressure", description: String(describing: weatherData.pressure))
        
        setupDetailLabelView(tag: 29, title: "Visbility", description: String(describing: weatherData.visibility))
        setupDetailLabelView(tag: 30, title: "UV Index", description: String(describing: weatherData.uvIndex))
    }
    
    func setupDetailLabelView(tag: Int, title: String, description: String) {
        if let detailView = view.viewWithTag(tag) as? DetailLabelView {
            detailView.titleLabel.text = title
            detailView.descriptionLabel.text = description
        }
    }
}
