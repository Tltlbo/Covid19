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
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        self.fetchCovidOverView(completionHandler: { [weak self] result in
            guard let self = self else {return}
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverView: result.korea)
                let covidOverViewList = self.makeCovidOverviewList(cityCovidOverView: result)
                self.configureChart(covidOverViewList: covidOverViewList)
                
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    func makeCovidOverviewList(cityCovidOverView : CityCovidOverView) -> [CovidOverView] {
        return [
            cityCovidOverView.seoul,
            cityCovidOverView.busan,
            cityCovidOverView.daegu,
            cityCovidOverView.incheon,
            cityCovidOverView.gwangju,
            cityCovidOverView.daejeon,
            cityCovidOverView.ulsan,
            cityCovidOverView.sejong,
            cityCovidOverView.gyeonggi,
            cityCovidOverView.chungbuk,
            cityCovidOverView.chungnam,
            cityCovidOverView.gyeongbuk,
            cityCovidOverView.gyeongnam,
            cityCovidOverView.gyeongnam,
            cityCovidOverView.jeju,
        ]
    }
    
    func configureChart(covidOverViewList : [CovidOverView]) {
        self.pieChartView.delegate = self
        let entries = covidOverViewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else {return nil}
            return PieChartDataEntry(value: self.removeFormatString(string: overview.newCase), label: overview.countryName, data: overview)
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.joyful() + ChartColorTemplates.liberty() + ChartColorTemplates.pastel() + ChartColorTemplates.material()
        
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(string : String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(koreaCovidOverView : CovidOverView) {
        self.totalCaseLabel.text = "\(koreaCovidOverView.totalCase) 명"
        self.newCaseLabel.text = "\(koreaCovidOverView.newCase) 명"
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

extension ViewController : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else {return}
        guard let covidOverview = entry.data as? CovidOverView else {return}
        covidDetailViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}

