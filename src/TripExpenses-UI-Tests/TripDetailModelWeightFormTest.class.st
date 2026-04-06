Class {
	#name : 'TripDetailModelWeightFormTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId',
		'charlieId'
	],
	#category : 'TripExpenses-UI-Tests-TripDetail',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripDetail'
}

{ #category : 'running' }
TripDetailModelWeightFormTest >> setUp [
    | trip alice bob charlie |
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip    := service createTrip: 'Vacances' currency: 'EUR'.
    alice   := service addParticipantByName: 'Alice'   toTrip: trip id.
    bob     := service addParticipantByName: 'Bob'     toTrip: trip id.
    charlie := service addParticipantByName: 'Charlie' toTrip: trip id.
    tripId    := trip id.
    aliceId   := alice id value.
    bobId     := bob id value.
    charlieId := charlie id value.
    model := TripDetailModel onService: service tripId: tripId
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testAddExpenseExcludedParticipantHasWeightZero [
	"Bob exclu → son poids dans la split rule est 0 → balance zéro."

	| trip bob expense |
	model showExpenseForm.
	model excludeParticipantId: bobId.
	model
		addExpenseDescription: 'Resto'
		amount: 90
		payerId: aliceId
		participantWeights: model currentParticipantWeights .

	trip := service findTrip: tripId.
	bob := trip participants detect: [ :p | p id value = bobId ].
	expense := trip expenses first.
	self assert: (expense balanceFor: bob) amount equals: 0
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testAllParticipantsIncludedByDefault [
    "À l'ouverture du formulaire, tous les participants sont inclus."
    model showExpenseForm.
    model participantFormEntries do: [ :entry |
        self assert: entry included ]
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testCurrentParticipantWeightsIncludedUsesWeight [
    | weights aliceWeight |
    model showExpenseForm.
    model setWeight: 3 forParticipantId: aliceId.

    weights     := model currentParticipantWeights.
    aliceWeight := (weights detect: [ :pair | pair key = aliceId ]) value.
    self assert: aliceWeight equals: 3
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testDefaultWeightIsOne [
    model showExpenseForm.
    model participantFormEntries do: [ :entry |
        self assert: entry weight equals: 1 ]
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testExcludeParticipantAnnouncesValueChanged [
    | announced |
    model showExpenseForm.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model excludeParticipantId: bobId.
    self assert: announced
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testExcludeParticipantSetsIncludedFalse [
    | entry |    
model showExpenseForm.
    model excludeParticipantId: bobId.

    entry := model participantFormEntries detect: [ :e | e participantId = bobId ].
    self deny: entry included
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testParticipantFormEntriesExposeName [
    | names |
    model showExpenseForm.
    names := model participantFormEntries collect: [ :e | e name ].
    self assert: (names includes: 'Alice').
    self assert: (names includes: 'Bob').
    self assert: (names includes: 'Charlie')
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testParticipantFormEntriesExposeParticipantId [
    model showExpenseForm.
    model participantFormEntries do: [ :entry |
        self assert: entry participantId isNotNil.
        self deny: entry participantId isEmpty ]
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testParticipantFormEntriesHasOneEntryPerParticipant [
    model showExpenseForm.
    self assert: model participantFormEntries size equals: 3
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testReincludeParticipantSetsIncludedTrue [
    | entry |
    model showExpenseForm.
    model excludeParticipantId: bobId.
    model includeParticipantId: bobId.

    entry := model participantFormEntries detect: [ :e | e participantId = bobId ].
    self assert: entry included
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testSetWeightAnnouncesValueChanged [
    | announced |
    model showExpenseForm.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model setWeight: 2 forParticipantId: aliceId.
    self assert: announced
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testSetWeightBelowOneRaisesNoErrorButExcludesEffect [
    "Un poids à 0 sur un participant inclus est équivalent à l'exclure."
  | trip alice expense |   
 model showExpenseForm.
    model setWeight: 0 forParticipantId: aliceId.
    model
        addExpenseDescription: 'Hôtel'
        amount: 60
        payerId: bobId
        participantWeights: (model participantFormEntries
            collect: [ :e | e participantId -> e weight ]).
  
    trip    := service findTrip: tripId.
    alice   := trip participants detect: [ :p | p id value = aliceId ].
    expense := trip expenses first.
    self assert: (expense balanceFor: alice) amount equals: 0
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testSetWeightUpdatesEntry [
    | entry |   
 model showExpenseForm.
    model setWeight: 3 forParticipantId: aliceId.

    entry := model participantFormEntries detect: [ :e | e participantId = aliceId ].
    self assert: entry weight equals: 3
]

{ #category : 'running' }
TripDetailModelWeightFormTest >> testShowExpenseFormResetsEntries [
    "Ouvrir le formulaire une deuxième fois remet tout à zéro."
    model showExpenseForm.
    model excludeParticipantId: bobId.
    model setWeight: 5 forParticipantId: aliceId.
    model hideExpenseForm.
    model showExpenseForm.
    model participantFormEntries do: [ :entry |
        self assert: entry included.
        self assert: entry weight equals: 1 ]
]
