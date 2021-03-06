﻿
&НаСервереБезКонтекста
Процедура РешениеОшибкиНаСервере()

// Config - основная конфигурация информационной базы. 
// Эта конфигурация соответствует реальной структуре данных и используется 1С:Предприятием 8.0 в режиме Предприятия.
// ConfigSave - конфигурация, редактируемая Конфигуратором. 
// Конфигурация из ConfigSave переписывается в Config при выполнении "Обновления конфигурации базы данных" в Конфигураторе, 
// а наоборот - при выполнении в Конфигураторе операции "Конфигурация - Конфигурация базы данных - Вернуться к конфигурации БД".
Если ОшибкаФорматаПотокаПриЗапускеПредприятия() Тогда
	СделатьАрхивПоврежденнойБазы(Средствами1С = Истина, СредствамиСУБД = Ложь);
	СделатьАрхивПоврежденнойБазы(Средствами1С = Ложь, СредствамиСУБД = Истина);
	Если СУБД = "MS SQL" Тогда
		// Необходимо развернуть ближайший бэкап базы на том же сервере что и поврежденная. 
		// Со времени публикации статьи поля таблицы могут измениться, поэтому посмотрите состав полей и скорректируйте скрипт
		// Если перевести на русский язык: Скрипт удаляет сбойную таблицу config поврежденной базы и затем создает копию таблицы 
		// из рабочей базы в поврежденной.
		|GO
		|DROP TABLE [ПОВРЕЖДЕННАЯ_БАЗА].[dbo].[config]
		|GO
		|SET ANSI_NULLS ON
		|GO
		|SET QUOTED_IDENTIFIER ON
		|GO
		|CREATE TABLE [ПОВРЕЖДЕННАЯ_БАЗА].[dbo].[config](
		|[FileName] [nvarchar](128) NOT NULL,
		|[Creation] [datetime] NOT NULL,
		|[Modified] [datetime] NOT NULL,
		|[Attributes] [smallint] NOT NULL,
		|[DataSize] [int] NOT NULL,
		|[BinaryData] [image] NOT NULL,
		|PRIMARY KEY CLUSTERED
		|(
		|[FileName] ASC
		|)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		|) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		|GO
		|INSERT INTO [ПОВРЕЖДЕННАЯ_БАЗА].[dbo].[config]
		|SELECT * FROM [БЭКАПНАЯ_БАЗА].[dbo].[config]
		|GO 	
	ИначеЕсли СУБД = "PostgreSQL" Тогда
		copy config to '/home/user/config_err.txt в поврежденной базе
		copy config to '/home/user/config_backup.txt в базе поднятой из последнего бэкапа
		delete from config в поврежденной базе
		copy config from '/home/user/config_backup.txt в поврежденной базе
	КонецЕсли;
ИначеЕсли ОшибкаФорматаПотокаПриЗапускеКонфигуратора() Тогда
	// Ошибка возникает при прерванном сохранении конфигурации в БД.
	СделатьАрхивПоврежденнойБазы(Средствами1С = Ложь, СредствамиСУБД = Истина);
	// Полностью очищаем таблицу
	Если СУБД = "MS SQL" Тогда
		GO
		DELETE FROM [ПОВРЕЖДЕННАЯ_БАЗА].[dbo].[configsave]
	ИначеЕсли СУБД = "PostgreSQL" Тогда
		// Сохраним сбойную таблицу
		copy configsave to '/home/user/configsave_err.txt 
		// Очистим
		delete from configsave	
	КонецЕсли;	
КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РешениеОшибки(Команда)
	РешениеОшибкиНаСервере();
КонецПроцедуры
