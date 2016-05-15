Lilac
5/15/2016
Version 1.0

### A Papyrus Testing Framework

Lilac is a unit testing framework for Papyrus. It has a clean syntax so that you can easily write tests. Use Lilac to increase the quality of your mods.

It is inspired by [Jasmine](http://jasmine.github.io) for Javascript. It is currently available for Skyrim, with Fallout 4 support coming soon.

Lilac can be embedded into your mod and distributed with it.

Documentation can be found on the Lilac GitHub Wiki: https://github.com/chesko256/Lilac/wiki

### Installation
All of Lilac is contained in a single script file, **Lilac.psc**. There is no complex set-up or installation.

Download and install the latest release using a Mod Manager, or just drop Lilac.psc into your `Scripts/Source` directory. Then, create a new script that extends Lilac and away you go:

    scriptname MyTests extends Lilac

### Writing Tests
Lilac allows you to write tests in a simple, expressive syntax.

    function MonsterSpawnerSuite()
        it("should spawn monsters", MonsterSpawnerTest())
    endFunction

    function MonsterSpawnerTest()
        spawner.SpawnMonsters()
        expectInt(spawner.SpawnedMonsterCount, to, beEqualTo, 20)
        expectRef(spawner.LastSpawnedMonster, notTo, beNone)
        expectForm(spawner.LastSpawnedMonsterType, to, beEqualTo, MegaDragon)
    endFunction

### License
Lilac is licensed under the MIT License.

### Running Tests
Just run a console command to start the quest that you attached your test script to, and Lilac takes care of the rest. The results will be output to your Papyrus log:
    
    startquest MyTestQuest

### Contact
Contact Chesko at chesko.tesmod@gmail.com
