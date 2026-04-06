Class {
	#name : 'Money',
	#superclass : 'Object',
	#instVars : [
		'amount',
		'currency'
	],
	#category : 'TripExpenses-Domain-TripExpenses-Domain-ValueObject',
	#package : 'TripExpenses-Domain',
	#tag : 'TripExpenses-Domain-ValueObject'
}

{ #category : 'as yet unclassified' }
Money class >> amount: aNumber currency: aString [

^self new
amount: aNumber;
currency: aString ;
yourself
]

{ #category : 'arithmetic' }
Money >> * aFactor [ 
    ^ Money amount: amount * aFactor currency: currency
]

{ #category : 'arithmetic' }
Money >> + aMoney [ 
self currency = aMoney currency
        ifFalse: [ Error signal: 'Cannot add different currencies' ].
    ^ Money amount: amount + aMoney amount currency: currency
]

{ #category : 'arithmetic' }
Money >> - aMoney [

	self currency = aMoney currency ifFalse: [
		Error signal: 'Cannot add different currencies' ].
	^ Money amount: amount - aMoney amount currency: currency
]

{ #category : 'arithmetic' }
Money >> = other [

	self class = other class ifFalse: [
		^ false].

	^ amount = other amount and: [ currency = other currency ]
]

{ #category : 'accessing' }
Money >> abs [
^ Money amount: amount abs currency: currency
]

{ #category : 'accessing' }
Money >> amount [
	^ amount
]

{ #category : 'accessing' }
Money >> amount: aNumber [

amount:=aNumber 
]

{ #category : 'accessing' }
Money >> currency [
	^ currency
]

{ #category : 'accessing' }
Money >> currency: aString [

currency:=aString
]

{ #category : 'arithmetic' }
Money >> hash [ 
    ^ amount hash bitXor: currency hash
]

{ #category : 'testing' }
Money >> isNegative [
	^amount<0
]

{ #category : 'testing' }
Money >> isPositive [
^amount>0
]

{ #category : 'testing' }
Money >> isZero [
	^amount=0
]

{ #category : 'accessing' }
Money >> printOn: aStream [ 
    aStream print: amount; space; nextPutAll: currency
]

{ #category : 'accessing' }
Money >> roundedToCents [
    ^ Money amount: (amount roundTo: 0.01) currency: currency
]
