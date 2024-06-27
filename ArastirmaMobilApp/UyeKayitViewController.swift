//
//  UyeKayitViewController.swift
//  ArastirmaMobilApp
//
//  Created by Oktay Kuzu on 15.06.2024.
//

import UIKit
import Firebase
class UyeKayitViewController: UIViewController {

    @IBOutlet weak var KayitEmailText: UITextField!
    @IBOutlet weak var KayitAdText: UITextField!
    @IBOutlet weak var KayitSoyadText: UITextField!
    @IBOutlet weak var KayitSifreTxt: UITextField!
    
    @IBOutlet weak var KayitSifreTekrarText: UITextField!
    
    var ref : DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        ref = Database.database().reference()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // View'a UITapGestureRecognizer ekledim
        view.addGestureRecognizer(tapGesture)
       
    }
    
 
    
    
    @objc func dismissKeyboard() {
          view.endEditing(true)
      }
    @IBAction func BtnEKle(_ sender: UIButton) {
        
        UyeEkle()
        if KayitEmailText.text != "" && KayitAdText.text != "" && KayitSoyadText.text != "" &&   KayitSifreTxt.text != "" &&  KayitSifreTekrarText.text != "" {
            
            if KayitSifreTxt == KayitSifreTxt {
                UyeEkle()
               MesajAlert(tittle: "Üye Kayıt", mesaj: "Uygulamamıza Başarılı Bir Şekilde Kayıt oldunuz.")
            }else{
                MesajAlert(tittle: "Şifre Uyumsuzluğu!", mesaj: "Lütfen Şifrelerinizi aynı giriniz.")
            }
          
        }
        else if KayitEmailText.text == "" && KayitAdText.text == "" && KayitSoyadText.text == "" &&   KayitSifreTxt.text == "" &&  KayitSifreTekrarText.text == "" {
            MesajAlert(tittle: "Uyarı!!", mesaj: "Lütfen Boş alanları doldurunuz ve tekrar deneyiniz.")
            
        }
    
    }
    
    
    
    func UyeEkle() {
        // textden gelen verileri if let yapısını kullanarak ınt cevirilmesi gerekenleri cevirdim.
        if let email = KayitEmailText.text,
           let ad = KayitAdText.text,
           let soyad = KayitSoyadText.text,
           let sifreStr = KayitSifreTxt.text,
           let sifreTStr = KayitSifreTekrarText.text,
           let sifre = Int(sifreStr),
           let sifreT = Int(sifreTStr) {
            
            // Yeni üye kaydı oluşturdum
            let yeniuye = Uyelerkayit(uye_kayitemail: email, uye_kayitad: ad, uye_kayitsoyad: soyad, uye_kayitsifre: sifre, uye_kayitsifreT: sifreT)
            
            // Dict dizisi oluşturdum.
            let dict: [String: Any] = [
                "uye_kayitemail": yeniuye.uye_kayitemail!,
                "uye_kayitad": yeniuye.uye_kayitad!,
                "uye_kayitsoyad": yeniuye.uye_kayitsoyad!,
                "uye_kayitsifre": yeniuye.uye_kayitsifre!,
                "uye_kayitsifreT": yeniuye.uye_kayitsifreT!
            ]
          //Firebase Tabloma kayıt yollama
            let newref = ref?.child("Uyekayit").childByAutoId()
            newref?.setValue(dict)
            
        } else {
            // Herhangi bir metin alanı boş ise veya şifreler sayıya dönüştürülemezse hata mesajı verelim
            print("Lütfen tüm alanları doğru doldurun ve şifrelerin sayı olduğundan emin olun.")
        }
    }

    func MesajAlert(tittle :String ,  mesaj : String){
        let alert = UIAlertController(title: tittle, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OketBtn = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
        alert.addAction(OketBtn)
        self.present(alert, animated: true)
        
        
    }
    @IBAction func GirisYapGit(_ sender: Any) {
        
    }
    
}
