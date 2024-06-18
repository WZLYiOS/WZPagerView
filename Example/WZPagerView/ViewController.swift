//
//  ViewController.swift
//  WZPagingView
//
//  Created by LiuSky on 09/05/2019.
//  Copyright (c) 2019 LiuSky. All rights reserved.
//

import UIKit
import WZFullscreenPopGesture

/// MARK - Demo
final class ViewController: UIViewController {
    
    /// 列表
    private lazy var tableView: UITableView = {
        let temTableView = UITableView()
        temTableView.backgroundColor = UIColor.white
        temTableView.rowHeight = 50;
        temTableView.tableFooterView = UIView()
        temTableView.delegate = self
        temTableView.dataSource = self
        temTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        temTableView.translatesAutoresizingMaskIntoConstraints = false
        return temTableView
    }()
    
    /// 类型
    private lazy var titles = ["头部下拉刷新", "内部刷新", "控制器", "嵌套", "单个下拉效果"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = HeaderRefreshViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = ListRefreshViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = VCViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = NestViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = SingleListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

