Class {
	#name : 'Expense',
	#superclass : 'Object',
	#instVars : [
		'id',
		'description',
		'totalAmount',
		'payments',
		'splitRule',
		'gifts',
		'date',
		'tags'
	],
	#category : 'TripExpenses-Domain-TripExpenses-Domain-Model',
	#package : 'TripExpenses-Domain',
	#tag : 'TripExpenses-Domain-Model'
}

{ #category : 'as yet unclassified' }
Expense class >> description: aString totalAmount: aMoney payments: aCollectionOfPayments splitRule: aSplitRule gifts: aCollectionOfGifts date: aDate [

	| expense givenByPayer |
	self validateDescription: aString.
	self validatePayments: aCollectionOfPayments totalAmount: aMoney.
	expense := self new
		           id: UUID new asString;
		           description: aString;
		           totalAmount: aMoney;
		           payments: aCollectionOfPayments asOrderedCollection;
		           splitRule: aSplitRule;
		           gifts: aCollectionOfGifts asOrderedCollection;
		           date: aDate;
		           tags: Set new;
		           yourself.
	givenByPayer := Dictionary new.
	aCollectionOfGifts do: [ :g |
		g validateIn: expense givenByPayer: givenByPayer ].
	^ expense
]

{ #category : 'as yet unclassified' }
Expense class >> validateDescription: aString [
    (aString isNil or: [ aString trim isEmpty ])
        ifTrue: [ Error signal: 'Description cannot be blank' ]
]

{ #category : 'as yet unclassified' }
Expense class >> validatePayments: payments totalAmount: total [

 | paid |
    payments isEmpty
        ifTrue: [ Error signal: 'At least one payment is required' ].
    paid := payments sumNumbers: [ :p | p amount amount ].
    paid = total amount ifFalse: [
        Error signal: 'Payments (' , paid printString ,
            ') do not match total (' , total amount printString , ')' ]
]

{ #category : 'adding' }
Expense >> addTag: aString [ 
	tags add: aString 
]

{ #category : 'accessing' }
Expense >> balanceFor: aParticipant [

 ^ (self rawBalanceFor: aParticipant) + (self giftEffectFor: aParticipant)
]

{ #category : 'accessing' }
Expense >> date [
	^ date
]

{ #category : 'accessing' }
Expense >> date: aDate [ 
	date:=aDate 
]

{ #category : 'accessing' }
Expense >> description [
	^ description
]

{ #category : 'accessing' }
Expense >> description: aString [ 
	description:=aString 
]

{ #category : 'as yet unclassified' }
Expense >> generosityFor: aParticipant [

| given |
    given := (gifts select: [ :g | g from = aParticipant ])
                 sumNumbers: [ :g | g amount amount ].
    ^ Money amount: given currency: totalAmount currency
]

{ #category : 'accessing' }
Expense >> generosityRecords [

	| participants |
	participants := Set new.

	participants addAll: (payments collect: [ :p | p participant ]).
	participants addAll:
		(splitRule participantWeights collect: [ :pw | pw participant ]).

	^ participants collect: [ :p |
			  GenerosityRecord new
				  participant: p;
				  theoreticalShare: (self theoreticalShares
						   at: p
						   ifAbsent: [ Money amount: 0 currency: totalAmount currency ]);
				  paymentMade: (self paidBy: p);
				  giftGiven: (gifts select: [ :g | g from = p ]);
				  giftReceived: (gifts select: [ :g | g to = p ]);
				  generosity: (self generosityFor: p);
				  finalBalance: (self balanceFor: p);
				  yourself ]
]

{ #category : 'accessing' }
Expense >> giftEffectFor: aParticipant [ 
| received given |
received := (gifts select: [ :g | g to   = aParticipant ])
                    sumNumbers: [ :g | g amount amount ].
    given    := (gifts select: [ :g | g from = aParticipant ])
                    sumNumbers: [ :g | g amount amount ].
    ^ Money amount: received - given currency: totalAmount currency
]

{ #category : 'accessing' }
Expense >> gifts [
	^ gifts
]

{ #category : 'as yet unclassified' }
Expense >> gifts: aCollection [ 
	gifts:=aCollection 
]

{ #category : 'testing' }
Expense >> hasTag: aString [

	^tags includes: aString
]

{ #category : 'accessing' }
Expense >> id [
	^ id
]

{ #category : 'accessing' }
Expense >> id: anId [ 
	id:=anId 
]

{ #category : 'as yet unclassified' }
Expense >> paidBy: aParticipant [ 
	payments
        detect: [ :p | p participant = aParticipant ]
        ifFound: [ :p | ^ p amount ]
        ifNone: [ ^ Money amount: 0 currency: totalAmount currency ]
]

{ #category : 'accessing' }
Expense >> payers [
	^payments collect: [ :p | p participant ]
]

{ #category : 'accessing' }
Expense >> payments [
	^ payments
]

{ #category : 'accessing' }
Expense >> payments: aCollection [ 
	payments:=aCollection .
]

{ #category : 'accessing' }
Expense >> rawBalanceFor: aParticipant [ 
| paid share |
    paid  := self paidBy: aParticipant.
    share := self theoreticalShares
        at: aParticipant
        ifAbsent: [ Money amount: 0 currency: totalAmount currency ].
    ^ paid - share
]

{ #category : 'accessing' }
Expense >> splitRule [
	^ splitRule
]

{ #category : 'as yet unclassified' }
Expense >> splitRule: aSplitRule [ 
splitRule:=aSplitRule 
]

{ #category : 'accessing' }
Expense >> tags [
	^ tags
]

{ #category : 'accessing' }
Expense >> tags: aSet [
tags:=aSet.
]

{ #category : 'accessing' }
Expense >> theoreticalShares [
^ splitRule computeShares: totalAmount
]

{ #category : 'accessing' }
Expense >> totalAmount [
	^ totalAmount
]

{ #category : 'accessing' }
Expense >> totalAmount: aMoney [ 
	totalAmount:=aMoney 
]
