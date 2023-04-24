//
//  MainViewController.swift
//  Weather
//
//  Created by Ilya on 21.04.2023.
//

import UIKit

class MainViewController: UIViewController, MainViewModelDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var conditions: UILabel!
    @IBOutlet weak var longDescriptions: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    var viewModel: MainViewModel = .init()

    override func viewDidLoad() {

        super.viewDidLoad()

        city.text = ""
        temp.text = ""
        conditions.text = ""
        longDescriptions.text = ""

        viewModel.delegate = self
        viewModel.viewLoaded()
    }

    // MARK: - MainViewModelDelegate

    func didReceiveWeather(_ weather: MainViewModel.Weather) {

        city.text = weather.address
        temp.text = "\(weather.tempC)°"
        conditions.text = weather.shortDescription
        longDescriptions.text = weather.longDescription
        iconImageView.image = UIImage(systemName: weather.icon.rawValue)
    }

} // MainViewController

extension MainViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        viewModel.searchWeather(forCity: searchBar.text)
    }
}
