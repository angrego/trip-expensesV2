Class {
	#name : 'TripGenerosityModel',
	#superclass : 'CpModel',
	#instVars : [
		'items',
		'service',
		'tripId'
	],
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'instance creation' }
TripGenerosityModel class >> onService: aService tripId: anId [
    ^ self new
        service: aService;
        tripId:  anId;
        yourself
]

{ #category : 'accessing' }
TripGenerosityModel >> items [
	^ items
]

{ #category : 'private - setting' }
TripGenerosityModel >> service: aService [ 
	service:=aService 
]

{ #category : 'private - setting' }
TripGenerosityModel >> tripId: aTripId [ 
	tripId:=aTripId 
]
