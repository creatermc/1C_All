﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДокУИД	=  Документы.ПродажаРейсовПоВС.ПолучитьСсылку().УникальныйИдентификатор();
	НеобходимыйДокумент = Документы.ПродажаРейсовПоВС.ПолучитьСсылку(Новый УникальныйИдентификатор(Строка(ДокУИД)));   
	ТекСсылка = Документы.ПродажаРейсовПоВС.ПолучитьСсылку(Новый УникальныйИдентификатор(Строка(ДокУИД)));
	НовыйДок = Документы.ПродажаРейсовПоВС.СоздатьДокумент();
	НовыйДок.УстановитьСсылкуНового(ТекСсылка);
	НовыйДок.ОбменДанными.Загрузка = Истина;
	
	  Сообщить("" + НовыйДок);
	
КонецПроцедуры
