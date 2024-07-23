//
//  ViewController.swift
//  CollectionView+asyncPrac
//
//  Created by 시모니 on 7/22/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var urls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadPlist()
        print("살라살라")
    }
    
    func loadPlist() {
        guard let url = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              //⬆️번들에서 "Photos.plist" 파일의 URL을 가져옵니다.
              //url 변수는 이 파일의 URL을 가리킵니다. 만약 파일을 찾지 못하면 nil이 됩니다.
              let contents = try? Data(contentsOf: url),
              //⬆️파일의 내용을 Data 객체로 읽어옵니다.
              //try?를 사용하여 오류가 발생할 경우 nil을 반환합니다.
              let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
              //⬆️plist 데이터를 Swift 객체로 변환합니다.
              //contents는 Data 객체로 변환된 plist 파일의 내용입니다.
              //format은 출력 형식 정보를 담기 위한 파라미터로 nil을 사용하여 무시할 수 있습니다.
              //serial 변수는 plist 파일의 내용을 직렬화한 결과 객체를 가리킵니다. 오류가 발생하면 nil이 됩니다.
              let serialURLs = serial as? [String]
                //⬆️serial을 [String] 타입으로 캐스팅합니다.
                //serialUrls 변수는 plist 파일에 저장된 URL 문자열 배열을 가리킵니다. 만약 캐스팅이 실패하면 nil이 됩니다.
        else {
          return print("어디선가 사고남")
        }
        
        urls = serialURLs.compactMap({ URL(string: $0)})
        /* ⬆️
         compactMap 메서드를 사용하여 serialUrls 배열의 각 요소를 URL 객체로 변환합니다.
         URL(string: $0): 각 문자열을 URL 객체로 초기화합니다. 유효하지 않은 URL 문자열은 nil로 변환됩니다.
         compactMap은 nil 값을 제거하고 유효한 URL 객체들만 포함한 새로운 배열을 반환합니다.
         urls 변수는 유효한 URL 객체들을 가리키게 됩니다.
         */
              
    }


}

extension ViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell else {
            return UICollectionViewCell()
        }
        
        if let data = try? Data(contentsOf: urls[indexPath.item]),
           let img = UIImage(data: data) {
            cell.imgView.image = img
        } else {
            cell.imgView.image = nil
        }
           
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //이게 사이즈 조절해주는 메서드임.
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let totalSpacing = (itemsPerRow - 1) * spacing + 20
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    

    
}

class MyCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
}

