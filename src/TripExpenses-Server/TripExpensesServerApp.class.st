"
Je suis le point d entrée CodeParadise côté SERVEUR.
Une instance est créée par session utilisateur par le framework CP.

Responsabilités :
  1. Créer le TripApplicationService (accès à la persistance).
  2. Créer TripExpensesApplication (CpMvpWebApplication) avec ce service.
  3. Installer dans le navigateur toutes les classes client-side via CP.

Côté SERVEUR (Pharo image) — restent dans l image :
  TripExpensesServerApp
    └── TripExpensesApplication (CpMvpWebApplication)
          ├── TripListModel  ──► TripApplicationService
          ├── TripDetailModel ─► TripApplicationService
          ├── TripListPresenter
          └── TripDetailPresenter

Côté CLIENT (navigateur / WebAssembly) — installés par install :
  Views : TripListView, TripDetailView, TripItemView,
          TripParticipantView, TripBalanceItemView,
          TripExpenseItemView, TripSettlementItemView
  Annonces : TripListShowFormRequested, TripListHideFormRequested,
             TripListCreateRequested, TripItemClicked,
             TripDetailShowExpenseFormRequested,
             TripDetailHideExpenseFormRequested,
             TripDetailAddExpenseRequested, TripDetailBackRequested

URL : http://localhost:8080/static/app.html?app=Voyages
"
Class {
	#name : 'TripExpensesServerApp',
	#superclass : 'CpServerApplication',
	#instVars : [
		'application'
	],
	#category : 'TripExpenses-Server-TripExpenseApplication',
	#package : 'TripExpenses-Server',
	#tag : 'TripExpenseApplication'
}

{ #category : 'accessing' }
TripExpensesServerApp class >> app [
	"Identifiant CP qui lie cette CpServerApplication à TripExpensesApplication.
	 Doit correspondre exactement à TripExpensesApplication class >> app
	 et au paramètre ?app= dans l URL."
	^ #'Voyages'
]

{ #category : 'instance creation' }
TripExpensesServerApp class >> withRepository: aRepository [
	"Factory testable — injecte un repository arbitraire (InMemoryTripRepository en test, STONTripRepository en production)."

	^ self new
		  initializeWithRepository: aRepository;
		  yourself
]

{ #category : 'accessing' }
TripExpensesServerApp >> application [
	"L application MVP de cette session — vit côté serveur."
	^ application
]

{ #category : 'initialization' }
TripExpensesServerApp >> initialize [
	"CP appelle initialize à chaque nouvelle session navigateur. On crée le service avec le repository de production, puis l application MVP qui orchestre Models et Presenters côté serveur."

	super initialize.
	self initializeWithRepository: STONTripRepository default
]

{ #category : 'initialization' }
TripExpensesServerApp >> initializeWithRepository: aRepository [
	"Point d initialisation injectable — repository libre en test, STONTripRepository en production."

	application := TripExpensesApplication onService:
		               (TripApplicationService withRepository: aRepository)
]

{ #category : 'installing' }
TripExpensesServerApp >> install [
	"CP appelle install après initialize, avant de répondre au navigateur. On installe côté client (WebAssembly) les classes qui doivent s'exécuter dans le navigateur : Views et Announcements. Models, Presenters et le service restent dans l image Pharo."

	self
		installViews;
		installAnnouncements
]

{ #category : 'installing' }
TripExpensesServerApp >> installAnnouncements [
	"Les Announcements émises par serverAnnounce: dans les Views doivent exister côté client — on les installe dans le navigateur."
	self
		installClass: TripListShowFormRequested;
		installClass: TripListHideFormRequested;
		installClass: TripListCreateRequested;
		installClass: TripItemClicked;
		installClass: TripDetailShowExpenseFormRequested;
		installClass: TripDetailHideExpenseFormRequested;
		installClass: TripDetailAddExpenseRequested;
		installClass: TripDetailBackRequested;
		installClass: TripAddParticipantShowFormRequested;
		installClass: TripAddParticipantHideFormRequested;
		installClass: TripAddParticipantRequested
]

{ #category : 'installing' }
TripExpensesServerApp >> installViews [
	"Toutes les CpView subclasses — elles s'exécutent dans le navigateur."
	self
		installClass: TripAppView;
		installClass: TripListView;
		installClass: TripItemView;
		installClass: TripDetailView;
		installClass: TripAddParticipantView;
		installClass: TripParticipantView;
		installClass: TripBalanceItemView;
		installClass: TripExpenseItemView;
		installClass: TripSettlementItemView
]
