Class {
	#name : 'TripExpensePayerChanged',
	#superclass : 'Announcement',
	#instVars : [
		'payerId'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'accessing' }
TripExpensePayerChanged class >> payerId: aString [
    ^ self new payerId: aString; yourself
]

{ #category : 'accessing' }
TripExpensePayerChanged >> payerId [

	^ payerId
]

{ #category : 'accessing' }
TripExpensePayerChanged >> payerId: anObject [

	payerId := anObject
]
