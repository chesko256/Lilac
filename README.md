![Lilac](http://i.imgur.com/m3MIMw5.png "Lilac")
### A Papyrus Testing Framework

Lilac is a unit testing framework for Papyrus. It has a simple and direct syntax so that you can easily write tests to increase the quality of your mods.

It is inspired by [Jasmine](http://jasmine.github.io) for Javascript. It is currently available for **Skyrim**, with **Fallout 4** support coming soon.

Lilac can be built into your mod and distributed with it. Your tests will only run when you decide to run them; your users will most likely never know they exist.

### Documentation

Documentation can be found on the Lilac GitHub Wiki: https://github.com/chesko256/Lilac/wiki

### Requirements

Lilac requires SKSE 1.7.3+ to compile and execute tests. This does **not** mean that your mod requirements will change; Lilac tests are for you, the mod developer. If your mod didn't require SKSE before, Lilac won't change that.

### Installation
All of Lilac is contained in a single script file, **Lilac.psc**. There is no complex set-up or installation.

Download and install the [latest release](https://github.com/chesko256/Lilac/releases) using a mod manager, or just drop Lilac.psc into your `Scripts/Source` directory. Then, create a new script that extends Lilac and away you go:

    scriptname MyTests extends Lilac

### Writing Tests
Lilac allows you to write tests in a clear and expressive syntax.

    function MonsterSpawnerSuite()

        it ( "should spawn monsters", MonsterSpawnerTest() )

    endFunction


    function MonsterSpawnerTest()

        spawner.SpawnMonsters()
        expectInt ( spawner.SpawnedMonsterCount, to, beEqualTo, 20 )
        expectRef ( spawner.LastSpawnedMonster, notTo, beNone )
        expectForm ( spawner.LastSpawnedMonsterType, to, beEqualTo, MegaDragon )

    endFunction

### Running Tests
Lilac test scripts are attached to quests. To run your tests, just start the quest:
    
    startquest MyTestQuest

The results will be printed to your Papyrus log.

### License
Lilac is released under the [MIT License](https://github.com/chesko256/Lilac/blob/master/MIT.LICENSE).

### Contact
Contact Chesko at chesko.tesmod@gmail.com
