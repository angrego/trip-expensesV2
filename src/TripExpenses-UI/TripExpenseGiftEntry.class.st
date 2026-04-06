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
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
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
	"Une entry est complète si fromId et toId sont définis,
     et si le montant est défini en mode fixe."

	fromId ifNil: [ ^ false ].
	toId ifNil: [ ^ false ].
	mode = #fixed ifTrue: [ ^ amount isNil not and: [ amount > 0 ] ].
	"mode = #share : le montant sera calculé — pas besoin de le vérifier"
	^ true
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
