Class {
	#name : 'TripAuthServiceTest',
	#superclass : 'TestCase',
	#instVars : [
		'service'
	],
	#category : 'TripExpenses-Application-Tests',
	#package : 'TripExpenses-Application-Tests'
}

{ #category : 'running' }
TripAuthServiceTest >> setUp [
super setUp .
    service := TripAuthService new.
    service addCredential: 'Alice' password: 'alice123'.
    service addCredential: 'Bob'   password: 'bob456'
]

{ #category : 'running' }
TripAuthServiceTest >> testAuthenticateIsCaseSensitive [
    self deny: (service authenticate: 'alice' password: 'alice123')
]

{ #category : 'running' }
TripAuthServiceTest >> testAuthenticateUnknownUser [
    self deny: (service authenticate: 'Charlie' password: 'any')
]

{ #category : 'running' }
TripAuthServiceTest >> testAuthenticateWithCorrectCredentials [
    self assert: (service authenticate: 'Alice' password: 'alice123')
]

{ #category : 'running' }
TripAuthServiceTest >> testAuthenticateWithWrongPassword [
    self deny: (service authenticate: 'Alice' password: 'wrong')
]
