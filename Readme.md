# Info
Ashley Hacker - 100942843

## World Defender
Protect the world from invasion by running around it and shooting enemies flying towards it. 

I decided to recreate an old game I made.
https://bnuey.itch.io/bobblevsthegame
This game was coded HORRIBLY because it was literally my first game ever. 2021 Ashley did NOT know how to use a factory, or object pooling, or a goddamn SINGLETON !! This is why I chose to recreate it.

## I got distracted making another tool
I unfortunately had less time to work on the actual game prototype than I thought I would. Probably because a good chunk of time was spent working on a new plugin for the engine. In the addons folder you will find the SceneBuilder addon, it basically just speeds up the time it takes to create an entity by spawning a bunch of nodes in for me in a specific structure.
![[GE_LAB_DEMO|center|500x00]]
All entities I create and ever create should follow this structure, however when developing it can be annoying setting up the nodes manually over and over. You can press Alt+Shift+2 or 3 to create these nodes for 2D or 3D respectively.

Originally there was an additional EditorDock with buttons in it, but I thought keyboard shortcuts would be easier for me since I'm the only one using it. It adds everything to the EditorUndoRedoManager so it has proper Undo and Redo support.

## AI Transparency
I used AI to help with this plugin, but for the most part I knew what I was doing without it. Mostly just asked it stuff like 'How can I get a reference to the currently selected object(s) in the scene tree'. Or also how to do keyboard shortcuts in a plugin, since it was different than I expected. 

I put in the effort to learn what I was doing because this is stuff that's incredibly helpful. I didn't know where to start with Undo & Redo history but it was simplier than I thought. I specifically asked about line 100.
`undo_redo.add_undo_method(parent, "remove_child", new_root)`

I feared 'remove_child' might cause a memory leak since the nodes aren't being freed anywhere. Turns out the UndoRedo manager handles that for you, you don't free it since you still need to be able to Redo it. And then once your undo history get's cleared/destroyed it frees everything.

# Singletons & Factories
## Singletons
Godot has a built-in option for singletons called globals, so it was incredibly easy to set them up. This does not mean I don't know how to implement singletons, and good use cases for them.

Basic singleton implementation:
```C#
public class GameManager
{
	static GameManager instance;
	
	void Awake()
	{
		if (instance == null)
		{
			instance = self
		}
		else Destroy(self)
	}
	
}
```

The singleton class that we used in Toyboxers was more complex than this,
```C#
using UnityEngine;

public abstract class Singleton<T> : MonoBehaviour where T : MonoBehaviour
{
    public static T Instance { get; private set; }
    protected virtual void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
            Instance = this as T;
    }

    protected virtual void OnApplicationQuit()
    {
        KillInstance()
    }
    
    protected virtual void KillInstance()
    {
        Instance = null;
        Destroy(gameObject);
    }
}

public abstract class SingletonPersistant<T> : Singleton<T> where T : MonoBehaviour
{
    protected override void Awake()
    {
        base.Awake();
        DontDestroyOnLoad(gameObject);
    }
}
```

For the sake of transparency, I used these exact same code snippets in the lecture Participation Activity 3, but that assignment was almost the same as this, and it's also my code, so I think it's probably fine.

## I hate singletons
Using singletons makes your entire game logic dependent on said singleton. It's a sloppy way of writing code having 1 master file everything relies on. Obviously if you don't use singletons like that then boom! But you immediately realize why singletons suck when overused when you have to detangled a [disasterously programmed game](https://bnuey.itch.io/upcard)

I felt myself slipping into my same old habits. Forcing me to use singleton and build a game under a tight deadline is kinda annoying ngl (not that I blame anyone)

## Factories
Although I didn't get far enough with my implementation, I did still have plans on how I would use them. The game I'm making has many different enemies, with different stats. Some enemies have their own bullets they can shoot, the player is constantly shoot bullets. Would've been a perfect place to slot in a EnemyFactory with ObjectPooling.

# Question
- What element of your game adopts the chosen pattern?
	- The GameManager is a singleton/global script that can be accessed from anywhere.
- Why is this pattern a good choice for the associated functionality?
	- GameManagers are the pinical of Singletons. A GameManager often holds all the logic, settings, variables, etc that make a game function. Of course that's an oversimplification but for small games like this just 1 singleton (the gamemanager) is enough to handle everything you need. Being able to reference what round it is without having to GameObject.find("GameManger") is cheap and fast.