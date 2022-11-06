//
//  AQIModel.swift
//  ApiAQI
//
//  Created by 姚佳宏MacMiniM1 on 2022/11/5.
//

import Foundation

 
var resultData:AQIData?

struct AQIHandler{
    
  
     func fetchData(){
         let apiUrl = "https://data.epa.gov.tw/api/v2/aqx_p_432?api_key=e8dd42e6-9b8b-43f8-991e-b3dee723a52d&limit=1000&sort=ImportDate%20desc&format=JSON"
          performRequest(urlString: apiUrl)
    }
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
        
        if let safeData = data{
             let dataString = String(data: safeData, encoding: .utf8) ?? "no data"
             print(dataString)
             parseJSON(aqiData: safeData)
            
             
        }
    }
    
    task.resume()
}

func parseJSON(aqiData:Data){
    let decoder = JSONDecoder()
    do{
        
        resultData = try decoder.decode(AQIData.self, from: aqiData)
         
    }catch{
        print("error:\(error)")
    }
}




