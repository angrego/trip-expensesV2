Class {
	#name : 'EqualSplitRule',
	#superclass : 'Object',
	#instVars : [
		'participantWeights'
	],
	#category : 'TripExpenses-Domain-ValueObject',
	#package : 'TripExpenses-Domain-ValueObject'
}

{ #category : 'as yet unclassified' }
EqualSplitRule class >> among: aCollectionOfParticipantWeights [

	aCollectionOfParticipantWeights isEmpty ifTrue: [
		Error signal: 'Split rule must have at least one participant' ].
	^ self new
		  participantWeights:
			  aCollectionOfParticipantWeights asOrderedCollection;
		  yourself
]

{ #category : 'accessing' }
EqualSplitRule >> computeShares: aMoney [
    | total shares assigned |
    total := self totalWeight.
    shares := Dictionary new.
    assigned := Money amount: 0 currency: aMoney currency.
    participantWeights allButLast do: [ :pw |
        | share |
        share := Money
            amount: (aMoney amount * pw weight / total) truncated
            currency: aMoney currency.
        shares at: pw participant put: share.
        assigned := assigned + share ].
    shares
        at: participantWeights last participant
        put: aMoney - assigned.
    ^ shares
]

{ #category : 'testing' }
EqualSplitRule >> includes: aParticipant [ 
	^participantWeights anySatisfy: [ :pw| pw participant=aParticipant ]
]

{ #category : 'accessing' }
EqualSplitRule >> participantWeights [
	^ participantWeights
]

{ #category : 'accessing' }
EqualSplitRule >> participantWeights: aCollection [ 
	participantWeights:=aCollection 
]

{ #category : 'accessing' }
EqualSplitRule >> participants [
	^participantWeights collect:[:pw|pw participant]
]

{ #category : 'printing' }
EqualSplitRule >> printOn: aStream [
    aStream nextPutAll: 'SplitRule('.
    participantWeights doWithIndex: [ :pw :i |
        aStream
            nextPutAll: pw participant name;
            nextPutAll: '=';
            print: pw weight.
        i < participantWeights size
            ifTrue: [ aStream nextPutAll: ', ' ] ].
    aStream nextPutAll: ')'
]

{ #category : 'accessing' }
EqualSplitRule >> totalWeight [
	^ participantWeights sumNumbers: [ :pw|pw weight ]
]
