"
Je suis le presenter racine de l application.
A chaque valueChanged du TripAppModel, je rerends la bonne sous-vue
en utilisant renderChildViewForModel:atSlotNamed:.
La TripAppView n est qu un conteneur avec un slot unique.
"
Class {
	#name : 'TripAppPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-App',
	#package : 'TripExpenses-UI',
	#tag : 'App'
}

{ #category : 'rendering' }
TripAppPresenter >> renderView [
    "Affiche soit la liste soit le detail selon l etat du modele racine."
    self model isShowingLogin ifTrue: [
        self renderChildViewForModel: self model loginModel atSlotNamed: #page.
        ^ self ].

    
self model isShowingDetail
        ifTrue: [
                self
                    renderChildViewForModel: self model currentTripDetailModel
                    atSlotNamed: #page ]
        ifFalse: [
                self
                    renderChildViewForModel: self model tripListModel
                    atSlotNamed: #page ]
]

{ #category : 'rendering' }
TripAppPresenter >> viewCreated [
    super viewCreated.
    self model when: ValueChanged send: #renderView to: self
]
