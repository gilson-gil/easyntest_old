//
//  InvestmentViewModel.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

struct InvestmentViewModel {
  let investmentHeaderViewModel: InvestmentHeaderViewModel
  let investmentDescriptionViewModel: InvestmentDescriptionViewModel
  let investmentGraphViewModel: InvestmentGraphViewModel
  let investmentRiskGradeViewModel: InvestmentRiskGradeViewModel
  let investmentMoreInfoViewModel: InvestmentMoreInfoViewModel
  let investmentInfoViewModels: [InvestmentInfoViewModel]
  let sendViewModel: HomeCellViewModel
  let configurators: [CellConfiguratorType]
  
  init?() {
    guard let jsonPath = Bundle.main.path(forResource: "fund", ofType: "json") else {
      return nil
    }
    let url = URL(fileURLWithPath: jsonPath)
    guard let jsonData = try? Data(contentsOf: url), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any], let json = jsonObject?["screen"] as? [String: Any] else {
      return nil
    }
    let headerViewModel = InvestmentHeaderViewModel(title: json["title"] as? String ?? "", content: json["fundName"] as? String ?? "")
    let description = (json["whatIs"] as? String ?? "") + "\n" + (json["definition"] as? String ?? "")
    let descriptionViewModel = InvestmentDescriptionViewModel(text: description)
    let graph = json["graph"] as? [String: Any] ?? [:]
    let graphViewModel = InvestmentGraphViewModel(cdi: graph["CDI"] as? [Float] ?? [], fund: graph["fund"] as? [Float] ?? [], x: graph["x"] as? [String] ?? [])
    let riskGradeViewModel = InvestmentRiskGradeViewModel(riskTitle: json["riskTitle"] as? String ?? "", risk: json["risk"] as? Int ?? 0)
    let moreInfo = json["moreInfo"] as? [String: Any] ?? [:]
    let monthInfo = moreInfo["month"] as? [String: Float] ?? [:]
    let monthFund = String(monthInfo["fund"] ?? 0)
    let monthCDI = String(monthInfo["CDI"] ?? 0)
    let yearInfo = moreInfo["year"] as? [String: Float] ?? [:]
    let yearFund = String(yearInfo["fund"] ?? 0)
    let yearCDI = String(yearInfo["CDI"] ?? 0)
    let twelveInfo = moreInfo["twelve"] as? [String: Float] ?? [:]
    let twelveFund = String(twelveInfo["fund"] ?? 0)
    let twelveCDI = String(twelveInfo["CDI"] ?? 0)
    let moreInfoViewModel = InvestmentMoreInfoViewModel(title: json["infoTitle"] as? String ?? "", monthFund: monthFund, monthCDI: monthCDI, yearFund: yearFund, yearCDI: yearCDI, twelveFund: twelveFund, twelveCDI: twelveCDI)
    var infoViewModels: [InvestmentInfoViewModel] = []
    (json["info"] as? [[String: Any]])?.forEach {
      let viewModel = InvestmentInfoViewModel(title: $0["name"] as? String ?? "", content: $0["data"] as? String)
      infoViewModels.append(viewModel)
    }
    (json["downInfo"] as? [[String: Any]])?.forEach {
      let viewModel = InvestmentInfoViewModel(title: $0["name"] as? String ?? "", content: $0["data"] as? String)
      infoViewModels.append(viewModel)
    }
    self.investmentHeaderViewModel = headerViewModel
    self.investmentDescriptionViewModel = descriptionViewModel
    self.investmentGraphViewModel = graphViewModel
    self.investmentRiskGradeViewModel = riskGradeViewModel
    self.investmentMoreInfoViewModel = moreInfoViewModel
    self.investmentInfoViewModels = infoViewModels
    self.sendViewModel = HomeCellViewModel(cell: Cell(json: ["message": "Investir"]))
    var configurators: [CellConfiguratorType] = []
    configurators.append(CellConfigurator<InvestmentTitleCell>(viewModel: headerViewModel))
    configurators.append(CellConfigurator<InvestmentDescriptionCell>(viewModel: descriptionViewModel))
    configurators.append(CellConfigurator<InvestmentGraphCell>(viewModel: graphViewModel))
    configurators.append(CellConfigurator<InvestmentRiskCell>(viewModel: riskGradeViewModel))
    configurators.append(CellConfigurator<InvestmentMoreInfoCell>(viewModel: moreInfoViewModel))
    infoViewModels.forEach {
      configurators.append(CellConfigurator<InvestmentInfoCell>(viewModel: $0))
    }
    configurators.append(CellConfigurator<SendCell>(viewModel: self.sendViewModel))
    self.configurators = configurators
  }
}
