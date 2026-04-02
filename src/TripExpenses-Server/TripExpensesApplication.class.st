"
Je suis l application CodeParadise pour TripExpenses.
URL: http://localhost:8080/static/app.html?app=Voyages

Responsabilites :
  - Tenir le TripApplicationService.
  - Gerer la navigation entre TripListModel et TripDetailModel.
  - applicationModel retourne toujours le MEME objet (pas de recréation).
  - preferredPresenterClass est délégué au modèle courant.

Signal de changement :
  CP utilise self changed (et non self announce: ValueChanged new)
  pour déclencher le swap de presenter quand applicationModel change.
"
Class {
	#name : 'TripExpensesApplication',
	#superclass : 'CpMvpWebApplication',
	#instVars : [
		'service',
		'tripListModel',
		'currentTripDetailModel'
	],
	#category : 'TripExpenses-Server-TripExpenseApplication',
	#package : 'TripExpenses-Server',
	#tag : 'TripExpenseApplication'
}

{ #category : 'accessing' }
TripExpensesApplication class >> app [
	^ #'Voyages'
]

{ #category : 'instance creation' }
TripExpensesApplication class >> onService: aTripApplicationService [
	"Factory principale — utilisée par TripExpensesServerApp et les tests."
	^ self new
		  initializeWithService: aTripApplicationService;
		  yourself
]

{ #category : 'instance creation' }
TripExpensesApplication class >> withSampleData [
	"Raccourci de développement."
	| repo service trip alice bob charlie rule |
	repo := InMemoryTripRepository new.
	service := TripApplicationService withRepository: repo.
	trip := service createTrip: 'Vacances été 2026' currency: 'EUR'.
	alice := service addParticipant: 'Alice' toTrip: trip id.
	bob := service addParticipant: 'Bob' toTrip: trip id.
	charlie := service addParticipant: 'Charlie' toTrip: trip id.
	trip := service findTrip: trip id.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: alice).
			        (ParticipantWeight participant: bob).
			        (ParticipantWeight participant: charlie) }.
	service
		addExpense: (Expense
				 description: 'Restaurant'
				 totalAmount: (Money amount: 90 currency: 'EUR')
				 payments: { (Payment
						  participant: alice
						  amount: (Money amount: 90 currency: 'EUR')) }
				 splitRule: rule
				 gifts: {  }
				 date: Date today)
		toTrip: trip id.
	^ self onService: service
]

{ #category : 'accessing' }
TripExpensesApplication >> applicationModel [
"Retourne le modèle courant. Toujours le MEME objet — pas de recréation à chaque appel."

	^ currentTripDetailModel ifNil: [ tripListModel ]
]

{ #category : 'initialization' }
TripExpensesApplication >> initialize [
	"Appelé par CP à l instanciation.	 En production, TripExpensesServerApp injecte le service via onService:	 donc initialize ne doit PAS créer de données — juste initialiser les variables."

	super initialize.

]

{ #category : 'initialization' }
TripExpensesApplication >> initializeWithService: aTripApplicationService [
	"Point d initialisation principal — reçoit le service injecté."
	service := aTripApplicationService.
	tripListModel := TripListModel onService: service.
	currentTripDetailModel := nil
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToList [
	"Retour vers la liste.	 self changed déclenche le swap de presenter root vers TripListPresenter."

	currentTripDetailModel := nil.
	tripListModel loadTrips.
	self changed
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToTrip: aTripId [
	"Navigue vers le détail d un voyage.	 self changed signale à CP que applicationModel et preferredPresenterClass 	 ont changé → CP swap le presenter root."

	currentTripDetailModel := TripDetailModel
		                          onService: service
		                          tripId: aTripId.
	self changed
]

{ #category : 'accessing' }
TripExpensesApplication >> preferredPresenterClass [
"Délègue au modèle courant — chaque CpModel déclare son presenter."

	^ self applicationModel preferredPresenterClass
]
