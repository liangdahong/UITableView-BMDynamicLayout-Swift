
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dataArray: [String] = {
        var arr = [String]()
        for _ in 0...30 {
            var arc = arc4random_uniform(40)
            var str = "我"
            while arc > 0 {
                str.append("我")
                arc-=1
            }
            arr.append(str)
        }
        return arr
    }()

    override func viewDidLoad() {
        super.viewDidLoad() 
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = TableViewCell.tableViewCell(tableView)
        cell.testLabel.text = dataArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.cellHeight(cellClass: TableViewCell.self) { (cell) in
            cell.testLabel.text = dataArray[indexPath.row]
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HeaderView.tableViewHeaderFooterView(tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return FooterView.tableViewHeaderFooterView(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
