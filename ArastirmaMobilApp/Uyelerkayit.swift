
import Foundation



class Uyelerkayit {
    var  uye_kayitemail : String?
    var uye_kayitad : String?
    var uye_kayitsoyad : String?
    var uye_kayitsifre : Int?
    var uye_kayitsifreT : Int?
    
    
    init (){
        
    }
    
    init(uye_kayitemail: String? = nil, uye_kayitad: String? = nil, uye_kayitsoyad: String? = nil, uye_kayitsifre: Int? = nil, uye_kayitsifreT: Int? = nil) {
        self.uye_kayitemail = uye_kayitemail
        self.uye_kayitad = uye_kayitad
        self.uye_kayitsoyad = uye_kayitsoyad
        self.uye_kayitsifre = uye_kayitsifre
        self.uye_kayitsifreT = uye_kayitsifreT
    }
    
}
