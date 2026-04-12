Class {
	#name : 'TripLoginPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Login',
	#package : 'TripExpenses-UI',
	#tag : 'Login'
}

{ #category : 'rendering' }
TripLoginPresenter >> onLoginRequested: anAnnouncement [
    self parent model
        loginName: anAnnouncement participantName
        password: anAnnouncement password
]

{ #category : 'rendering' }
TripLoginPresenter >> renderView [
    self view renderErrorMessage: (self model errorMessage ifNil: [ '' ])
]

{ #category : 'rendering' }
TripLoginPresenter >> viewCreated [
    super viewCreated.
    self view when: TripLoginRequested send: #onLoginRequested: to: self
]
