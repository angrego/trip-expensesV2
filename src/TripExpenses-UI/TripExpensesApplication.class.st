"
Je suis la CpMvpWebApplication pour TripExpenses.
URL: http://localhost:8080/static/app.html?app=Voyages

Pattern CP correct :
  applicationModel retourne TOUJOURS le MEME objet (appModel : TripAppModel).
  C est TripAppModel qui change d etat et annonce valueChanged.
  TripAppPresenter rerend la bonne sous-vue en consequence.
"
Class {
	#name : 'TripExpensesApplication',
	#superclass : 'CpMvpWebApplication',
	#instVars : [
		'appModel'
	],
	#classVars : [
		'Repository'
	],
	#category : 'TripExpenses-UI-App',
	#package : 'TripExpenses-UI',
	#tag : 'App'
}

{ #category : 'accessing' }
TripExpensesApplication class >> app [
	^ #Voyages
]

{ #category : 'instance creation' }
TripExpensesApplication class >> authService [
    | auth |
    auth := TripAuthService new.
    auth addCredential: 'Greg'    password: 'greg123'.
    auth addCredential: 'Antoine' password: 'antoine123'.
    auth addCredential: 'Malvina' password: 'malvina123'.
    ^ auth
]

{ #category : 'instance creation' }
TripExpensesApplication class >> createRepository [

	| repo service trip malvina greg antoine splitRule exp |
	repo := InMemoryTripRepository new.
	service := TripApplicationService withRepository: repo.
	trip := service createTrip: 'Vacances été 2026' currency: 'EUR'.
	greg := Participant name:'Greg'.
	antoine := Participant name:'Antoine'.
	malvina := Participant name:'Malvina'.
	service addParticipant: greg toTrip: trip id.
	service addParticipant: antoine toTrip: trip id.
	service addParticipant: malvina toTrip: trip id.
	splitRule := EqualSplitRule among: {
			             (ParticipantWeight participant: greg weight: 2).
			             (ParticipantWeight participant: malvina).
			             (ParticipantWeight participant: antoine) }.
	exp := Expense
		       description: 'Gite'
		       totalAmount: (Money amount: 7000 currency: 'EUR')
		       payments: { (Payment
				        participant: malvina
				        amount: (Money amount: 7000 currency: 'EUR')) }
		       splitRule: splitRule
		       gifts: {  }
		       date: Date today.
	service addExpense: exp toTrip: trip id.
	^ repo
]

{ #category : 'instance creation' }
TripExpensesApplication class >> onService: aTripApplicationService [
	^ self basicNew
		  initializeWithService: aTripApplicationService;
		  yourself
]

{ #category : 'instance creation' }
TripExpensesApplication class >> onService: aTripApplicationService authService: aTripAuthService [

	^ self basicNew
		  initializeWithService: aTripApplicationService
		authService: aTripAuthService;
		  yourself
]

{ #category : 'instance creation' }
TripExpensesApplication class >> repository [

	Repository ifNil: [ Repository := self createRepository ].
	^ Repository
]

{ #category : 'instance creation' }
TripExpensesApplication class >> resetRepository [
    "En dev : TripExpensesApplication resetRepository"
    Repository := nil
]

{ #category : 'accessing' }
TripExpensesApplication >> applicationModel [
	^ appModel
]

{ #category : 'navigation' }
TripExpensesApplication >> currentParticipantName [
    ^ appModel currentParticipantName
]

{ #category : 'initialization' }
TripExpensesApplication >> initialize [

    super initialize.
    appModel := TripAppModel
        onService: (TripApplicationService withRepository: self class repository)
        authService: self class authService
]

{ #category : 'initialization' }
TripExpensesApplication >> initializeWithService: aTripApplicationService [
	appModel := TripAppModel onService: aTripApplicationService
]

{ #category : 'initialization' }
TripExpensesApplication >> initializeWithService: aTripApplicationService authService: aTripAuthService [
    appModel := TripAppModel
        onService: aTripApplicationService
        authService: aTripAuthService
]

{ #category : 'navigation' }
TripExpensesApplication >> load [
	super load.

	self inspect
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToList [
	appModel navigateToList
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToTrip: aTripId [
	appModel navigateToTrip: aTripId
]

{ #category : 'navigation' }
TripExpensesApplication >> preferredPresenterClass [
    "Le presenter racine est toujours TripAppPresenter.
     Ne pas déléguer à applicationModel — cette méthode est appelée
     par CP avant que appModel soit initialisé."
    ^ TripAppPresenter
]
