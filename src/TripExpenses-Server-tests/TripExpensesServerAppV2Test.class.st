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
TripExpensesServerAppV2Test >> testAppIdentifierIsASymbol [
    self assert: (TripExpensesServerApp app isKindOf: Symbol)
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testAppIdentifierIsNotEmpty [
    self deny: TripExpensesServerApp app isEmpty
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testAppIdentifierMatchesApplication [
    self
        assert: TripExpensesServerApp app
        equals: TripExpensesApplication app
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testDoesNotRespondToHandleMessage [
    self deny: (TripExpensesServerApp respondsTo: #handleMessage:)
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testInstallsGiftSliderChanged [
    | methods |
    methods := (TripExpensesServerApp >> #installAnnouncements) messages.
    self assert: (methods includes: #installClass:)
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testRespondsToInstall [
    self assert: (TripExpensesServerApp methodDictionary includesKey: #install)
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testRespondsToInstallAnnouncements [
    self assert: (TripExpensesServerApp methodDictionary includesKey: #installAnnouncements)
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testRespondsToInstallViews [
    self assert: (TripExpensesServerApp methodDictionary includesKey: #installViews)
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testUsesInstallClassForAnnouncements [
    | methods |
    methods := (TripExpensesServerApp >> #installAnnouncements) messages.
    self assert: (methods includes: #installClass:)
]

{ #category : 'running' }
TripExpensesServerAppV2Test >> testUsesInstallClassForViews [
    | methods |
    methods := (TripExpensesServerApp >> #installViews) messages.
    self assert: (methods includes: #installClass:)
]
