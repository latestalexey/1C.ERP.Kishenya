////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ УПРАВЛЕНИЯ РЕЗЕРВНЫМ КОПИРОВАНИЕМ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ManageZonesBackup/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
Функция Версия() Экспорт
	
	Возврат "1.0.3.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений.
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ManageZonesBackup";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияУправлениеРезервнымКопированиемОбработчикСообщения_1_0_2_1);
	МассивОбработчиков.Добавить(СообщенияУправлениеРезервнымКопированиемОбработчикСообщения_1_0_3_1);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}PlanZoneBackup.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПланироватьАрхивациюОбласти(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PlanZoneBackup");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}CancelZoneBackup.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОтменитьАрхивациюОбласти(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = "http://www.1c.ru/SaaS/ManageZonesBackup/1.0.2.1";
	КонецЕсли;
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "CancelZoneBackup");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}UpdateScheduledZoneBackupSettings
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОбновитьНастройкиПериодическогоРезервногоКопирования(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "UpdateScheduledZoneBackupSettings");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ManageZonesBackup/a.b.c.d}CancelScheduledZoneBackup
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОтменитьПериодическоеРезервноеКопирование(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "CancelScheduledZoneBackup");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
