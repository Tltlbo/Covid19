//
//  ViewController.swift
//  Covid19
//
//  Created by 박진성 on 2023/07/28.
//

import UIKit
import DGCharts
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverView(completionHandler: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
                
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }


    func fetchCovidOverView(completionHandler : @escaping (Result<CityCovidOverView, Error>) -> Void) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey" : "" //매일 없애고 커밋하기
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                    
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
    
}

