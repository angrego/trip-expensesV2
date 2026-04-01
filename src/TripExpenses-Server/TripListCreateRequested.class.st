"
I am announced when the user submits the create trip form.
I carry the tripName and currency entered by the user.
"
Class {
	#name : 'TripListCreateRequested',
	#superclass : 'Announcement',
	#instVars : [
		'tripName',
		'currency'
	],
	#category : 'TripExpenses-Server',
	#package : 'TripExpenses-Server'
}

{ #category : 'instance creation' }
TripListCreateRequested class >> tripName: aName currency: aCurrency [
	^ self new
		tripName: aName;
		currency: aCurrency;
		yourself
]

{ #category : 'accessing' }
TripListCreateRequested >> currency [

	^ currency
]

{ #category : 'accessing' }
TripListCreateRequested >> currency: anObject [

	currency := anObject
]

{ #category : 'accessing' }
TripListCreateRequested >> tripName [

	^ tripName
]

{ #category : 'accessing' }
TripListCreateRequested >> tripName: anObject [

	tripName := anObject
]
