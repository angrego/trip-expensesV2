Class {
	#name : 'TripAuthService',
	#superclass : 'Object',
	#instVars : [
		'credentials'
	],
	#category : 'TripExpenses-Application',
	#package : 'TripExpenses-Application'
}

{ #category : 'adding' }
TripAuthService >> addCredential: aName password: aPassword [
    credentials at: aName put: aPassword
]

{ #category : 'as yet unclassified' }
TripAuthService >> authenticate: aName password: aPassword [
    ^ (credentials at: aName ifAbsent: [ ^ false ]) = aPassword
]

{ #category : 'adding' }
TripAuthService >> initialize [
    super initialize.
    credentials := Dictionary new
]
