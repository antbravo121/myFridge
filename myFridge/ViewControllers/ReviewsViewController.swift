//
//  ReviewsViewController.swift
//  myFridge
//
//  Created by Kyle George on 4/12/21.
//

import UIKit
import Parse

class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var post: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
//        let currPost = post
//        func prepare(for segue: UIStoryboardSegue, sender: Any?){
//            let addReviewViewController = segue.destination as! addReviewViewController
//            addReviewViewController.post = currPost
//        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard
        reviewTextView.resignFirstResponder()
    }

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddReviewButton(_ sender: Any) {
        print(post)
        let review = PFObject(className: "Reviews")
        
        review["text"] = reviewTextView.text
        review["post"] = post
        review["author"] = PFUser.current()
        
        post.add(review, forKey: "reviews")
        
        post.saveInBackground{ (success, error) in
            if success{
                print("review saved")
            }
            else{
                print("Error saving review")
            }
        }
        
        reviewTextView.text = "Add a review"
        
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let reviews = (post["reviews"] as? [PFObject]) ?? []
        
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewViewCell") as! ReviewViewCell
        
        let reviews = (post["reviews"] as? [PFObject]) ?? []

        let review = reviews[indexPath.row]
        cell.reviewLabel.text = review["text"] as? String

        let user = review["author"] as! PFUser
        cell.usernameButton.setTitle(user.username, for: .normal)
        
        if user["profileImage"] != nil{
            let imageFile = user["profileImage"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.profileImage.af_setImage(withURL: url)
        }

        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
