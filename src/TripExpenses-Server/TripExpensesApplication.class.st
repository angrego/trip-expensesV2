"
Je suis l'application CodeParadise pour TripExpenses.
URL: http://localhost:8080/static/app.html?trip-expenses

Responsabilités :
  - Tenir le TripApplicationService.
  - Gérer la navigation entre TripListModel et TripDetailModel.
  - applicationModel retourne toujours le MÊME objet (pas de recréation).
  - preferredPresenterClass est délégué au modèle courant (pattern CP standard).

Ce que je ne fais PAS :
  - Connaître TripExpensesServerApp.
  - Construire des Dictionary JSON.
  - Recréer un modèle à chaque appel de applicationModel.
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
	"Factory pour les tests — injecte le service sans passer par initialize."
	^ self new
		initializeWithService: aTripApplicationService;
		yourself
]

{ #category : 'instance creation' }
TripExpensesApplication class >> withSampleData [
	"Raccourci de développement — crée un service avec des données d exemple."
	| repo service trip alice bob charlie rule |
	repo    := InMemoryTripRepository new.
	service := TripApplicationService withRepository: repo.
	trip    := service createTrip: 'Vacances été 2026' currency: 'EUR'.
	alice   := service addParticipant: 'Alice'   toTrip: trip id.
	bob     := service addParticipant: 'Bob'     toTrip: trip id.
	charlie := service addParticipant: 'Charlie' toTrip: trip id.
	trip    := service findTrip: trip id.
	rule    := EqualSplitRule among: {
		ParticipantWeight participant: alice.
		ParticipantWeight participant: bob.
		ParticipantWeight participant: charlie }.
	service addExpense: (Expense
		description: 'Restaurant'
		totalAmount: (Money amount: 90 currency: 'EUR')
		payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
		splitRule: rule gifts: {} date: Date today) toTrip: trip id.
	^ self onService: service
]

{ #category : 'accessing' }
TripExpensesApplication >> applicationModel [
	"Retourne le modèle courant selon l état de navigation.
	 Toujours le MÊME objet — pas de recréation à chaque appel."
	^ currentTripDetailModel ifNil: [ tripListModel ]
]

{ #category : 'initialization' }
TripExpensesApplication >> initialize [
	"Appelé par CP après instanciation.
	 Utilise withSampleData pour le développement — remplacer par onService: en production."
	super initialize.
	self initializeWithService: (TripApplicationService withRepository: InMemoryTripRepository new)
]

{ #category : 'initialization' }
TripExpensesApplication >> initializeWithService: aTripApplicationService [
	"Point d initialisation testable — reçoit le service sans créer TripExpensesServerApp."
	service               := aTripApplicationService.
	tripListModel         := TripListModel onService: service.
	currentTripDetailModel := nil
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToList [
	"Retour vers la liste — détruit le modèle détail et recharge les voyages."
	currentTripDetailModel := nil.
	tripListModel loadTrips.
	self announce: ValueChanged new
]

{ #category : 'navigation' }
TripExpensesApplication >> navigateToTrip: aTripId [
	"Unique point d entrée pour naviguer vers un voyage.
	 Crée (une seule fois) le TripDetailModel et annonce le changement à CP."
	currentTripDetailModel := TripDetailModel onService: service tripId: aTripId.
	self announce: ValueChanged new
]

{ #category : 'accessing' }
TripExpensesApplication >> preferredPresenterClass [
	"Délègue au modèle courant — c est lui qui connaît son presenter.
	 Pattern CP standard : chaque CpModel déclare preferredPresenterClass."
	^ self applicationModel preferredPresenterClass
]
