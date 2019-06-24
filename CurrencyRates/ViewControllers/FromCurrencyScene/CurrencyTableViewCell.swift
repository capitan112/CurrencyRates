//
//  FromCurrencyTableViewCell.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 20/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
  @IBOutlet var currencyImageView: UIImageView!
  @IBOutlet var currencyCodeLabel: UILabel!
  @IBOutlet var currencyDescriptionLabel: UILabel!

  func config(currencyInfo: CurrencyInfo) {
    currencyImageView.image = UIImage(named: currencyInfo.imageName)
    currencyCodeLabel.text = currencyInfo.currencyCode
    currencyDescriptionLabel.text = currencyInfo.description
  }
}
