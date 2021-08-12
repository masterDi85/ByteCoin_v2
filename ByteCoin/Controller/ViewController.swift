
import UIKit

let defaults = UserDefaults.standard

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    
    var coinManager = CoinManager()
    
    var selectedCurrency = "USD"
    var selectedCoin = "BTC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        selectedCurrency = defaults.string(forKey: "Currency")!
        selectedCoin = defaults.string(forKey: "Coin")!
        coinManager.getCoinPrice(for: selectedCurrency, for: selectedCoin)
    }
}

//MARK: - Coin Manager Delegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String, coin: String) {
        
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
            self.coinLabel.text = coin
            self.errorMessage.text = ""
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
        
        DispatchQueue.main.async {
            self.errorMessage.text = "\(error.localizedDescription)"

        }
        
    }
}


//MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return coinManager.currencyArray.count
        } else {
            return coinManager.coinArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return coinManager.currencyArray[row]
        } else {
            return coinManager.coinArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedCurrency = coinManager.currencyArray[row]
        } else {
            selectedCoin = coinManager.coinArray[row]
        }
        coinManager.getCoinPrice(for: selectedCurrency, for: selectedCoin)
        
        defaults.set(selectedCurrency, forKey: "Currency")
        defaults.set(selectedCoin, forKey: "Coin")
    }
}

