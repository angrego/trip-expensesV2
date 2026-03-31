Class {
	#name : 'Payment',
	#superclass : 'Object',
	#instVars : [
		'participant',
		'amount'
	],
	#category : 'TripExpenses-Domain-ValueObject',
	#package : 'TripExpenses-Domain-ValueObject'
}

{ #category : 'as yet unclassified' }
Payment class >> participant: aParticipant amount: aMoney [ 
	aMoney amount <= 0
        ifTrue: [ Error signal: 'Payment amount must be positive' ].
    ^ self new
        participant: aParticipant;
        amount: aMoney;
        yourself
]

{ #category : 'accessing' }
Payment >> amount [
	^ amount
]

{ #category : 'accessing' }
Payment >> amount: aMoney [ 
	amount:=aMoney.
]

{ #category : 'accessing' }
Payment >> participant [
	^ participant
]

{ #category : 'accessing' }
Payment >> participant: aParticipant [ 
	participant:=aParticipant 
]

{ #category : 'accessing' }
Payment >> printOn: aStream [
    aStream
        nextPutAll: participant name;
        nextPutAll: ' avance ';
        print: amount
]
