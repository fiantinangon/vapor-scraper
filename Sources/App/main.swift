import Vapor
import Kanna
import Foundation

let drop = Droplet()

drop.get { req in
//    return try drop.view.make("welcome", [
//    	"message": drop.localization[req.lang, "welcome", "title"]
//    ])
  return "Hello World"
}

drop.get("antam","harga") { request in
//  guard let strUrl = request.data["url"]?.string else {
//    throw Abort.badRequest
//  }
  
  if let _url = URL(string: "http://harga-emas.org/") {
    if let doc = HTML(url: _url, encoding: .utf8) {
      let strTitle = doc.title ?? ""
      
      var infoHarga: Dictionary = [String:Any]()
      var arrPrice: [String] = [String]()
      
      var nodePrice: Node = .null
      var arrNodePrice: [Node] = ["antam"]
      
      let strGram:XPathObject = doc.css(".in_table tr:nth-child(3) td:nth-child(1)")
      let antamPriceBatangan:XPathObject = doc.css(".in_table tr:nth-child(3) td:nth-child(2)")
      let antamPricePerGram:XPathObject = doc.css(".in_table tr:nth-child(3) td:nth-child(3)")
      
      let tblAntam = doc.css(".in_table")[2]
      var gram: String = String()
      var batangan: String = String()
      var perGram: String = String()
      var dictPrice: [String:String] = [String:String]()
      
      for indexForRow in 0...tblAntam.css("tr").count-2 {
        if indexForRow >= 2 {
          if let strGram = tblAntam.css("tr")[indexForRow].css("td")[0].text {
            gram = strGram
          }else {
            gram = "-"
          }
          
          if let strAntamPriceBatangan = tblAntam.css("tr")[indexForRow].css("td")[1].text {
            batangan = strAntamPriceBatangan
          }else {
            batangan = "-"
          }
          
          if let strAntamPricePerGram = tblAntam.css("tr")[indexForRow].css("td")[2].text {
            perGram = strAntamPricePerGram
          }else {
            perGram = "-"
          }
          
          dictPrice = ["batangan" : batangan,
                         "gram" : perGram
          ]
          
          let nodePrice = try dictPrice.makeNode()
          
          arrNodePrice.append(Node.object([gram : nodePrice]))
        }
      }
      
//      if doc.css(".in_table").count >= 2 {
//        if let _strGram = strGram[2].text {
//          infoHarga[_strGram] = [antamPriceBatangan[2].text ?? "",antamPricePerGram[2].text ?? ""]
//          arrPrice.append(antamPriceBatangan[2].text ?? "")
//          arrPrice.append(antamPricePerGram[2].text ?? "")
//          
//          let priceNode = try arrPrice.makeNode()
//          
//          nodePrice = Node.object([_strGram : priceNode])
//        }
//      }
      
      return try JSON(node: arrNodePrice)
      
    }else {
      throw Abort.badRequest
    }
  }else {
    throw Abort.badRequest
  }
}

//Route /hola
drop.get("hola") { request in
  return try JSON(node: [
    "result": "Hello JSON ola ola"
    ])
}






drop.run()
