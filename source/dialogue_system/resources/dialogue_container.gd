class_name DialogueContainer
extends Resource


## Instant start dialogue, no needing to wait for a interaction.
@export var insta_dialogue: bool
## Dictionary mapping dialogue labels to block arrays.
## [br]
## Format: {StringName: Array(DialogueBlock)}
@export var dialogues: Dictionary[StringName, Array] = {"start": []}