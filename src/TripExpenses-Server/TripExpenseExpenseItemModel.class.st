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
	"Conservé pour compatibilité avec les tests existants."
	^ self new
		setId:          (aDict at: 'id')
		description:    (aDict at: 'description')
		amount:         (aDict at: 'amount') printString
		currency:       aCurrency
		date:           (aDict at: 'date' ifAbsent: [ '' ]);
		yourself
]

{ #category : 'instance creation' }
TripExpenseExpenseItemModel class >> fromExpense: anExpense currency: aCurrency [
	"Construit depuis un objet Expense du domaine.
	 Le montant est stocké en String pour la vue (CP ne sérialise que des String/Boolean)."
	^ self new
		setId:          anExpense id
		description:    anExpense description
		amount:         anExpense totalAmount amount printString
		currency:       aCurrency
		date:           anExpense date printString;
		yourself
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> amount [
	^ amount
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> date [
	^ date
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> description [
	^ description
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> expenseId [
	^ expenseId
]

{ #category : 'testing' }
TripExpenseExpenseItemModel >> preferredPresenterClass [
	^ TripExpenseItemPresenter
]

{ #category : 'private - setting' }
TripExpenseExpenseItemModel >> setId: anId description: aDesc amount: anAmount currency: aCurrency date: aDate [
	expenseId   := anId.
	description := aDesc.
	amount      := anAmount.
	currency    := aCurrency.
	date        := aDate
]
