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
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'instance creation' }
TripExpenseExpenseItemModel class >> fromExpense: anExpense [

	| payer beneficiaries allWeightsOne |
	payer := anExpense payments isEmpty
		         ifTrue: [ '?' ]
		         ifFalse: [ anExpense payments first participant name ].

	allWeightsOne := anExpense splitRule participantWeights allSatisfy: [
		                 :pw | pw weight = 1 ].

	beneficiaries := ', ' join:
		                 (anExpense splitRule participantWeights collect: [
				                  :pw |
				                  allWeightsOne
					                  ifTrue: [ pw participant name ]
					                  ifFalse: [
						 String streamContents: [ :s | s nextPutAll: pw participant name;
                nextPutAll: ' (x';
                nextPutAll: pw weight printString;
                nextPut: $)]]]).
					                  
	^ self new
		  expenseId: anExpense id;
		  description: anExpense description;
		  amount: anExpense totalAmount amount printString;
		  currency: anExpense totalAmount currency;
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
TripExpenseExpenseItemModel >> fromExpense: anExpense currency: aCurrency [
    | payer beneficiaries allWeightsOne |
    payer := anExpense payments isEmpty
        ifTrue:  [ '?' ]
        ifFalse: [ anExpense payments first participant name ].

    allWeightsOne := anExpense splitRule participantWeights
        allSatisfy: [ :pw | pw weight = 1 ].

    beneficiaries := ', ' join:
        (anExpense splitRule participantWeights collect: [ :pw |
            allWeightsOne
                ifTrue:  [ pw participant name ]
                ifFalse: [ pw participant name , ' (x' , pw weight printString , ')' ] ]).

    ^ self new
        expenseId:        anExpense id;
        description:      anExpense description;
        amount:           anExpense totalAmount amount printString;
        currency:         aCurrency;
        date:             anExpense date printString;
        payerName:        payer;
        beneficiaryNames: beneficiaries;
        yourself
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
