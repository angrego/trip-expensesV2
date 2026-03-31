Class {
	#name : 'STONTripRepository',
	#superclass : 'Object',
	#instVars : [
		'filePath'
	],
	#category : 'TripExpenses-Infrastructure',
	#package : 'TripExpenses-Infrastructure'
}

{ #category : 'as yet unclassified' }
STONTripRepository class >> default [
    ^ self onFile: 'trip-expenses.ston' asFileReference
]

{ #category : 'as yet unclassified' }
STONTripRepository class >> onFile: aFileReference [

	^ self new
		  filePath: aFileReference;
		  yourself
]

{ #category : 'as yet unclassified' }
STONTripRepository >> allTrips [
    ^ self findAll
]

{ #category : 'accessing' }
STONTripRepository >> deleteById: anId [
    | all |
    all := self findAll reject: [ :t | t id = anId ].
    filePath writeStreamDo: [ :s | STON put: all onStream: s ]
]

{ #category : 'accessing' }
STONTripRepository >> filePath [ 
 ^ filePath 
]

{ #category : 'accessing' }
STONTripRepository >> filePath: aRef [

	filePath := aRef
]

{ #category : 'accessing' }
STONTripRepository >> findAll [
    filePath exists ifFalse: [ ^ OrderedCollection new ].
    ^ filePath readStreamDo: [ :s | STON fromStream: s ]
]

{ #category : 'accessing' }
STONTripRepository >> findById: anId [
    ^ self findAll
        detect: [ :t | t id = anId ]
        ifNone: [ Error signal: 'Trip not found: ' , anId ]
]

{ #category : 'accessing' }
STONTripRepository >> save: aTrip [ 
    | all |
    all := self findAll.
    all := all reject: [ :t | t id = aTrip id ].
    all add: aTrip.
    filePath writeStreamDo: [ :s |
        STON put: all onStream: s ]
]
