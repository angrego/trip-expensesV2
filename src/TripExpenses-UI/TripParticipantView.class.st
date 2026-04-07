Class {
	#name : 'TripParticipantView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Participant',
	#package : 'TripExpenses-UI',
	#tag : 'Participant'
}

{ #category : 'web resources' }
TripParticipantView class >> style [
<webResource: #css>
	^ ':host { display: inline-block; }
	   .chip { background: #e8e8ff; color: #3c3489; border-radius: 999px; padding: .2rem .8rem; font-size: .85rem; margin: .2rem; }'
]

{ #category : 'web resources' }
TripParticipantView class >> template [
	<webResource: #html>
	^ '<span class="chip" id="name"></span>'
]

{ #category : 'rendering' }
TripParticipantView >> renderName: aString [
	(self shadowedElementWithId: #name) textContent: aString
]
