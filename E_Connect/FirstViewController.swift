import UIKit

class FirstViewController: UIViewController, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    let databaseInterface = DatabaseInterface()
    
    var data: [(String,Int)] = [("Loading...",-1)]
    
    override func viewDidAppear(animated: Bool){
        buildData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    func refresh(sender:AnyObject){
        buildData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.text = data[indexPath.row].0
        if((data[indexPath.row].1) >= 0){
            cell.detailTextLabel!.text="\(data[indexPath.row].1)"
        } else {
            cell.detailTextLabel!.text=""
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count <= 30{
            return data.count
        } else {
            return 30
        }
    }
    
    func buildData(){
        let callback = {(success: Bool, response_data: Array<(Int, String, Int)>) -> () in
            dispatch_async(dispatch_get_main_queue()){
                self.data = [(String,Int)]()
                if success {
                    for tuple in response_data {
                        var str: String = tuple.1
                        if str.characters.count > 26{
                            let someIndex = advance(str.startIndex, 26)
                            str = str.substringToIndex(someIndex)
                            str = str + "..."
                        }
                        let tp = (str,tuple.2)
                        self.data.append(tp)
                    }
                } else {
                    let tuple = ("Network Error",-1)
                    self.data.append(tuple)
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        databaseInterface.getLeaderBoard(callback)
    }
}
