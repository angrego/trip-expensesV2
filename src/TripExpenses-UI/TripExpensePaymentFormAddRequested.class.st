Class {
	#name : 'TripExpensePaymentFormAddRequested',
	#superclass : 'Announcement',
	#instVars : [
		'amount'
	],
	#category : 'TripExpenses-UI-PaymentForm',
	#package : 'TripExpenses-UI',
	#tag : 'PaymentForm'
}

{ #category : 'accessing' }
TripExpensePaymentFormAddRequested class >> amount: aNumber [
    ^ self new amount: aNumber; yourself
]

{ #category : 'accessing' }
TripExpensePaymentFormAddRequested >> amount [

	^ amount
]

{ #category : 'accessing' }
TripExpensePaymentFormAddRequested >> amount: anObject [

	amount := anObject
]
