//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт; // для предотвращения повторной обработки события
Перем глДоступныеТипыОборудования Экспорт;
//Конец РаботаСВнешнимОборудованием

// ЭлектронноеВзаимодействие
// При соответствующих настройках сертификата ЭП в соответствии будут храниться пары Сертификат-Пароль (в данном сеансе)
Перем СоответствиеСертификатаИПароля Экспорт;
// Конец ЭлектронноеВзаимодействие

Перем глКомпонентаОбменаСМобильнымиПриложениями Экспорт;
Перем глФормаНачальнойНастройкиПрограммы Экспорт;

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

// Параметры для фоновых заданий
Перем ПараметрыПроверкиФоновыхЗаданий Экспорт;

// ТехнологияСервиса

Перем ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса Экспорт;

// Конец ТехнологияСервиса

// РегламентированнаяОтчетность
Перем глМенеджерЗвит1С   Экспорт;
Перем глКомпонентаЗвит1С Экспорт;
// Конец РегламентированнаяОтчетность

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	глФормаНачальнойНастройкиПрограммы = ОткрытиеФормПриНачалеРаботыСистемыВызовСервера.ФормаНачальнойНастройкиПрограммы();
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПередНачаломРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователей
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	Если Лев(Источник, 17) = "MobileApplication" Тогда
		МобильныеПриложенияКлиент.ОбработатьВнешнееСобытиеОтМобильногоПриложения(Источник, Событие, Данные);
		Возврат;
	КонецЕсли;
	
	глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
	
	//РаботаСВнешнимОборудованием
	// Подготовить данные
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	// Передать на обработку данные
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.';uk='При обробці зовнішньої події від пристрою сталася помилка.'")
		                                                 + Символы.ПС + ОписаниеОшибки);
	КонецЕсли;
	//Конец РаботаСВнешнимОборудованием
	
КонецПроцедуры

#КонецОбласти

глНомерКонтейнераСбербанк     = 0;
глУстановленКаналСоСбербанком = Ложь;
глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
