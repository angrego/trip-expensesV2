Class {
	#name : 'TripExpensePaymentFormModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripId',
		'expenseId',
		'currentParticipantName',
		'remainingAmount',
		'currency',
		'errorMessage',
		'showing'
	],
	#category : 'TripExpenses-UI-PaymentForm',
	#package : 'TripExpenses-UI',
	#tag : 'PaymentForm'
}

{ #category : 'accessing' }
TripExpensePaymentFormModel >> addPaymentAmount: anAmount [
    | trip participant |
    trip := service findTrip: tripId.
    participant := trip participants
        detect: [ :p | p name = currentParticipantName ]
        ifNone: [ Error signal: 'Participant introuvable' ].
    [
        service
            addPayment: (Payment participant: participant amount: (Money amount: anAmount currency: currency))
            toExpense: expenseId
            inTrip: tripId.
        showing      := false.
        errorMessage := nil ]
    on: Error
    do: [ :e | errorMessage := e messageText ].
    self valueChanged
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> currentParticipantName: aName [
    currentParticipantName := aName
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> errorMessage [
	^ errorMessage
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> expenseId: anId [ 
expenseId:=anId 
]

{ #category : 'operations' }
TripExpensePaymentFormModel >> hide [
    showing := false.
    self valueChanged
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> initialize [
    super initialize.
    showing      := false
]

{ #category : 'testing' }
TripExpensePaymentFormModel >> isShowing [
	^showing 
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> preferredPresenterClass [
    ^ TripExpensePaymentFormPresenter
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> remainingAmount [
	^ remainingAmount
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> service: aService [
    service := aService
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> show [
    | trip expense |
    trip    := service findTrip: tripId.
    expense := trip expenses detect: [ :e | e id = expenseId ].
    remainingAmount := expense remainingAmount amount.
    currency        := trip currency.
    errorMessage    := nil.
    showing         := true.
    self valueChanged
]

{ #category : 'accessing' }
TripExpensePaymentFormModel >> tripId: anId [ 
tripId := anId
]
