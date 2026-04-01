Class {
	#name : 'TripExpenseItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'expenseId',
		'description',
		'amount',
		'currency',
		'date'
	],
	#category : 'TripExpenses-Server',
	#package : 'TripExpenses-Server'
}

{ #category : 'instance creation' }
TripExpenseItemModel class >> fromDict: aDict currency: aCurrency [
	^ self new
		setId:          (aDict at: 'id')          "← 'id' pas 'expenseId'"
		description:    (aDict at: 'description')
		amount:         (aDict at: 'amount') printString
		currency:       aCurrency
		date:           (aDict at: 'date' ifAbsent: [ '' ]);
		yourself
]

{ #category : 'accessing' }
TripExpenseItemModel >> amount [ ^ amount
]

{ #category : 'accessing' }
TripExpenseItemModel >> currency [ ^ currency
]

{ #category : 'accessing' }
TripExpenseItemModel >> date [ ^ date
]

{ #category : 'accessing' }
TripExpenseItemModel >> description [ ^ description
]

{ #category : 'accessing' }
TripExpenseItemModel >> expenseId [ ^ expenseId
]

{ #category : 'testing' }
TripExpenseItemModel >> preferredPresenterClass [ ^ TripExpenseItemPresenter
]

{ #category : 'initialization' }
TripExpenseItemModel >> setId: anId description: aDesc amount: anAmount currency: aCurrency date: aDate [
	expenseId   := anId.
	description := aDesc.
	amount      := anAmount.
	currency    := aCurrency.
	date        := aDate
]
