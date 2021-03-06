//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportPresenter {
    
    weak var view: ReportViewInput!
    var interactor: ReportInteractorInput!
    var router: ReportRouterInput!
    
    fileprivate var selectedIndexPath: IndexPath? {
        didSet {
            if let oldValue = oldValue {
                view.deselectCheckmark(at: oldValue)
            }
            
            if let newValue = selectedIndexPath {
                view.selectCheckmark(at: newValue)
            }
        }
    }
    
    fileprivate var isSubmitButtonEnabled: Bool {
        return selectedIndexPath != nil
    }
    
    fileprivate let actionStrategy: AuthorizedActionStrategy
    
    init(actionStrategy: AuthorizedActionStrategy) {
        self.actionStrategy = actionStrategy
    }
}

extension ReportPresenter: ReportViewOutput {
    
    func viewIsReady() {
        view.setSubmitButtonEnabled(isSubmitButtonEnabled)
    }
    
    func onRowSelected(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        view.setSubmitButtonEnabled(isSubmitButtonEnabled)
    }
    
    func onSubmit() {
        guard let selectedIndexPath = selectedIndexPath,
            let reason = interactor.reportReason(forIndexPath: selectedIndexPath) else {
            return
        }
        
        actionStrategy.executeOrPromptLogin { [weak self] in self?.submit(reason: reason) }
    }
    
    private func submit(reason: ReportReason) {
        view.setIsLoading(true)
        
        interactor.submitReport(with: reason) { [weak self] result in
            self?.view.setIsLoading(false)
            
            if result.isSuccess {
                self?.router.openReportSuccess(onDone: self?.router.close)
            } else {
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
    
    func onCancel() {
        router.close()
    }
}
