//
//  ViewController.swift
//  MLWeather
//
//  Created by Saul on 04/06/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=34.0194704&lon=-118.4912273&appid=d4277b87ee5c71a468ec0c3dc311a724"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8))
        }.resume()
    }
    
}

