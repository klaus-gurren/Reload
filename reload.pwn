/*
	Написав два простеньких приклада із використанням Pvarів та глобальним масивом, найкращий варік це п-вари так як вони не споживають пам'ять та видаляються на відміну від глобального масива.
		Також, варто би зробити кд доступною команду раз в 3-5 хв, щоб гравці не зловживали.
*/


CMD:reload(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "Неможливо використати в автомобілі!"); //можна обійтися і без цієї перевірки т/к перевірка стану нижче не пропустить.
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, -1, "Помилка! Спробуйте пізніше."); //Якщо гравець не іде пішки(тобто в інши станах, авто, спостереження, смерті і т/д, перевірка щоб запобігти багоюзу).
	
	new Float:ReloadFl[4]; //створюємо локальний масив в який запишемо текущі координати гравця.
	GetPlayerPos(playerid, ReloadFl[0], ReloadFl[1], ReloadFl[2]); //Отримуємо координати X,Y,Z та записуємо в масив
	GetPlayerFacingAngle(playerid, ReloadFl[3]); //Дізнаємось кут поворота та записуємо в масив.
	
	SetPVarFloat(playerid, "ReloadX", ReloadFl[0]), SetPVarFloat(playerid, "ReloadY", ReloadFl[1]), SetPVarFloat(playerid, "ReloadZ", ReloadFl[2]), SetPVarFloat(playerid, "ReloadA", ReloadFl[3]); //Створюємо pvar-и в які записуємо координати із масива
	
	if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0) //Якщо віртуальний світ та інтер'єр 0(стандарт) продовжуємо виконання функціоналу
	{
		SetPlayerPos(playerid, 7192.081298, 4050.939453, 87.533485); //Телепортуємо playerid у вказані координати, я вписав рандомні, головне далеко десь
	
		TogglePlayerControllable(playerid, false); //блокуємо екран гравцю 
		SetPlayerVirtualWorld(playerid, random(100) + 1); //встановлюємо random віртуальний світ 1-100 (теж щоб не багоюзили)
			
		SetTimer("reload_timer", 1300, false); //запускаємо таймер який через 1.3 секунди запустить самописний public "reload_timer".
	}
	else
	{
		SendClientMessage(playerid, -1, "Неможливо використати в інтер'єрі!");
	}	
	return 1;
}

forward reload_timer(playerid);
public reload_timer(playerid) //створюємо сам паблік
{
    SetPlayerPos(playerid, GetPVarFloat(playerid, "ReloadX"), GetPVarFloat(playerid, "ReloadY"), GetPVarFloat(playerid, "ReloadZ")); //телепортуємо гравця по координатах збережених в pvar-i
    SetPlayerFacingAngle(playerid, GetPVarFloat(playerid, "ReloadA")); //встановлюємо кут поворота
    SetPlayerVirtualWorld(playerid, 0); //встановлюємо 0 віртуальний світ playerid
    TogglePlayerControllable(playerid, true); //знімаємо фріз екрана
    
    DeletePVar(playerid, "ReloadX"), DeletePVar(playerid, "ReloadY"), DeletePVar(playerid, "ReloadZ"), DeletePVar(playerid, "ReloadA"); //видаляємо пвари
    return 1;
}


/*========================Приклад 2========================*/
new Float:ReloadFloat[MAX_PLAYERS][4]; //створюємо масив для зберігання поточних координатів гравця.

CMD:reload(playerid) //сама команда, для прикладу /reload
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "Неможливо використати в автомобілі!");
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, -1, "Помилка! Спробуйте пізніше.");
	
	GetPlayerPos(playerid, ReloadFloat[playerid][0], ReloadFloat[playerid][1], ReloadFloat[playerid][2]); //Отримуємо координати X,Y,Z та записуємо в масив
	GetPlayerFacingAngle(playerid, ReloadFloat[playerid][3]); //Дізнаємось кут поворота та записуємо в масив.
	
	if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0) //Якщо віртуальний світ та інтер'єр 0(стандарт) продовжуємо виконання функціоналу
	{
		SetPlayerPos(playerid, 7192.081298, 4050.939453, 87.533485); //Телепортуємо playerid у вказані координати, я вписав рандомні, головне далеко десь в небі
	
		TogglePlayerControllable(playerid, false); //блокуємо екран гравцю 
		SetPlayerVirtualWorld(playerid, random(100) + 1); //встановлюємо random віртуальний світ 1-100 (теж щоб не багоюзили)
			
		SetTimer("reload_timer", 1300, false); //запускаємо таймер який через 1.3 секунди запустить самописний public "reload_timer".
	}
	else
	{
		SendClientMessage(playerid, -1, "Неможливо використати в інтер'єрі!");
	}	
	return 1;
}

forward reload_timer(playerid);
public reload_timer(playerid) //створюємо сам паблік
{
    SetPlayerPos(playerid, ReloadFloat[playerid][0], ReloadFloat[playerid][1], ReloadFloat[playerid][2]); //телеплртуємо гравця по координатах збережених в масиві
    SetPlayerFacingAngle(playerid, ReloadFloat[playerid][3]); //встановлюємо кут поворота
    SetPlayerVirtualWorld(playerid, 0); //встановлюємо стандарт віртуальний світ playerid
    TogglePlayerControllable(playerid, true); //розблоковуємо екран
    
    return 1;
}
