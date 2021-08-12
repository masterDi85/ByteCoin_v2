
import Foundation

protocol CoinManagerDelegate{
    func didUpdatePrice(price: String, currency: String, coin: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "E5BDBCCF-6C8C-4BF1-BEAB-0731FD9FE601"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let coinArray = ["BTC","BTG","ETH","DOGE","ARK","BNB","DGB","DOT","LTC","SOL","ATOM","BAT","DGD","ANT","CVC","DAI","AMA","COTI","ELF","ALGO"]
    
    func getCoinPrice(for currency: String, for coin: String){
        
        let urlString = "\(baseURL)/\(coin)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            
        //2.Create a URL session
        let session = URLSession(configuration: .default)
            
        //3.Give the session task
        let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency, coin: coin)
                    }
                }
        }
            //4. Start the tsk
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
