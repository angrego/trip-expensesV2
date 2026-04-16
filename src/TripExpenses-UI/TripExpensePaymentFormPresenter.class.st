Class {
	#name : 'TripExpensePaymentFormPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-PaymentForm',
	#package : 'TripExpenses-UI',
	#tag : 'PaymentForm'
}

{ #category : 'rendering' }
TripExpensePaymentFormPresenter >> onAddPayment: anAnnouncement [
    self model addPaymentAmount: anAnnouncement amount.
    self model isShowing ifFalse: [
        self parent onPaymentAdded ]
]

{ #category : 'rendering' }
TripExpensePaymentFormPresenter >> onHide [
    self model hide.
    self parent onPaymentFormHidden
]

{ #category : 'rendering' }
TripExpensePaymentFormPresenter >> renderView [
    self view
        renderRemainingAmount: self model remainingAmount printString;
        renderCurrency: self model currency;
        renderErrorMessage: (self model errorMessage ifNil: [ '' ])
]

{ #category : 'rendering' }
TripExpensePaymentFormPresenter >> viewCreated [
    super viewCreated.
    self view
        when: TripExpensePaymentFormAddRequested  send: #onAddPayment:  to: self;
        when: TripExpensePaymentFormHideRequested send: #onHide         to: self
]
