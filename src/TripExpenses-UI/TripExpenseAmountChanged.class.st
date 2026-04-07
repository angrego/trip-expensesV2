Class {
	#name : 'TripExpenseAmountChanged',
	#superclass : 'Announcement',
	#instVars : [
		'amount'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'accessing' }
TripExpenseAmountChanged class >> amount: aNumber [
^self new amount:aNumber;yourself .
]

{ #category : 'accessing' }
TripExpenseAmountChanged >> amount [

	^ amount
]

{ #category : 'accessing' }
TripExpenseAmountChanged >> amount: anObject [

	amount := anObject
]
