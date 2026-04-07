Class {
	#name : 'TripExpenseGiftEntry',
	#superclass : 'Object',
	#instVars : [
		'entryId',
		'fromId',
		'toId',
		'mode',
		'amount'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'accessing' }
TripExpenseGiftEntry >> amount [

	^ amount
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> amount: anObject [

	amount := anObject
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> entryId [
    ^ entryId
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> fromId [

	^ fromId
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> fromId: anObject [

	fromId := anObject
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> initialize [
    entryId := UUID new asString.
    mode    := #fixed.
    fromId  := nil.
    toId    := nil.
    amount  := nil
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> isComplete [
    fromId ifNil: [ ^ false ].
    mode = #globalShare ifTrue: [ ^ amount isNil not and: [ amount > 0 ] ].
    mode = #fixed ifTrue: [ ^ amount isNil not and: [ amount > 0 ] ].
    "mode = #share : le montant sera calculé"
    ^ toId isNil not
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> mode [

	^ mode
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> mode: anObject [

	mode := anObject
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> toId [

	^ toId
]

{ #category : 'accessing' }
TripExpenseGiftEntry >> toId: anObject [

	toId := anObject
]
