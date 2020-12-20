//
//  StudentLocationListController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit

class StudentLocationListController: UIViewController {
    
    private let tableView       = UITableView()
    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(getUsers), for: .valueChanged)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        rc.attributedTitle = NSAttributedString(string: "Fetching new students ...", attributes: attributes)
        return rc
    }()
    
    var dataUser                = Data.shared.usersData
    
    var locations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        
        configureNavBar()
        configureTableView()
        
    }
    
    
    fileprivate func configureNavBar() {
        let addNavBarButton: UIBarButtonItem    = .init(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(handleAddLocation))
        
        navigationItem.leftBarButtonItem        = .init(title: "Sign Out",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(handleSignOut))
        
        navigationItem.rightBarButtonItems      = [addNavBarButton]
    }
    
    
    fileprivate func configureTableView() {
        view.stack(tableView)
        
        tableView.register(StudentLocationListCell.self, forCellReuseIdentifier: "cellId")
        tableView.refreshControl    = refreshControl
        tableView.dataSource        = self
        tableView.delegate          = self
    }
    
    
    // MARK: - OBJC Functions
    
    @objc func getUsers(){
        refreshControl.beginRefreshing()
        
        OTMApi.shared.getStudentLocations { result in
            switch result {
            case .failure:
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToGetStudentLocation.rawValue, buttonTitle: "Ok")
                
            case .success(let locations):
                DispatchQueue.main.async { self.refreshControl.endRefreshing() }
                
                guard let userLocation = locations else { return }
                
                self.dataUser = userLocation as [StudentLocation]
                
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }

    
    @objc func handleAddLocation() {
        let addLocationVC   = AddLocationController()
        let navController   = UINavigationController(rootViewController: addLocationVC)
        present(navController, animated: true)
    }
    
    
    @objc func handleSignOut() {
        OTMApi.signOut { (result) in
            switch result {
            case .failure:
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToSignOut.rawValue, buttonTitle: "Ok")
                
            case .success:
                self.dismiss(animated: true)
            }
        }
    }
}


// MARK: - StudentLocationListController+UITableViewDataSource,UITableViewDelegateEXT

extension StudentLocationListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataUser.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! StudentLocationListCell

        let user    = self.dataUser[indexPath.row] as! StudentLocation
        cell.user   = user
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.dataUser[indexPath.row] as! StudentLocation
        
        if let urlString = data.mediaURL {
            openURL(urlString)
        }
    }
}
