

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    let db = Firestore.firestore()
    var messages:[Message] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessage()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        navigationItem.hidesBackButton = true
        
        title = K.nameApp
        
    }
    
    func loadMessage() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            if let e = error {
                print(e)
            } else {
                self.messages = []
                if let snapShotDocument = querySnapshot?.documents {
                    for doc in snapShotDocument {
                        let data = doc.data()
                        if let senderUser = data[K.FStore.senderField] as? String, let senderMessage = data[K.FStore.bodyField] as? String {
                            let message = Message(bode: senderMessage, user: senderUser)
                            self.messages.append(message)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let index = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: index, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        let currentData = Date().timeIntervalSince1970
        let senderMessage = messageTextfield.text
        if  senderMessage != "" , let senderName = Auth.auth().currentUser?.email  {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : senderName, K.FStore.bodyField: senderMessage, K.FStore.dateField: currentData]) { (error) in
                if let e = error {
                    print(e)
                }else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = nil
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPress(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].bode
        
        if Auth.auth().currentUser?.email == messages[indexPath.row].user {
            cell.leftAvatar.isHidden = true
            cell.meAvatar.isHidden = false
            cell.messageBooble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }else {
            cell.meAvatar.isHidden = true
            cell.leftAvatar.isHidden = false
            cell.messageBooble.backgroundColor = UIColor(named: K.BrandColors.blue)
            cell.label.textColor = UIColor(named: K.BrandColors.lighBlue)
        }
        return cell
    }
}
