import UIKit
import AVFoundation
import CoreML
import Vision

class KameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var faceBoundingBoxes: [CAShapeLayer] = []
    var isProcessing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // AVCaptureSession oluştur
        captureSession = AVCaptureSession()

        // Kamera girişini ayarla
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            return
        }
        captureSession?.addInput(input)

        // Kamerayı başlat
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }

        // Kamera görüntüsünü ekrana ekle
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = view.frame

        // Video çerçevelerini işlemek üzere çıkış ayarla
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession?.addOutput(dataOutput)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // İşlem sürerken yeni bir işlem başlatmayı engelle
        guard !isProcessing else { return }
        isProcessing = true

        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        do {
            // Suçlu tespiti için Core ML modelini yükle
            guard let model = try? VNCoreMLModel(for: ModelYakalama().model) else {
                return
            }

            // Vision Framework ile suçlu tespiti yap
            let request = VNCoreMLRequest(model: model) { [weak self] finishedReq, err in
                guard let self = self else { return }

                defer {
                    self.isProcessing = false  // İşlem tamamlandıktan sonra işareti kapat
                }

                if let error = err {
                    print("Hata oluştu: \(error)")
                    return
                }

                guard let results = finishedReq.results as? [VNClassificationObservation],
                      let firstObservation = results.first
                else {
                    print("Sonuçlar alınamadı")
                    return
                }

                print("Tespit edilen sınıf: \(firstObservation.identifier), Güven seviyesi: \(firstObservation.confidence * 100)%")

                if firstObservation.identifier == "sucluolmayan" && firstObservation.confidence > 0.90 {
                    // Suçlu olmayan tespit edildi, işlemleri gerçekleştirin
                    DispatchQueue.main.async {
                        // Ek işlemleri buraya ekleyin
                        print("Suçlu değil!")
                    }

                } else if firstObservation.identifier == "suclular" && firstObservation.confidence > 0.99 {
                    // Suçlu tespit edildi, gerekli işlemleri gerçekleştirin

                    // Capture Session'ı durdur
                    self.captureSession?.stopRunning()

                    // İsterseniz bir mesaj göster
                    DispatchQueue.main.async {
                        self.showPoliceAlert()
                    }
                }

                // Yüzleri çerçeve içine alarak göster
                self.drawFaceBoundingBoxes(on: finishedReq)
            }

            try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        } catch {
            print("Hata oluştu: \(error)")
            isProcessing = false  // İşlem hatası durumunda işareti kapat
        }
    }

    private func drawFaceBoundingBoxes(on request: VNRequest) {
        guard let observations = request.results as? [VNFaceObservation] else { return }

        // Önceki çizimleri temizle
        DispatchQueue.main.async {
            self.clearDrawings()

            for observation in observations {
                let boundingBox = observation.boundingBox
                let faceBoundingBox = self.createBoundingBoxShapeLayer(for: boundingBox)
                self.previewLayer?.addSublayer(faceBoundingBox)
                self.faceBoundingBoxes.append(faceBoundingBox)
            }
        }
    }

    private func createBoundingBoxShapeLayer(for rect: CGRect) -> CAShapeLayer {
        // Yüz çerçevesini oluştur
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: rect.origin.x * previewLayer!.frame.width,
                             y: (1 - rect.origin.y - rect.height) * previewLayer!.frame.height,  // Y koordinatını doğru ayarlamak için ekstra hesaplama
                             width: rect.width * previewLayer!.frame.width,
                             height: rect.height * previewLayer!.frame.height)
        layer.borderWidth = 2
        layer.borderColor = UIColor.yellow.cgColor  // Sarı renk olarak değiştirdik
        return layer
    }

    private func clearDrawings() {
        // Kamera görüntüsündeki yüzleri temizle
        self.faceBoundingBoxes.forEach { faceBoundingBox in
            faceBoundingBox.removeFromSuperlayer()
        }
        self.faceBoundingBoxes.removeAll()
    }

    private func showPoliceAlert() {
        if let enlem = Singleton.shared.uye_kayitenlem, let boylam = Singleton.shared.uye_kayitboylam {
            let alert = UIAlertController(title: "Suçlu Tespit Edildi, polise haber verilsin mi ?", message: "enleminiz: \(enlem), boylamınız: \(boylam)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Gönderme!", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "İhbar et!", style: .default, handler: nil))

            present(alert, animated: true, completion: nil)
        } else {
            // Eksik konum bilgisi durumu
            let alert = UIAlertController(title: "Suçlu Tespit Edildi, polise haber verilsin mi ?", message: "Konum bilgileri eksik", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))

            present(alert, animated: true, completion: nil)
        }
    }
}

