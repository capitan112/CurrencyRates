//
//  CurrencyPairCell.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 17/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

class CurrencyPairCell: UITableViewCell {
  @IBOutlet var fromRateLabel: UILabel!
  @IBOutlet var fromCurrencyDescriptionLabel: UILabel!
  @IBOutlet var toRateLabel: UILabel!
  @IBOutlet var toCurrencyDescriptionLabel: UILabel!

  func config(currencyPair: (from: CurrencyInfo, to: CurrencyInfo)) {
    fromRateLabel.text = "1 " + currencyPair.from.currencyCode
    fromCurrencyDescriptionLabel.text = currencyPair.from.description
    toCurrencyDescriptionLabel.text = currencyPair.to.shortDescription + "・" + currencyPair.to.currencyCode
    toRateLabel.text = ""
  }

  func update(rate: Double) {
    performUIUpdatesOnMain {
      let attributedRate = self.attributedString(from: String(format: "%.4f", rate))
      self.toRateLabel.attributedText = attributedRate
    }
  }

  fileprivate func attributedString(from string: String) -> NSAttributedString {
    let bigFontAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont(name: "Roboto-Medium", size: 20)!,
    ]
    let smallFontAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont(name: "Roboto-Medium", size: 14)!,
    ]
    let attributedString = NSMutableAttributedString(string: string)
    attributedString.addAttributes(bigFontAttributes, range: NSRange(location: 0, length: string.count))
    let smallCharRange = NSRange(location: string.count - 2, length: 2)
    attributedString.addAttributes(smallFontAttributes, range: smallCharRange)

    return attributedString
  }
}
