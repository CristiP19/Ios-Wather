import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var inputCity: UITextField!
    @IBOutlet var getWeatherButton: UIButton!

    let apiKey = "30c902fbd8e53e3e8fcbb6fa7c3a9a5a"

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherButton.addTarget(self, action: #selector(didTapGetWeatherButton), for: .touchUpInside)
    }

    @objc func didTapGetWeatherButton() {
        guard let city = inputCity.text, !city.isEmpty else {
            showAlert(message: "Introdu un oras valid")
            return
        }

        let apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"

        if let url = URL(string: apiUrl) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.showAlert(message: "Cerere esuata. Verifica conexiunea la internet sau incearca din nou mai tarziu.")
                    print("Error: \(error)")
                    return
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                        if let main = json?["main"] as? [String: Any], let temperature = main["temp"] as? Double {
                            DispatchQueue.main.async {
                                self.cityLabel.text = city
                                self.weatherLabel.text = "\(String(format: "%.1f", temperature - 273.15))°C"
                            }
                        }
                    } catch {
                        self.showAlert(message: "Eroare la preluarea datelor. Incearca din nou mai tarziu.")
                        print("Error parsing JSON: \(error)")
                    }
                }
            }

            task.resume()
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Eroare", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
