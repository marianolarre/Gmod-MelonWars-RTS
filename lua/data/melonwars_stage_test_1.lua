Test Stage
This stage is only for testing the singleplayer mode.

cutscene start
-say [[[ MELON WARS: TEST STAGE 1 ]]]
-wait 2
-say Red Soldier: Commander! We have intercepted a nearby radio communication!
-wait 3
-say Red Soldier: Patching you through!
-wait 2
-say ...
-wait 2
-say ?: We have finaly found their base!
-wait 2.5
-say ?: Attack now, while they are defenseless!
-wait 2.5
-say ?: Prepare the troops!
-wait 2
-say ...
-wait 1
-say Red Soldier: Their troops will be ready in 60 seconds sir!
-wait 3
-say Red Soldier: We should set up a defense, quickly!
-wait 2
-say Red Soldier: Attack incoming, 60 seconds.
-wait 2
cutscene end
-say [[[ GAME START (Toolgun Enabled) ]]]
-wait 20
-say Red Soldier: Attack incoming, 40 seconds.
-wait 20
-say Red Soldier: Attack incoming, 20 seconds.
-wait 10
-say Red Soldier: Attack incoming, 10 seconds.
-wait 5
randompath
spawn 5 marine
wait 4
say Red Soldier: Enemy troops incoming!
randompath
spawn 5 marine
wait 5
randompath
spawn 5 marine
clear
say ?: They were prepared. Send in the big guns!
wait 4
randompath
spawn 5 marine
spawn 3 medic
wait 5
randompath
spawn 5 marine
spawn 3 medic
wait 10
randompath
spawn 5 gunner
spawn 1 medic
wait 5
randompath
spawn 8 marine
spawn 3 sniper
wait 10
randompath
spawn 2 mortar
spawn 10 marine
wait 10
randompath
spawn 4 missiles
spawn 8 marine
spawn 2 medic
wait 2
randompath
spawn 1 bomb
randompath
spawn 1 bomb
randompath
spawn 1 bomb
randompath
spawn 1 bomb
randompath
spawn 1 bomb
randompath
spawn 1 bomb
randompath
spawn 1 bomb
wait 10
randompath
spawn 1 nuke
spawn 15 marine
spawn 2 medic
randompath
spawn 3 gunner
spawn 3 sniper
clear
say ?: Fall back! This battle is theirs. We'll get them another time.
wait 2.5
say [[[ MISSION COMPLETE ]]]
