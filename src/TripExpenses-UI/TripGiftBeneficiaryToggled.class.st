Class {
	#name : 'TripGiftBeneficiaryToggled',
	#superclass : 'Announcement',
	#instVars : [
		'participantId',
		'included'
	],
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'as yet unclassified' }
TripGiftBeneficiaryToggled class >> participantId: aString included: aBoolean [
    ^ self new participantId: aString; included: aBoolean; yourself
]

{ #category : 'accessing' }
TripGiftBeneficiaryToggled >> included [

	^ included
]

{ #category : 'accessing' }
TripGiftBeneficiaryToggled >> included: anObject [

	included := anObject
]

{ #category : 'accessing' }
TripGiftBeneficiaryToggled >> participantId [

	^ participantId
]

{ #category : 'accessing' }
TripGiftBeneficiaryToggled >> participantId: anObject [

	participantId := anObject
]
