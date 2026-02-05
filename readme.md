# Godot Easy Dialogue System

A flexible, resource-based dialogue system for **Godot 4**, featuring multi-language support and rich BBCode styling.

## Features
- [x] **Multi-language support** – CSV-based localization system  
- [x] **BBCode styling** – Rich text with colors and effects  
- [x] **DialogueArea2D** – Proximity-based interaction triggers  
- [x] **Topic system** – Multiple conversations per dialogue container  
- [x] **Extensible node system** – Easy to create custom dialogue nodes  
- [x] **Support for multiple text boxes**  
- [ ] **Mobile support**
- [ ] **Godot Graph Plugin** - for easy dialogue creation
- [ ] **Play audios for texts** - designed, yet not implemented
- [ ] **DialogueConditionNode**

---

## Installation

To use this system:

1. Download or clone this repository.
2. Copy the `/dialogue-system` folder into your Godot project.
3. Done :) You’re ready to use it.

---
<details>
<summary><h2>Quick Setup</h2></summary>

### 1. Create a `DialogueContainer` resource

In the Inspector:

- Add a new key entry to **Topics** (give it a cool name).
- In the array value, add new value of type **OBJECT**.
- Find and add [DialogueNode](#dialogue-nodes) to the list.
- Configure each node to fit your needs.

You can create as many containers and topics as you want.

---

### 2. Create a `DialogueArea2D`

In your scene:

1. Add a new child node.
2. Select **DialogueArea2D**.
3. Add a child node to it:
   - Select **CollisionShape2D**
   - Add a collision shape.
4. Select `DialogueArea2D` again in the scene tree.

In the Inspector:

- Drag and drop a dialogue interaction hint scene.
- Enable **Instant Dialogue** if you want the dialogue to start automatically.

> You can create your own interaction hint scene, but it **must be a `TouchScreenButton`**.

---

### 3. Create a `DialogueManager`

In the same scene:

1. Add a new child node.
2. Select **DialogueManager**.
3. Select the manager in the scene tree.

In the Inspector:

#### Dialogue Settings
- Add the topic key from the `DialogueContainer` you created.

#### Dialogue Resources
- Drag and drop the `DialogueContainer`.
- Drag and drop a `DialogueTextBox` scene (or your own custom one).
- Assign the `DialogueArea2D` trigger created earlier.

---

### 4. Configure Input Actions

Go to **Project Settings -> Input Map**:

- Add a new action called **`chat`** and assign an input to it.
- Add a new action called **`interact`** and assign an input to it.

> **`chat`**  
> Used by `DialogueArea2D` to trigger the dialogue interaction.

> **`interact`**  
> Used by `DialogueManager` to:
> - Skip the typewriting text effect
> - Advance to the next dialogue text

You may rename these actions if you want, but make sure to update the action names in **both** dialogue components.

---
If everything is set up correctly, you can now run the game and test the dialogue.
Make sure your player has a collision shape that can be detected by the `DialogueArea2D`.
</details>

---

## Dialogue Nodes

Dialogue Nodes are the core building blocks of the conversation.  
Each node represents a single action in the conversation, such as displaying text, jumping to another topic, or executing logic.

The system is easily extensible you can create your own nodes by extending `DialogueNode`.

<details>
<summary>
  <h3>DialogueTextNode</h3>
</summary>

Displays dialogue text using a typewriter effect.

**Features:**
- Linear or randomized dialogue text
- Typewriting text effect with configurable speed
- Waits for player input before continuing
- Automatically handles text box visibility

**Inspector Properties:**
- `dialogues_text` – List of dialogue text
- `dialogues_audio` – Optional audio per text
- `text_speed` – Typewriter speed (0 = instant)
- `randomize_dialogue` – Display a random text instead of linear text

</details>

<details>
<summary>
  <h3>DialogueGotoNode</h3>
</summary>

Changes the current dialogue topic to another topic or node position.

**Features:**
- Jump to a different topic
- Jump to a specific node index inside the topic
- Useful for branching dialogues and looping conversations

**Inspector Properties:**
- `goto_id` – Target topic ID
- `goto_index` – Target node index (0 keeps current flow)

</details>

<details>
<summary>
  <h3>DialogueMethodNode</h3>
</summary>

Executes a callable during the dialogue.

This node is useful for triggering gameplay logic such as:
- Starting a quest
- Playing animations or sounds
- Displaying shop UI

**Features:**
- Executes custom logic without breaking the conversation

**Inspector Properties:**
- `method_name` – Name of the registered method to execute
- `arguments` – Optional arguments passed to the method (if supported)

</details>

<details>
<summary>
  <h3>DialogueNode (Base Class)</h3>
</summary>

Base class for all dialogue nodes.

**Responsibilities:**
- Defines the `execute(dialogue_manager)` method
- Defines the `finished` signal
- Supports cancellation through `cancel(dialogue_manager)`

To create a custom node:
1. Extend `DialogueNode`
2. Implement `execute(manager)`
3. Emit `finished` when the node is done

</details>

---

## Contributing
Contributions are welcome! You can fork this repo and submit wheter its a feature or fix.

## Credits

Country flags: [here.](https://dafluffypotato.itch.io/pixel-country-flags)

Character and environment assets: [here.](https://anokolisa.itch.io/free-pixel-art-asset-pack-topdown-tileset-rpg-16x16-sprites)

## License - MIT
This project is licensed under [MIT License](LICENSE)