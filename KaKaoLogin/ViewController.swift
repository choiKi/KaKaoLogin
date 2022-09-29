//
//  ViewController.swift
//  KaKaoLogin
//
//  Created by 최기훈 on 2022/09/29.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    
    lazy var kakaoLoginStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 여부 라벨"
        return label
    }()
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하기", for: .normal)
        button.configuration = .filled()
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var kakaoLoginoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃 하기", for: .normal)
        button.configuration = .filled()
        button.addTarget(self, action: #selector(loginoutButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var kakaoAuthVM: KakaoAuthVM = { KakaoAuthVM()
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stackView.addArrangedSubview(kakaoLoginStatusLabel)
        stackView.addArrangedSubview(kakaoLoginButton)
        stackView.addArrangedSubview(kakaoLoginoutButton)
        
        
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        setBinding()
        
    }
    
    //MARK:- 버튼 액션
    @objc func loginButtonClicked() {
        print("login")
        kakaoAuthVM.kakaoLogin()
        
    }
    @objc func loginoutButtonClicked() {
        print("logout")
        kakaoAuthVM.kakaoLogout()
    }

} // ViewController

//MARK:- 뷰모델 바인딩
extension ViewController {
    fileprivate func setBinding() {
        self.kakaoAuthVM.$isLoggedIn.sink { [weak self] isLoggedIn in
            guard let self = self else { return }
            self.kakaoLoginStatusLabel.text = isLoggedIn ? "로그인 상태" : "로그아웃 상태"
        }
        .store(in: &subscriptions)
    }
}

#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
    }
}

#endif
