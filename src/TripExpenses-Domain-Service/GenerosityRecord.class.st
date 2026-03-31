Class {
	#name : 'GenerosityRecord',
	#superclass : 'Object',
	#instVars : [
		'theoreticalShare',
		'paymentMade',
		'giftGiven',
		'giftReceived',
		'generosity',
		'finalBalance',
		'participant'
	],
	#category : 'TripExpenses-Domain-Service',
	#package : 'TripExpenses-Domain-Service'
}

{ #category : 'accessing' }
GenerosityRecord >> finalBalance [
	^ finalBalance
]

{ #category : 'accessing' }
GenerosityRecord >> finalBalance: aMoney [ 
finalBalance:= aMoney 
]

{ #category : 'accessing' }
GenerosityRecord >> generosity [
	^ generosity
]

{ #category : 'accessing' }
GenerosityRecord >> generosity: aMoney [ 
	generosity:=aMoney 
]

{ #category : 'accessing' }
GenerosityRecord >> giftGiven [
	^ giftGiven
]

{ #category : 'accessing' }
GenerosityRecord >> giftGiven: aCollection [ 
	giftGiven:= aCollection asOrderedCollection 
]

{ #category : 'accessing' }
GenerosityRecord >> giftReceived [
	^ giftReceived
]

{ #category : 'accessing' }
GenerosityRecord >> giftReceived: aCollection [ 
 giftReceived     := aCollection asOrderedCollection 
]

{ #category : 'testing' }
GenerosityRecord >> isDebtor [
 ^ finalBalance amount < 0
]

{ #category : 'testing' }
GenerosityRecord >> isGenerous [
^ generosity  amount > 0
]

{ #category : 'accessing' }
GenerosityRecord >> participant [
	^participant
]

{ #category : 'accessing' }
GenerosityRecord >> participant: aParticipant [

	participant:= aParticipant
]

{ #category : 'accessing' }
GenerosityRecord >> paymentMade [
	^ paymentMade
]

{ #category : 'accessing' }
GenerosityRecord >> paymentMade: aMoney [ 
paymentMade:= aMoney 
]

{ #category : 'printing' }
GenerosityRecord >> printOn: aStream [

	aStream
		nextPutAll: '--- ';
		nextPutAll: participant name;

		nextPutAll: '  Part théorique : ';
		print: theoreticalShare;

		nextPutAll: '  A payé cash    : ';
		print: paymentMade.
	giftGiven do: [ :g |
			aStream
				nextPutAll: '  Cadeau offert  : ';
				print: g ].
	giftReceived do: [ :g |
			aStream
				nextPutAll: '  Cadeau reçu    : ';
				print: g].
	aStream
		nextPutAll: '  Générosité     : ';
		print: generosity;
		nextPutAll: '  Balance finale : ';
		print: finalBalance
]

{ #category : 'accessing' }
GenerosityRecord >> theoreticalShare [
	^ theoreticalShare
]

{ #category : 'accessing' }
GenerosityRecord >> theoreticalShare: aMoney [ 
	theoreticalShare:= aMoney 
]
