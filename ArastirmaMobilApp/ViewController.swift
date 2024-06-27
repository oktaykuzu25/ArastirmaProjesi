//
//  ViewController.swift
//  ArastirmaMobilApp
//
//  Created by Oktay Kuzu on 14.06.2024.
//

import UIKit
import Firebase
import LocalAuthentication
class ViewController: UIViewController {

    @IBOutlet weak var EmailText: UITextField!
    
    @IBOutlet weak var SifreText: UITextField!
    @IBOutlet weak var SifreTekrarText: UITextField!
    
    @IBOutlet weak var myLabel: UILabel!
    
    var ref : DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
   
        ref = Database.database().reference()
        // UITapGestureRecognizer oluşturdum.
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            
            // View'a UITapGestureRecognizer ekledim
            view.addGestureRecognizer(tapGesture)
     
      
    }
    
    @objc func dismissKeyboard() {
          view.endEditing(true)
      }
    

    @IBAction func LoginOnclick(_ sender: Any) {
        if EmailText.text != "" && SifreText.text != "" && SifreTekrarText.text != "" {
            if SifreText.text == SifreTekrarText.text {
                let authContext = LAContext()
                      
                  var error: NSError?
                if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                          
                          authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Is it you?") { (success, error) in
                              if success == true {
                                  //successful auth
                                  DispatchQueue.main.async {
                                      self.performSegue(withIdentifier: "AnasayfaVC", sender: nil)
                                      self.kisisorgu()
                                  }
                              } else {
                                  DispatchQueue.main.async {
                                      self.myLabel.text = "Error!"
                                  }
                              }
                          }
                          
                          
                      }
                      
               
            }else{
                hatamesaji(tittle: "Şifre uyumsuzluğu ", mesaj: "Lütfen aynı şifreyi giriniz..!")
            }
        } else {
            hatamesaji(tittle: "Boş alan!", mesaj: "Lütfen boş alanları doldurunuz...!")
        }
    }
    
    
    func kisisorgu(){
        let sorgu = ref?.child("Uyekayit").queryOrdered(byChild: "uye_kayitemail").queryEqual(toValue: EmailText.text!)
        sorgu!.observe(.value, with: { snapshot in
            if let gelenveributonu = snapshot.value as? [String:AnyObject]{
                for gelensatirverisi in gelenveributonu{
                    if let sozluk = gelensatirverisi.value as? NSDictionary{
                        let key = gelensatirverisi.key
                        let kisiemail = sozluk["uye_kayitemail"] as? String ?? ""
                        let kisiad = sozluk["uye_kayitad"] as? String ?? ""
                       let kisisoyad = sozluk["uye_kayitsoyad"] as? String ?? ""
                        Singleton.shared.uye_kayitemail = self.EmailText.text
                              Singleton.shared.uye_kayitad = kisiad
                              Singleton.shared.uye_kayitsoyad = kisisoyad
                        
                        
                    }
                }
            }
        })
    }
    
    func hatamesaji(tittle :String ,  mesaj : String){
        let alert = UIAlertController(title: tittle, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OketBtn = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
        alert.addAction(OketBtn)
        self.present(alert, animated: true)
        
        
    }
    
}



