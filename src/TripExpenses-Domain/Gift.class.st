Class {
	#name : 'Gift',
	#superclass : 'Object',
	#instVars : [
		'from',
		'to',
		'amount',
		'reason'
	],
	#category : 'TripExpenses-Domain-TripExpenses-Domain-Rule',
	#package : 'TripExpenses-Domain',
	#tag : 'TripExpenses-Domain-Rule'
}

{ #category : 'instance creation' }
Gift class >> from: aParticipant to: aParticipant2 amount: aMoney [ 
	^self
	from: aParticipant
        to: aParticipant2
        amount: aMoney
        reason: ''
]

{ #category : 'instance creation' }
Gift class >> from: aParticipant to: aParticipant2 amount: aMoney reason: aString [
    ^ self new
        from: aParticipant;
        to: aParticipant2;
        amount: aMoney;
        reason: aString;
        yourself
]

{ #category : 'accessing' }
Gift >> amount [
	^ amount
]

{ #category : 'accessing' }
Gift >> amount: aMoney [ 
	amount:=aMoney 
]

{ #category : 'accessing' }
Gift >> from [
	^ from
]

{ #category : 'instance creation' }
Gift >> from: aParticipant [ 
	from:=aParticipant 
]

{ #category : 'accessing' }
Gift >> printOn: aStream [
    aStream
        nextPutAll: from name;
        nextPutAll: ' offre ';
        print: amount;
        nextPutAll: ' à ';
        nextPutAll: to name.
    reason isEmpty ifFalse: [
        aStream nextPutAll: ' ('; nextPutAll: reason; nextPutAll: ')' ]
]

{ #category : 'accessing' }
Gift >> reason [
	^ reason
]

{ #category : 'accessing' }
Gift >> reason: aString [ 
	reason:=aString 
]

{ #category : 'accessing' }
Gift >> to [
	^ to
]

{ #category : 'accessing' }
Gift >> to: aParticipant [ 
	to:=aParticipant 
]

{ #category : 'accessing' }
Gift >> validateIn: anExpense [
    amount amount <= 0
        ifTrue: [ Error signal: 'Gift amount must be positive' ].
    (anExpense payers includes: from)
        ifFalse: [ Error signal: from name , ' ne paie rien dans cette dépense' ].
    (anExpense splitRule includes: to)
        ifFalse: [ Error signal: to name , ' n''est pas dans le split' ].
    amount amount > (anExpense rawBalanceFor: from) amount
        ifTrue: [ Error signal: 'Cannot gift more than your surplus' ]
]

{ #category : 'as yet unclassified' }
Gift >> validateIn: anExpense givenByPayer: givenByPayer [
    | alreadyGiven surplus | 
   amount amount <= 0
        ifTrue: [ Error signal: 'Gift amount must be positive' ].
    (anExpense payers includes: from)
        ifFalse: [ Error signal: from name , ' ne paie rien dans cette dépense' ].
    (anExpense splitRule includes: to)
        ifFalse: [ Error signal: to name , ' n''est pas dans le split' ].

    alreadyGiven := givenByPayer at: from ifAbsent: [ 0 ].
    surplus := (anExpense rawBalanceFor: from) amount.
    (amount amount + alreadyGiven) > surplus
        ifTrue: [ Error signal: from name , ' ne peut pas offrir plus que son surplus' ].
    givenByPayer at: from put: alreadyGiven + amount amount
]
