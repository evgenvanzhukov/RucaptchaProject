
import Foundation
import UIKit

class RucaptchaService {

    let urlSendCaptcha = "http://rucaptcha.com/in.php"// используется для отправки капчи
    let urlResult = "http://rucaptcha.com/res.php" //используется для получения ответа на капчу
    var key = "приватный ключ"
    let method = "base64"
    let urlSession = URLSession.shared
    let decoder = JSONDecoder()
    
    func sendToRecognize(_ image: UIImage, completion: @escaping (ApiResult) -> Void) {
        
        let newImage = image.resizeImage(newWidth: CGFloat(200))
        
        let imageData: NSData = newImage.pngData()! as NSData
        
        let base64 = imageData.base64EncodedString(options: .lineLength64Characters)
                
        if let url = URL(string: urlSendCaptcha + "?key=\(key)&method=base64&json=1") {
            
            var request = URLRequest(url: url)
            
            let boundary = "Boundary-\(UUID().uuidString)"
            
            let body = "--\(boundary)\r\n" +
            "Content-Disposition:form-data; name=\"body\"\r\n" +
            "\r\n\(base64 )\r\n" +
            "--\(boundary)--\r\n"
            
            request.httpMethod = "POST"
            
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = body.data(using: .utf8)
            
            sendRequest(request, completion: completion).resume()
        }
    }

    func checkRecognized(_ id: String, completion: @escaping (ApiResult) -> Void) {
        if let url = URL(string: urlResult + "?key=\(key)&action=get&json=1&id=\(id)") {
            var request = URLRequest(url: url)
            
            sendRequest(request, completion: completion).resume()
        }
    }
    
    func sendRequest(_ request: URLRequest, completion: @escaping (ApiResult) -> Void) -> URLSessionDataTask {
        return
        urlSession.dataTask(with: request) {[weak self] (data, response, error) in
            var result: ApiResult
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if error != nil {
                print(error!.localizedDescription)
                result = ApiResult.failure(error: error as! Error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    result = .failure(error: "Status: \(httpResponse.statusCode)")
                    return
                }
            }
            
            if let content = data {
                //let stringContent = String(data: content, encoding: String.Encoding.utf8)
                do {
                    let captchaResponse = try self?.decoder.decode(CaptchaResponse.self, from: content)
                    result = ApiResult.success(response: captchaResponse!)
                    return
                } catch (let errorDecoding) {
                    print(errorDecoding.localizedDescription)
                    result = ApiResult.failure(error: errorDecoding)
                    return
                }
            }
            
            result = .failure(error: "empty result")
        }
    }
}










class CaptchaResponse : Codable {
    var status: Int?
    var error: String?
    var request: String?
}

enum ApiResult {
    case success (response: CaptchaResponse)
    case failure (error: Error)
}
