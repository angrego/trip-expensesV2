Class {
	#name : 'TripExpenseExpenseItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'expenseId',
		'description',
		'amount',
		'currency',
		'date',
		'payerName',
		'beneficiaryNames'
	],
	#category : 'TripExpenses-Server-ExpenseItem',
	#package : 'TripExpenses-Server',
	#tag : 'ExpenseItem'
}

{ #category : 'instance creation' }
TripExpenseExpenseItemModel class >> fromDict: aDict currency: aCurrency [
	"Conservé pour compatibilité avec les tests existants."
	^ self new
		  setId: (aDict at: 'id')
		  description: (aDict at: 'description')
		  amount: (aDict at: 'amount') printString
		  currency: aCurrency
		  date: (aDict at: 'date' ifAbsent: [ '' ])
		payerName:           (aDict at: 'payerName' ifAbsent: [ '' ])
		beneficiaryNames:    (aDict at: 'beneficiaryNames' ifAbsent: [ '' ]);
		  yourself
]

{ #category : 'instance creation' }
TripExpenseExpenseItemModel class >> fromExpense: anExpense currency: aCurrency [
	"Construit depuis un objet Expense du domaine.
	 Extrait le payeur depuis payments et les beneficiaires depuis splitRule."

	| payer beneficiaries |
	payer := anExpense payments isEmpty
		         ifTrue: [ '?' ]
		         ifFalse: [ anExpense payments first participant name ].
	beneficiaries := ', ' join:
		                 (anExpense splitRule participantWeights collect: [
			                  :pw | pw participant name ]).
	^ self new
		  expenseId: anExpense id;
		  description: anExpense description;
		  amount: anExpense totalAmount amount printString;
		  currency: aCurrency;
		  date: anExpense date printString;
		  payerName: payer;
		  beneficiaryNames: beneficiaries;
		  yourself
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> amount [
	^ amount
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> amount: anObject [

	amount := anObject
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> beneficiaryNames [

	^ beneficiaryNames
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> beneficiaryNames: aString [

	beneficiaryNames := aString
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> currency: anObject [

	currency := anObject
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> date [
	^ date
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> date: anObject [

	date := anObject
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> description [
	^ description
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> description: anObject [

	description := anObject
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> expenseId [
	^ expenseId
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> expenseId: anObject [

	expenseId := anObject
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> payerName [

	^ payerName
]

{ #category : 'accessing' }
TripExpenseExpenseItemModel >> payerName: aString [

payerName :=aString
]

{ #category : 'testing' }
TripExpenseExpenseItemModel >> preferredPresenterClass [
	^ TripExpenseItemPresenter
]

{ #category : 'private - setting' }
TripExpenseExpenseItemModel >> setId: anId description: aDesc amount: anAmount currency: aCurrency date: aDate [
	expenseId := anId.
	description := aDesc.
	amount := anAmount.
	currency := aCurrency.
	date := aDate
]

{ #category : 'private - setting' }
TripExpenseExpenseItemModel >> setId: anId description: aDesc amount: anAmount currency: aCurrency date: aDate payerName: aPayer beneficiaryNames:aBeneficiaries [

	expenseId := anId.
	description := aDesc.
	amount := anAmount.
	currency := aCurrency.
	date := aDate.
	payerName :=aPayer.
	beneficiaryNames :=aBeneficiaries 
]
