//
//  TripListViewController.swift
//  panpan
//
//  Created by Dorian Delorme on 21/12/2017.
//  Copyright © 2017 Dorian Delorme. All rights reserved.
//

import UIKit
import SwiftyJSON
import KeychainSwift

class TripListViewController: UIViewController {
    
    var data: Any?
    
    var tripList = [Trip]()
    
    let keychain = KeychainSwift()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DepartureLabel: UILabel!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var DataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // all trips in this json
        let json = JSON(data)
        
        tableView.dataSource = self
        
       json.forEach { data in
            let (_, trip) = data
        DepartureLabel.text = trip["start_station"]["name"].string!
        DestinationLabel.text = trip["end_station"]["name"].string!
        DataLabel.text = trip["date"].string!
        let hour = String(trip["start_time"].string!.characters.dropLast(3)) + "  -  " + String(trip["end_time"].string!.characters.dropLast(3))
        let date = trip["date"].string!
        self.tripList.append(Trip(withTheHours: hour, andADateOf: date))
        }
        
//        let trip = Trip(withTheHours: "SEND", andADurationOf: 4.5)
//        self.tripList.append(trip)
//        self.tripList.append(Trip(withTheHours: "NUDES", andADurationOf: 4.5))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TripListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let tripCell = cell as? TripTableViewCell {
            
            let index = indexPath.row
            let trip = self.tripList[index]

            // print("index: \(index)")
            // print("title: \(trip.hours)")
            
            tripCell.setup(withTheHours: trip)
            
            return tripCell
        }
        
        return UITableViewCell()
    }
}
