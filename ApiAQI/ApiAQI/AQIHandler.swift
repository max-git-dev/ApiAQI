//
//  AQIModel.swift
//  ApiAQI
//
//  Created by 姚佳宏MacMiniM1 on 2022/11/5.
//

import Foundation

 
 

protocol AQIHandlerDelegate{
    func didUpdateAQIData(AQIModels:[AQIModel])
}

class AQIHandler{
    
    
    var delegate:AQIHandlerDelegate?
  
     func fetchData(){
         let apiUrl = "https://data.epa.gov.tw/api/v2/aqx_p_432?api_key=e8dd42e6-9b8b-43f8-991e-b3dee723a52d&limit=1000&sort=ImportDate%20desc&format=JSON"
         self.performRequest(urlString: apiUrl)
    }
    
    func performRequest(urlString:String){
        guard let url = URL(string: urlString) else{return}
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data,response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            guard let safeData = data else {return}
            guard let aqiModels = self.parseJSON(aqiData: safeData) else {return}
            self.delegate?.didUpdateAQIData(AQIModels: aqiModels)
            
        }
        
        task.resume()
    }
    
    func parseJSON(aqiData:Data)->[AQIModel]?{
        var aqiModels:[AQIModel] = []
        let decoder = JSONDecoder()
        do{
            
            let decodeData = try decoder.decode(AQIData.self, from: aqiData)
            guard let records = decodeData.records else{return nil}
            for record in records{
                let sitename = record.sitename
                let aqi = record.aqi
                let aqiObject = AQIModel(SiteName: sitename, AQI: aqi)
                aqiModels.append(aqiObject)
            }
           return aqiModels
             
        }catch{
            print("error:\(error)")
            return nil
        }
    }
}









