"
I am announced when the user selects a trip from the list.
I carry the tripId of the selected trip.
"
Class {
	#name : 'TripListTripSelected',
	#superclass : 'Announcement',
	#instVars : [
		'tripId'
	],
	#category : 'TripExpenses-Server-TripList',
	#package : 'TripExpenses-Server',
	#tag : 'TripList'
}

{ #category : 'accessing' }
TripListTripSelected class >> tripId: anId [
	^ self new
		tripId: anId;
		yourself
]

{ #category : 'accessing' }
TripListTripSelected >> tripId [

	^ tripId
]

{ #category : 'accessing' }
TripListTripSelected >> tripId: anObject [

	tripId := anObject
]
