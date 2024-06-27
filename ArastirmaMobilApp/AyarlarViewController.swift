//
//  AyarlarViewController.swift
//  ArastirmaMobilApp
//
//  Created by Oktay Kuzu on 15.06.2024.
//

import UIKit

class AyarlarViewController: UIViewController {

    @IBOutlet weak var EmailLabel: UILabel!
    
    @IBOutlet weak var AdLabel: UILabel!
    
    @IBOutlet weak var SoyadLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      labelBilgileriyazdir()
    }
    
    
    func labelBilgileriyazdir(){
        
        if let kullaniciEmail = Singleton.shared.uye_kayitemail, let kullanici_ad = Singleton.shared.uye_kayitad , let kullanici_soyad = Singleton.shared.uye_kayitsoyad {
            EmailLabel.text = kullaniciEmail
           AdLabel.text = kullanici_ad
           SoyadLabel.text = kullanici_soyad
            
        } else {
            // Singleton'dan kullanıcı e-posta alınamadı
            // Uygun bir hata işleme stratejisi ekleyebilirsiniz
            EmailLabel.text = "E-posta Bulunamadı"
        }
    }
    
    
}
