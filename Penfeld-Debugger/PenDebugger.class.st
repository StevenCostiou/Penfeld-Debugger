Class {
	#name : #PenDebugger,
	#superclass : #PenWindow,
	#instVars : [
		'debugSession',
		'stackStable',
		'codeEditor'
	],
	#category : #'Penfeld-Debugger'
}

{ #category : #'instance creation' }
PenDebugger class >> on: aDebugSession [
	^ self basicNew
		debugSession: aDebugSession;
		initialize;
		yourself
]

{ #category : #building }
PenDebugger >> buildRowComponentForContext: aContext [
	| row |
	row := PenTableItem new.
	"		row key: class name asSymbol."
	row dresser: PenBlocTableItemDresser new.
	row
		atSection: #receiverClass
		put: (PenLabel text: aContext receiver class name ).
	row
		atSection: #method
		put: (PenLabel text: aContext method selector).
	row atSection: #context put: (PenLabel text: aContext gtDisplayString).
	row key:  aContext .
	^ row
]

{ #category : #building }
PenDebugger >> buildStackComponentFor: aStack [
	^ aStack
		collect: [ :context | self buildRowComponentForContext: context ]
]

{ #category : #components }
PenDebugger >> codeEditorComponent [
	codeEditor := PenCodeEditor new.
	codeEditor position: 0@0.
	codeEditor width: 600.
	codeEditor height: 350.
	codeEditor dresser: PenBlocCodeEditorDresser new.
	codeEditor behavior: Object.
	^ codeEditor
]

{ #category : #accessing }
PenDebugger >> debugSession [
	^ debugSession
]

{ #category : #accessing }
PenDebugger >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #initialization }
PenDebugger >> initialize [
	super initialize.
	self title: 'Pen Debugger Example'.
	self initializeComponents
]

{ #category : #initialization }
PenDebugger >> initializeComponents [
	| container |
	container := PenContainer new
		layout: PenLinearLayout horizontal;
		key: #mainContainer;
		size: 800 @ 600.
	container
		addAllElements:
			{(PenContainer new
				layout: PenLinearLayout horizontal;
				addAllElements:
					{(PenContainer new
						layout: PenLinearLayout vertical;
						addAllElements:
							{(self titleLabelComponent: 'Stack').
							(PenContainer new
								layout: PenFlowLayout new;
								addAllElements: {self stackTableComponent}).
							self codeEditorComponent})})}.
	self withDisplayComponent: container
]

{ #category : #accessing }
PenDebugger >> stack [ 	
	^self debugSession stack
]

{ #category : #components }
PenDebugger >> stackTableComponent [
	stackStable := PenTable new.
	stackStable
		sections:
			{(PenSection new
				selector: #receiverClass;
				size: 180).
			(PenSection new
				selector: #method;
				size: 180).
			(PenSection new selector: #context).
			(PenSection new selector: #valueContext)}.
	stackStable addAllItems: (self buildStackComponentFor: self stack).
	stackStable allowToSelect: true.
	stackStable dragSections: true.
	stackStable dresser: PenBlocTableDresser new.
	stackStable
		onSelectionChangedDo: [ self
				updateContext: ((stackStable items at: stackStable selection first) key) ].
	stackStable height: 250.
	"component engineElement
		constraintsDo: [ :c | c horizontal matchParent ]."
	^ stackStable
]

{ #category : #components }
PenDebugger >> stackTableHeader [
	^ PenTableItem new
		dresser: PenBlocTableItemHeaderDresser new;
		atSection: #receiverClass put: (PenLabel new text: 'Class');
		atSection: #method put: (PenLabel new text: 'Method');
		atSection: #context put: (PenLabel new text: 'Context');
		yourself
]

{ #category : #components }
PenDebugger >> titleLabelComponent: aString [
	^ PenLabel new
		text: aString;
		addStyleClass: #title
]

{ #category : #updating }
PenDebugger >> updateContext: aContext [
	codeEditor method: aContext method.
	codeEditor behavior: aContext receiver class.
	codeEditor setSelectionInterval: (self debugSession selectedCodeRangeForContext: aContext)
]
