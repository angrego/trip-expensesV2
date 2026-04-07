Class {
	#name : 'TripExpenseParticipantEntryTest',
	#superclass : 'TestCase',
	#category : 'TripExpenses-UI-Tests-Participant',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Participant'
}

{ #category : 'tests' }
TripExpenseParticipantEntryTest >> testForParticipantIncludedByDefault [
    | alice entry |
    alice := Participant name: 'Alice'.
    entry := TripExpenseParticipantEntry forParticipant: alice.
    self assert: entry included
]

{ #category : 'tests' }
TripExpenseParticipantEntryTest >> testForParticipantStoresId [
    | alice entry |
    alice := Participant name: 'Alice'.
    entry := TripExpenseParticipantEntry forParticipant: alice.
    self assert: entry participantId equals: alice id value
]

{ #category : 'tests' }
TripExpenseParticipantEntryTest >> testForParticipantStoresName [
    | alice entry |
    alice := Participant name: 'Alice'.
    entry := TripExpenseParticipantEntry forParticipant: alice.
    self assert: entry name equals: 'Alice'
]

{ #category : 'tests' }
TripExpenseParticipantEntryTest >> testForParticipantStoresParticipant [
    | alice entry |
    alice := Participant name: 'Alice'.
    entry := TripExpenseParticipantEntry forParticipant: alice.
    self assert: entry participant equals: alice
]

{ #category : 'tests' }
TripExpenseParticipantEntryTest >> testForParticipantWeightIsOne [
    | alice entry |
    alice := Participant name: 'Alice'.
    entry := TripExpenseParticipantEntry forParticipant: alice.
    self assert: entry weight equals: 1
]
