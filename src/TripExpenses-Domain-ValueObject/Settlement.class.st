Class {
	#name : 'Settlement',
	#superclass : 'Object',
	#instVars : [
		'from',
		'to',
		'amount'
	],
	#category : 'TripExpenses-Domain-ValueObject',
	#package : 'TripExpenses-Domain-ValueObject'
}

{ #category : 'instance creation' }
Settlement class >> from: aParticipant to: aParticipant2 amount: aMoney [ 
^ self new
        from:   aParticipant;
        to:     aParticipant2;
        amount: aMoney;
        yourself
]

{ #category : 'accessing' }
Settlement >> amount [
	^ amount
]

{ #category : 'accessing' }
Settlement >> amount: aMoney [ 
	amount:=aMoney 
]

{ #category : 'accessing' }
Settlement >> from [
	^ from
]

{ #category : 'instance creation' }
Settlement >> from: aParticipant [ 
	from:= aParticipant 
]

{ #category : 'accessing' }
Settlement >> printOn: aStream [
    aStream
        nextPutAll: from name;
        nextPutAll: ' doit payer ';
        print: amount;
        nextPutAll: ' à ';
        nextPutAll: to name
]

{ #category : 'accessing' }
Settlement >> to [
	^ to
]

{ #category : 'accessing' }
Settlement >> to: aParticipant [ 
to:= aParticipant 
]
