Class {
	#name : 'TripLoginModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'authService'
	],
	#category : 'TripExpenses-UI-Tests-TripList',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripList'
}

{ #category : 'running' }
TripLoginModelTest >> setUp [
super setUp .
    authService := TripAuthService new.
    authService addCredential: 'Alice' password: 'alice123'.
    authService addCredential: 'Bob'   password: 'bob456'.
    model := TripLoginModel onAuthService: authService
]

{ #category : 'running' }
TripLoginModelTest >> testInitialErrorIsNil [
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripLoginModelTest >> testInitialParticipantNameIsEmpty [
    self assert: model participantName isEmpty
]

{ #category : 'running' }
TripLoginModelTest >> testInitiallyNotAuthenticated [
    self deny: model isAuthenticated
]

{ #category : 'running' }
TripLoginModelTest >> testLoginAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model loginName: 'Alice' password: 'alice123'.
    self assert: announced
]

{ #category : 'running' }
TripLoginModelTest >> testLoginStoresParticipantName [
    model loginName: 'Alice' password: 'alice123'.
    self assert: model participantName equals: 'Alice'
]

{ #category : 'running' }
TripLoginModelTest >> testLoginWithCorrectCredentials [
    model loginName: 'Alice' password: 'alice123'.
    self assert: model isAuthenticated
]

{ #category : 'running' }
TripLoginModelTest >> testLoginWithCorrectCredentialsClearsError [
    model loginName: 'Alice' password: 'wrong'.
    model loginName: 'Alice' password: 'alice123'.
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripLoginModelTest >> testLoginWithWrongPassword [
    model loginName: 'Alice' password: 'wrong'.
    self deny: model isAuthenticated
]

{ #category : 'running' }
TripLoginModelTest >> testLoginWithWrongPasswordSetsError [
    model loginName: 'Alice' password: 'wrong'.
    self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripLoginModelTest >> testPreferredPresenterClass [
    self
        assert: model preferredPresenterClass
        equals: TripLoginPresenter
]
