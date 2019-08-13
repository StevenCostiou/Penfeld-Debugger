Class {
	#name : #PenDebugger,
	#superclass : #PenWindow,
	#instVars : [
		'debugSession',
		'codeEditor',
		'stackTable',
		'announcer',
		'receiverInspectorTable',
		'inspectedObjectTable'
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

{ #category : #accessing }
PenDebugger >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
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
PenDebugger >> buildRowComponentForInspectorNode: aNode [
	| row |
	row := PenTableItem new.
	"		row key: class name asSymbol."
	row dresser: PenBlocTableItemDresser new.
	row
		atSection: #label
		put:
			(PenLabelWithModel new
				model: aNode;
				text: aNode variableTag;
				yourself).
	row
		atSection: #slot
		put:
			(PenLabelWithModel new
				model: aNode;
				text: aNode key;
				yourself).
	row
		atSection: #value
		put:
			(PenLabelWithModel new
				model: aNode;
				text: aNode value;
				yourself).
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
	codeEditor dresser: PenBlocCodeEditorDresser new.
	codeEditor behavior: Object.
	^ codeEditor
]

{ #category : #'accessing - compatibility' }
PenDebugger >> currentContext [
	^ self selectedContext
		ifNil: [ self debugSession interruptedContext ]
		ifNotNil: [ :ctx | ctx ]
]

{ #category : #components }
PenDebugger >> debugActionBarComponent [
	^ PenContainer new
		addAllElements:
			(self debugActions
				collect: [ :actionClass | 
					| action |
					action := actionClass forDebugger: self.
					PenButton new
						"text: action defaultLabel;"
						onActionDo: [ action executeAction ];
						icon: (Smalltalk ui iconNamed: (action defaultIcon ifNil: [ #abstract ]));
						yourself ]) yourself
]

{ #category : #accessing }
PenDebugger >> debugActions [
	^ {ResumeDebugAction.
	StepIntoDebugAction.
	StepOverDebugAction.
	StepThroughDebugAction.
	RestartDebugAction}
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
	
	self initializeComponents.
	self title: self session name.
	self registerActions
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
				layout: PenLinearLayout vertical;
				addAllElements:
					{(PenContainer new
						layout: PenLinearLayout vertical;
						addAllElements:
							{(PenContainer new
								layout: PenLinearLayout horizontal;
								addAllElements: {self stackTableComponent}).
							self debugActionBarComponent.
							self codeEditorComponent.
							(PenContainer new
								layout: PenLinearLayout horizontal;
								addAllElements:
									{self receiverInspectorTable.
									self inspectedObjectList})})})}.
	self withDisplayComponent: container.
	container stylesheet: PenStylesheet debuggerLight
]

{ #category : #components }
PenDebugger >> inspectedObjectList [
	inspectedObjectTable := PenTable new.
	inspectedObjectTable
		sections:
			{(PenSection new selector: #label; size: 60).
			(PenSection new selector: #slot; size: 70).
			(PenSection new selector: #value; size: 245)}.
	inspectedObjectTable
		size: 385 @ 220;
		allowToSelect: true;
		multiSelection: false.
	inspectedObjectTable dresser: PenBlocTableDresser new.
	^ inspectedObjectTable
]

{ #category : #opening }
PenDebugger >> open [
	super open.
	stackTable select: stackTable items first.

]

{ #category : #components }
PenDebugger >> receiverInspectorTable [
	receiverInspectorTable := PenTable new.
	receiverInspectorTable
		sections:
			{(PenSection new
				selector: #label;
				size: 60).
			(PenSection new
				selector: #slot;
				size: 70).
			(PenSection new
				selector: #value;
				size: 245)}.
	receiverInspectorTable
		size: 385 @ 220;
		allowToSelect: true;
		multiSelection: false.
	receiverInspectorTable dresser: PenBlocTableDresser new.
	receiverInspectorTable
		onSelectionChangedDo: [ self
				updateInspectedObject:
					((receiverInspectorTable items
						at: receiverInspectorTable selection first) content at: #slot)
						model rawValue ].
	^ receiverInspectorTable
]

{ #category : #initialization }
PenDebugger >> registerActions [ 
	self debugSession
			when: #restart send: #update to: self;
			when: #resume send: #update to: self;
			when: #stepInto send: #update to: self;
			when: #stepOver send: #update to: self;
			when: #stepThrough send: #update to: self;
			when: #contextChanged send: #update to: self 
]

{ #category : #accessing }
PenDebugger >> selectedContext [
	stackTable selection isEmpty ifTrue:[^nil].
	^(stackTable items at: stackTable selection first) key
]

{ #category : #'accessing - compatibility' }
PenDebugger >> session [
	^ self debugSession
]

{ #category : #accessing }
PenDebugger >> stack [ 	
	^self debugSession stack
]

{ #category : #components }
PenDebugger >> stackTableComponent [
	stackTable := PenTable new.
	stackTable
		sections:
			{(PenSection new
				selector: #receiverClass;
				size: 180).
			(PenSection new
				selector: #method;
				size: 180).
			(PenSection new selector: #context).
			(PenSection new selector: #valueContext)}.
	stackTable addAllItems: (self buildStackComponentFor: self stack).
	stackTable allowToSelect: true.
	stackTable dragSections: true.
	stackTable dresser: PenBlocTableDresser new.
	stackTable
		onSelectionChangedDo: [ self
				updateContext: ((stackTable items at: stackTable selection first) key) ].
	stackTable height: 250.	
	"component engineElement
		constraintsDo: [ :c | c horizontal matchParent ]."
	^ stackTable
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
PenDebugger >> update [
	| contextStackItems |
	contextStackItems := self buildStackComponentFor: self stack.
	stackTable removeAllItems.
	stackTable addAllItems: contextStackItems.
	stackTable
		build;
		refresh.
	stackTable select: contextStackItems first
]

{ #category : #updating }
PenDebugger >> updateContext: aContext [
	codeEditor method: aContext method.
	codeEditor behavior: aContext receiver class.
	codeEditor setSelectionInterval: (self debugSession selectedCodeRangeForContext: aContext).
	self updateInspectorsFrom: aContext
]

{ #category : #updating }
PenDebugger >> updateInspectedObject: anObject [
	| inspectedObjectNodes |
	inspectedObjectNodes := OrderedCollection new.
	anObject gtInspectorVariableNodesIn: inspectedObjectNodes.
	inspectedObjectTable removeAllItems.
	inspectedObjectTable
		addAllItems:
			(inspectedObjectNodes
				collect: [ :n | self buildRowComponentForInspectorNode: n ]).
	inspectedObjectTable
		build;
		refresh
]

{ #category : #updating }
PenDebugger >> updateInspectorsFrom: aContext [
	| receiverNodes |
	receiverNodes := OrderedCollection new.
	aContext receiver gtInspectorVariableNodesIn: receiverNodes.
	receiverInspectorTable removeAllItems.
	receiverInspectorTable
		addAllItems:
			(receiverNodes
				collect: [ :n | self buildRowComponentForInspectorNode: n ]).
	receiverInspectorTable
		build;
		refresh
]
