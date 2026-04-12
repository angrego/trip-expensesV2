Class {
	#name : 'TripLoginModel',
	#superclass : 'CpModel',
	#instVars : [
		'authService',
		'errorMessage',
		'participantName',
		'authenticated'
	],
	#category : 'TripExpenses-UI-Login',
	#package : 'TripExpenses-UI',
	#tag : 'Login'
}

{ #category : 'as yet unclassified' }
TripLoginModel class >> onAuthService: aTripAuthService [ 
	  ^ self new
        authService: aTripAuthService;
        yourself
]

{ #category : 'announcing' }
TripLoginModel class >> unsubscribe: aTripLoginPresenter [ 

]

{ #category : 'as yet unclassified' }
TripLoginModel >> authService: aTripAuthService [
    authService := aTripAuthService
]

{ #category : 'accessing' }
TripLoginModel >> errorMessage [
	^errorMessage
]

{ #category : 'accessing' }
TripLoginModel >> initialize [

	super initialize.
	participantName := ''.
	authenticated := false
]

{ #category : 'testing' }
TripLoginModel >> isAuthenticated [
	^authenticated 
]

{ #category : 'as yet unclassified' }
TripLoginModel >> loginName: aName password: aPassword [
    (authService authenticate: aName password: aPassword)
        ifTrue: [
            participantName := aName.
            errorMessage    := nil.
            authenticated   := true ]
        ifFalse: [
            errorMessage  := 'Nom ou mot de passe incorrect'.
            authenticated := false ].
    self valueChanged
]

{ #category : 'accessing' }
TripLoginModel >> participantName [
	^participantName
]

{ #category : 'presenter' }
TripLoginModel >> preferredPresenterClass [ 
^TripLoginPresenter 
]
