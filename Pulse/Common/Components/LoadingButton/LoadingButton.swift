import UIKit

public class LoadingButton: UIButton {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var lastKnownTitle: String?
    /// A Boolean value indicating whether a loading operation has been triggered and is in progress. (read-only)
    public var loading: Bool {
        return activityIndicator.isAnimating
    }

    /**
    Tells the control that a loading operation was started programmatically.
    Call this method when an external event source triggers a programmatic loading event. This method updates the state of the button control to reflect the in-progress loading operation. When the loading operation ends, be sure to call the endLoading method to return the control to its default state.
    */
    public func beginLoading() {
        lastKnownTitle = currentTitle
        setTitle("", for: .normal)
        activityIndicator.startAnimating()
        isEnabled = false
    }

    /**
    Tells the control that a loading operation has ended.
    Call this method at the end of any loading operation (whether it was initiated programmatically or by the user) to return the button control to its default state. Calling this method also hides it.
    */
    public func endLoading() {
        setTitle(lastKnownTitle, for: .normal)
        activityIndicator.stopAnimating()
        isEnabled = true
    }

    // MARK: Private
    
    private func configureActivityIndicator() {
        // Allow this method to only run once
        guard activityIndicator.superview == .none else { return }
                
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        let centerXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }

    // MARK: Overrides
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with:event)

        if let touch = touch, touch.tapCount > 0 {
            beginLoading()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        configureActivityIndicator()
    }

}
