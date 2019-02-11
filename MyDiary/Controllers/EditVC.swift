//
//  EditVC.swift
//  MyDiary
//
//  Created by Ruslan NAUMENKO on 1/25/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import rnaumenk2019

class EditVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.delegate = self
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    let pickerController = UIImagePickerController()
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self

        nameTextField.text = article?.title
        contentTextView.text = article?.content != nil ? article?.content : NSLocalizedString("No content's given", comment: "Set in code")
        if let imageData = article?.image as Data? {
            imageView.image = UIImage(data: imageData)
        }
        
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchesBeganForScrollView(_:))))
    }
    
    @objc func touchesBeganForScrollView(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            if nameTextField.isFirstResponder {
                nameTextField.resignFirstResponder()
            }
            else if contentTextView.isFirstResponder {
                contentTextView.resignFirstResponder()
            }
        default:
            break
        }
    }

    @IBAction func takePictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func choosePictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let listVC = navigationController?.viewControllers.first(where: { $0 is ListVC } ) as! ListVC
        
        let title = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = contentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !(title?.isEmpty)! else {
            showAlertController(NSLocalizedString("Title field is empty", comment: "Set in code"))
            return
        }
        
        if article == nil {
            article = listVC.articleManager.newArticle()
            article?.creationDate = Date() as NSDate
        }
        
        let language = NSLinguisticTagger.dominantLanguage(for: content!)
        
        article?.language = language != nil ? language : "en"
        article?.title = title
        article?.content = content
        article?.modificationDate = Date() as NSDate
        
        if let imageData = imageView.image!.pngData() {
            article?.image = imageData as NSData
        }
        else if let imageData = imageView.image!.jpegData(compressionQuality: 1.0) {
            article?.image = imageData as NSData
        }
        
        listVC.articleManager.save()
        
        navigationController?.popToViewController(listVC, animated: true)
    }
}

extension EditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let possibleImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            imageView.image = possibleImage.fixOrientation()
        } else if let possibleImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageView.image = possibleImage.fixOrientation()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

extension EditVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
}

extension EditVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            textView.selectAll(nil)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("No content's given", comment: "Set in code")
        }
    }
}

extension EditVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
        else if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
