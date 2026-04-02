"
Je teste TripExpensesServerApp dans son rôle de vraie CpServerApplication.

Contrats vérifiés :
  1. Identifiant CP cohérent avec TripExpensesApplication.
  2. Crée un TripExpensesApplication (CpMvpWebApplication) côté serveur.
  3. Cette application reçoit bien un TripApplicationService.
  4. withRepository: permet l injection pour les tests.
  5. Ne confond pas son rôle avec celui du service domaine
     (pas de handleMessage: ni de logique métier directe).

Note : install et installViews/installAnnouncements ne sont pas testables
sans runtime CP — on vérifie le contrat structurel, pas le rendu.
"
Class {
	#name : 'TripExpensesServerAppV2Test',
	#superclass : 'TestCase',
	#instVars : [
		'serverApp'
	],
	#category : 'TripExpenses-Server-tests',
	#package : 'TripExpenses-Server-tests'
}

{ #category : 'running' }
TripExpensesServerAppV2Test >> setUp [
	serverApp := TripExpensesServerApp withRepository: InMemoryTripRepository new
]

{ #category : 'tests - identité CP' }
TripExpensesServerAppV2Test >> testAppIdentifierIsASymbol [
	self assert: (TripExpensesServerApp app isKindOf: Symbol)
]

{ #category : 'tests - identité CP' }
TripExpensesServerAppV2Test >> testAppIdentifierIsNotEmpty [
	self deny: TripExpensesServerApp app isEmpty
]

{ #category : 'tests - identité CP' }
TripExpensesServerAppV2Test >> testAppIdentifierMatchesApplication [
	"Les deux classes partagent le même #app — CP les associe via cet identifiant."
	self assert: TripExpensesServerApp app
	     equals:  TripExpensesApplication app
]

{ #category : 'tests - rôle minimal' }
TripExpensesServerAppV2Test >> testDoesNotRespondToHandleMessage [
	"La couche JSON handleMessage: est supprimée —
	 la logique métier passe par TripApplicationService, pas par la server app."
	self deny: (TripExpensesServerApp respondsTo: #handleMessage:)
]

{ #category : 'tests - session' }
TripExpensesServerAppV2Test >> testMvpApplicationHasATripListModelInitially [
	"Après initialisation, le modèle courant est une liste de voyages."
	self assert: (serverApp application applicationModel isKindOf: TripListModel)
]

{ #category : 'tests - session' }
TripExpensesServerAppV2Test >> testMvpApplicationIsNotNil [
	self assert: serverApp application isNotNil
]

{ #category : 'tests - rôle minimal' }
TripExpensesServerAppV2Test >> testRespondsToInstall [
	"install est la méthode centrale d une CpServerApplication."
	self assert: (serverApp respondsTo: #install)
]

{ #category : 'tests - rôle minimal' }
TripExpensesServerAppV2Test >> testRespondsToInstallAnnouncements [
	self assert: (serverApp respondsTo: #installAnnouncements)
]

{ #category : 'tests - rôle minimal' }
TripExpensesServerAppV2Test >> testRespondsToInstallViews [
	self assert: (serverApp respondsTo: #installViews)
]

{ #category : 'tests - session' }
TripExpensesServerAppV2Test >> testServerAppCreatesAMvpApplication [
	"La session doit avoir une TripExpensesApplication prête côté serveur."
	self assert: (serverApp application isKindOf: TripExpensesApplication)
]

{ #category : 'tests - session' }
TripExpensesServerAppV2Test >> testTwoSessionsAreIndependent [
	"Deux instances de TripExpensesServerApp sont des sessions indépendantes —
	 elles ont chacune leur propre TripExpensesApplication."
	| session1 session2 |
	session1 := TripExpensesServerApp withRepository: InMemoryTripRepository new.
	session2 := TripExpensesServerApp withRepository: InMemoryTripRepository new.
	self deny: session1 application == session2 application
]

{ #category : 'tests - repository' }
TripExpensesServerAppV2Test >> testTwoSessionsWithSharedRepositoryShareData [
	"Deux sessions avec le MÊME repository voient les mêmes données —
	 c'est le comportement de production (STONTripRepository partagé)."
	| sharedRepo session1 session2 |
	sharedRepo := InMemoryTripRepository new.
	session1 := TripExpensesServerApp withRepository: sharedRepo.
	session2 := TripExpensesServerApp withRepository: sharedRepo.
	"Session 1 crée un voyage"
	session1 application applicationModel createTripNamed: 'Vacances' currency: 'EUR'.
	"Session 2 recharge — doit voir le voyage créé par session 1"
	session2 application applicationModel loadTrips.
	self assert: session2 application applicationModel trips size equals: 1
]

{ #category : 'tests - rôle minimal' }
TripExpensesServerAppV2Test >> testUsesInstallClassForAnnouncements [
	| methods |
	methods := (TripExpensesServerApp >> #installAnnouncements) messages.
	self assert: (methods includes: #installClass:)
]

{ #category : 'tests - rôle minimal' }
TripExpensesServerAppV2Test >> testUsesInstallClassForViews [
	"installViews doit utiliser installClass: — vérification via le sélecteur
	 des méthodes envoyées dans installViews."
	| methods |
	methods := (TripExpensesServerApp >> #installViews) messages.
	self assert: (methods includes: #installClass:)
]

{ #category : 'tests - repository' }
TripExpensesServerAppV2Test >> testWithRepositoryUsesGivenRepository [
	"Les voyages créés via le service doivent être visibles via l application MVP."
	| repo trip |
	repo := InMemoryTripRepository new.
	serverApp := TripExpensesServerApp withRepository: repo.
	"On crée un voyage directement dans le repository partagé"
	trip := Trip name: 'Test' currency: 'EUR'.
	repo save: trip.
	"L application doit le voir via loadTrips"
	serverApp application applicationModel loadTrips.
	self assert: serverApp application applicationModel trips size equals: 1
]
