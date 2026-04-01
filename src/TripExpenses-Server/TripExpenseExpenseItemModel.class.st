Class {
	#name : 'TripExpenseExpenseItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'expenseId',
		'description',
		'amount',
		'currency',
		'date'
	],
	#category : 'TripExpenses-Server-ExpenseItem',
	#package : 'TripExpenses-Server',
	#tag : 'ExpenseItem'
}

{ #category : 'instance creation' }
TripExpenseExpenseItemModel class >> fromDict: aDict currency: aCurrency [
	^ self new
		setId:          (aDict at: 'id')          "← 'id' pas 'expenseId'"
		description:    (aDict at: 'description')
		amount:         (aDict at: 'amount') printString
		currency:       aCurrency
		date:           (aDict at: 'date' ifAbsent: [ '' ]);
		yourself
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> amount [ ^ amount
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> currency [ ^ currency
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> date [ ^ date
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> description [ ^ description
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> expenseId [ ^ expenseId
]

{ #category : 'testing' }
TripExpenseExpenseItemModel >> preferredPresenterClass [ ^ TripExpenseItemPresenter
]

{ #category : 'initialization' }
TripExpenseExpenseItemModel >> setId: anId description: aDesc amount: anAmount currency: aCurrency date: aDate [
	expenseId   := anId.
	description := aDesc.
	amount      := anAmount.
	currency    := aCurrency.
	date        := aDate
]
