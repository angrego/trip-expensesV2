Class {
	#name : 'TripExpenseGiftAddRequested',
	#superclass : 'Announcement',
	#instVars : [
		'expenseId'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'accessing' }
TripExpenseGiftAddRequested class >> expenseId: anExpenseID [
^self new expenseId: anExpenseID;
yourself
]

{ #category : 'accessing' }
TripExpenseGiftAddRequested >> expenseId [

	^ expenseId
]

{ #category : 'accessing' }
TripExpenseGiftAddRequested >> expenseId: anObject [

	expenseId := anObject
]
