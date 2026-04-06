Class {
	#name : 'TripDetailGiftModeChanged',
	#superclass : 'Announcement',
	#instVars : [
		'entryId',
		'mode'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'as yet unclassified' }
TripDetailGiftModeChanged class >> entryId: anId mode: aMode [
    ^ self new entryId: anId; mode: aMode; yourself
]

{ #category : 'accessing' }
TripDetailGiftModeChanged >> entryId [

	^ entryId
]

{ #category : 'accessing' }
TripDetailGiftModeChanged >> entryId: anObject [

	entryId := anObject
]

{ #category : 'accessing' }
TripDetailGiftModeChanged >> mode [

	^ mode
]

{ #category : 'accessing' }
TripDetailGiftModeChanged >> mode: anObject [

	mode := anObject
]
