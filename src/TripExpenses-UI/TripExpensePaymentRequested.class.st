Class {
	#name : 'TripExpensePaymentRequested',
	#superclass : 'Announcement',
	#instVars : [
		'expenseId'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'accessing' }
TripExpensePaymentRequested class >> expenseId: aString [
    ^ self new expenseId: aString; yourself
]

{ #category : 'accessing' }
TripExpensePaymentRequested >> expenseId [

	^ expenseId
]

{ #category : 'accessing' }
TripExpensePaymentRequested >> expenseId: anObject [

	expenseId := anObject
]
