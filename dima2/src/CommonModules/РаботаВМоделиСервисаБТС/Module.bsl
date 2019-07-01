////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Поддержка работы в модели сервиса
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриВключенииРазделенияПоОбластямДанных"].Добавить(
		"РаботаВМоделиСервисаБТС");
	
	СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриЗаполненииТаблицыПараметровИБ"].Добавить(
		"РаботаВМоделиСервисаБТС");
	
	СерверныеОбработчики["ТехнологияСервиса.БазоваяФункциональность\ПриФормированииМанифестаКонфигурации"].Добавить(
		"РаботаВМоделиСервисаБТС");
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей 
//                                  см. в процедуре ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.0.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//  Обработчик.Опциональный        = Истина;
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.Процедура = "РаботаВМоделиСервисаБТС.СоздатьНеразделенныеПредопределенныеЭлементы";
		Обработчик.Приоритет = 99;
		Обработчик.ОбщиеДанные = Истина;
		Обработчик.МонопольныйРежим = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается при включении разделения данных по областям данных.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	
	СоздатьНеразделенныеПредопределенныеЭлементы();
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ()
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ВнешнийАдресУправляющегоПриложения");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик создания/обновления предопределенных элементов
// неразделенных объектов метаданных.
//
Процедура СоздатьНеразделенныеПредопределенныеЭлементы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ВызватьИсключение НСтр("ru='Операция может быть выполнена только в сеансе, в котором не установлены значения разделителей';uk='Операція може бути виконана тільки в сеансі, в якому не встановлено значення роздільників'");
		
	КонецЕсли;
	
	ИнициализироватьПредопределенныеДанные();
	
КонецПроцедуры

// Вызывается при формировании манифеста конфигурации.
//
// Параметры:
//  РасширенныеСведения - Массив, внутри процедуры обработчика в данный массив требуется
//    добавить объекты типа ОбъектXDTO с ТипомXDTO, унаследованным от
//    {http://www.1c.ru/1cFresh/Application/Manifest/a.b.c.d}ExtendedInfoItem.
//
Процедура ПриФормированииМанифестаКонфигурации(РасширенныеСведения) Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru='Операция не может быть выполнена при активной внешней транзакции!';uk='Операція не може бути виконана при активній зовнішній транзакції!'");
	КонецЕсли;
	
	ВызовВНеразделеннойИБ = Не ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
	НачатьТранзакцию();
	
	Попытка
		
		ОписаниеРазрешений = ФабрикаXDTO.Создать(
			ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "RequiredPermissions")
		);
		
		ОписаниеВнешнихКомпонент = ФабрикаXDTO.Создать(
			ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "Addins")
		);
		
		МакетыВнешнихКомпонент = Новый Соответствие();
		
		Если ВызовВНеразделеннойИБ Тогда
			
			Константы.ИспользоватьРазделениеПоОбластямДанных.Установить(Истина);
			ОбновитьПовторноИспользуемыеЗначения();
			
		КонецЕсли;
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Истина);
		
		ИдентификаторыЗапросов = РаботаВБезопасномРежиме.ЗапросыОбновленияРазрешенийКонфигурации();
		
		МенеджерПрименения = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.МенеджерПримененияРазрешений(ИдентификаторыЗапросов);
		Дельта = МенеджерПрименения.ДельтаБезУчетаВладельцев();
		
		МакетыВнешнихКомпонент = Новый Массив();
		
		Для Каждого ЭлементДельты Из Дельта.Добавляемые Цикл
			
			Для Каждого КлючИЗначение Из ЭлементДельты.Разрешения Цикл
				
				Разрешение = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(КлючИЗначение.Значение);
				ОписаниеРазрешений.Permission.Добавить(Разрешение);
				
				Если Разрешение.Тип() = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/1.0.0.1", "AttachAddin") Тогда
					МакетыВнешнихКомпонент.Добавить(Разрешение.TemplateName);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Для Каждого ИмяМакета Из МакетыВнешнихКомпонент Цикл
			
			ОписаниеВнешнейКомпоненты = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "AddinBundle"));
			ОписаниеВнешнейКомпоненты.TemplateName = ИмяМакета;
			
			ОписанияФайлов = РаботаВБезопасномРежиме.КонтрольныеСуммыФайловКомплектаВнешнейКомпоненты(ИмяМакета);
			
			Для Каждого КлючИЗначение Из ОписанияФайлов Цикл
				
				ОписаниеФайла = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Application/Permissions/Manifes/1.0.0.1", "AddinFile"));
				ОписаниеФайла.FileName = КлючИЗначение.Ключ;
				ОписаниеФайла.Hash = КлючИЗначение.Значение;
				
				ОписаниеВнешнейКомпоненты.Files.Добавить(ОписаниеФайла);
				
			КонецЦикла;
			
			ОписаниеВнешнихКомпонент.Bundles.Добавить(ОписаниеВнешнейКомпоненты);
			
		КонецЦикла;
		
		РасширенныеСведения.Добавить(ОписаниеРазрешений);
		РасширенныеСведения.Добавить(ОписаниеВнешнихКомпонент);
		
	Исключение
		
		ОтменитьТранзакцию();
		Если ВызовВНеразделеннойИБ Тогда
			ОбновитьПовторноИспользуемыеЗначения();
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	ОтменитьТранзакцию();
	Если ВызовВНеразделеннойИБ Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти