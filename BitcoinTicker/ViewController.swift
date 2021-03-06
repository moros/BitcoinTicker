import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        fetchBitcoinInfo(url: baseURL + currencyArray[0], index: 0)
    }

    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        fetchBitcoinInfo(url: baseURL + currencyArray[row], index: row)
    }
    
    func fetchBitcoinInfo(url: String, index: Int)
    {
        Alamofire.request(url, method: .get).responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                self.bitcoinPriceLabel.text = self.formatDoubleInCurrency(json["last"].double!, index)
            } else {
                self.bitcoinPriceLabel.text = "Issues getting response."
            }
        })
    }
    
    func formatDoubleInCurrency(_ last: Double, _ index: Int) -> String
    {
        let currencies = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
        return "\(currencies[index]) \(last)"
    }
}

