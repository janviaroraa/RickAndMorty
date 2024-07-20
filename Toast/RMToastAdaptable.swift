//
//  RMToastAdaptable.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 19/07/24.
//

import UIKit

class PPToastAdaptable: NSObject {

    private var message: String?
    private let toastContainerTag = 1234 //This is random id given

    func getTitleColor() -> UIColor {
        return .black
    }

    func getBackgroundColor() -> UIColor {
        return .white
    }

    lazy var toastContainer: UIView = {
        let view = UIView()
        view.makeRounded(radius: 12)
        view.backgroundColor = getBackgroundColor()
        view.tag = toastContainerTag
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var headerLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = getTitleColor()
        lbl.text = message
        return lbl
    }()

    lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }()

    init(withText message: String?) {
        super.init()
        self.message = message
        addViews()
        layoutConstraints()
    }

    private func addViews() {
        toastContainer.addSubview(headerLbl)
    }

    private func layoutConstraints() {
        guard let window = window else { return }

        NSLayoutConstraint.activate([
            headerLbl.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 12),
            headerLbl.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -12),
            headerLbl.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 16),
            headerLbl.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -16)
        ])
    }

    func show(duration: Double = 1.3) {
        guard let window = window,
              !window.subviews.contains(where: { $0.tag == toastContainerTag && !($0.layer.animationKeys() ?? []).isEmpty }) else { return }

        window.addSubview(toastContainer)

        NSLayoutConstraint.activate([
            toastContainer.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            toastContainer.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            toastContainer.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor),
            toastContainer.centerXAnchor.constraint(equalTo: window.safeAreaLayoutGuide.centerXAnchor)
        ])

        let toastYUpperBound = UIScreen.main.bounds.height * 0.87 // 0.87 because the toast should not overlap bottom bar
        let toastYLowerBound = UIScreen.main.bounds.height + 20

        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = toastYLowerBound
        animation.toValue = toastYUpperBound
        animation.duration = 0.3
        animation.speed = 0.3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        toastContainer.layer.add(animation, forKey: UUID().uuidString)

        // Pause when toast is at top
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 1) {
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.fromValue = toastYUpperBound
            animation.toValue = toastYLowerBound
            animation.duration = 0.3
            animation.speed = 0.3
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.delegate = self
            self.toastContainer.layer.add(animation, forKey: UUID().uuidString)
        }
    }
}

extension PPToastAdaptable: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.toastContainer.layer.removeAllAnimations()
            self.toastContainer.removeFromSuperview()
        }
    }
}
