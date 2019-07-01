#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Управление разрешениями в профилях безопасности
//
////////////////////////////////////////////////////////////////////////////////

#Область ВнутренееСостояние

// Массив(УникальныйИдентификатор) - массив идентификаторов запросов на использование внешних
// ресурсов, для применения которых инициализирован объект.
//
Перем ИдентификаторыЗапросов;

// Структура - текущий план применения запросов на использование внешних ресурсов. Поля структуры:
//  * Замещаемые - ТаблицаЗначений - операции замещения существующих разрешений на использование внешних ресурсов:
//      * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//      * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//      * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//      * ИдентификаторВладельца - УникальныйИдентификатор,
//  * Добавляемые - ТаблицаЗначений - операции добавления разрешений на использование внешних ресурсов:
//      * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//      * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//      * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//      * ИдентификаторВладельца - УникальныйИдентификатор,
//      * Тип - Строка - имя XDTO-типа, описывающего разререшения,
//      * Разрешения - Соответствие - описание добавляемых разрешений:
//         * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//             РазрешенияНаИспользованиеВнешнихРесурсов),
//         * Значение - ОбъектXDTO - XDTO-описание добавляемого разрешения,
//  * Удаляемые - ТаблицаЗначений - операции удаления разрешений на использование внешних ресурсов:
//      * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//      * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//      * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//      * ИдентификаторВладельца - УникальныйИдентификатор,
//      * Тип - Строка - имя XDTO-типа, описывающего разререшения,
//      * Разрешения - Соответствие - описание удаляемых разрешений:
//         * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//             РазрешенияНаИспользованиеВнешнихРесурсов),
//         * Значение - ОбъектXDTO - XDTO-описание удаляемого разрешения,
//
Перем ПланПримененияЗапросов;

// Таблица значений - исходный срез разрешений (в разрезе владельцев разрешений). Колонки:
// * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
// * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
// * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
// * ИдентификаторВладельца - УникальныйИдентификатор,
// * Тип - Строка - имя XDTO-типа, описывающего разререшения,
// * Разрешения - Соответствие - описание разрешений:
//   * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//      РазрешенияНаИспользованиеВнешнихРесурсов),
//   * Значение - ОбъектXDTO - XDTO-описание разрешения,
//
Перем ИсходныйСрезРазрешенийВРазрезеВладельцев;

// Таблица значений - исходный срез разрешений (без учета владельцев разрешений). Колонки:
// * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
// * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
// * Тип - Строка - имя XDTO-типа, описывающего разререшения,
// * Разрешения - Соответствие - описание разрешений:
//   * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//      РазрешенияНаИспользованиеВнешнихРесурсов),
//   * Значение - ОбъектXDTO - XDTO-описание разрешения,
//
Перем ИсходныйСрезРазрешенийБезУчетаВладельцев;

// Таблица значений - срез разрешений в результате применения запросов (в разрезе владельцев разрешений).
// Колонки:
// * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
// * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
// * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
// * ИдентификаторВладельца - УникальныйИдентификатор,
// * Тип - Строка - имя XDTO-типа, описывающего разререшения,
// * Разрешения - Соответствие - описание разрешений:
//   * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//      РазрешенияНаИспользованиеВнешнихРесурсов),
//   * Значение - ОбъектXDTO - XDTO-описание разрешения,
//
Перем РезультатПримененияЗапросовВРазрезеВладельцев;

// Таблица значений - срез разрешений в результате применения запросов (в разрезе владельцев разрешений).
// Колонки:
// * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
// * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
// * Тип - Строка - имя XDTO-типа, описывающего разререшения,
// * Разрешения - Соответствие - описание разрешений:
//   * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//      РазрешенияНаИспользованиеВнешнихРесурсов),
//   * Значение - ОбъектXDTO - XDTO-описание разрешения,
//
Перем РезультатПримененияЗапросовБезУчетаВладельцев;

// Структура - дельта между исходным и результирующим срезами разрешений (в разрезе владельцев разрешений):
//  * Добавляемые - ТаблицаЗначений - описание добавляемых разрешений, колонки:
//    * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//    * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//    * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//    * ИдентификаторВладельца - УникальныйИдентификатор,
//    * Тип - Строка - имя XDTO-типа, описывающего разререшения,
//    * Разрешения - Соответствие - описание разрешений:
//      * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//         РазрешенияНаИспользованиеВнешнихРесурсов),
//      * Значение - ОбъектXDTO - XDTO-описание разрешения,
//  * Удаляемые - ТаблицаЗначений - описание удаляемых разрешений, колонки:
//    * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//    * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//    * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//    * ИдентификаторВладельца - УникальныйИдентификатор,
//    * Тип - Строка - имя XDTO-типа, описывающего разререшения,
//    * Разрешения - Соответствие - описание разрешений:
//      * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//         РазрешенияНаИспользованиеВнешнихРесурсов),
//      * Значение - ОбъектXDTO - XDTO-описание разрешения,
//
Перем ДельтаВРазрезеВладельцев;

// Структура - дельта между исходным и результирующим срезами разрешений (без учета владельцев разрешений):
//  * Добавляемые - ТаблицаЗначений - описание добавляемых разрешений, колонки:
//    * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//    * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//    * Тип - Строка - имя XDTO-типа, описывающего разререшения,
//    * Разрешения - Соответствие - описание разрешений:
//      * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//         РазрешенияНаИспользованиеВнешнихРесурсов),
//      * Значение - ОбъектXDTO - XDTO-описание разрешения,
//  * Удаляемые - ТаблицаЗначений - описание удаляемых разрешений, колонки:
//    * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//    * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//    * Тип - Строка - имя XDTO-типа, описывающего разререшения,
//    * Разрешения - Соответствие - описание разрешений:
//      * Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуеле менеджера регистра
//         РазрешенияНаИспользованиеВнешнихРесурсов),
//      * Значение - ОбъектXDTO - XDTO-описание разрешения,
//
Перем ДельтаБезУчетаВладельцев;

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет идентификатор запроса в перечень обработаываемых. После успешного применения будет выполнена очистка
// запросов, идентификаторы которых были добавлены.
//
// Параметры:
//  ИдентификаторЗапроса - УникальныйИдентификатор - идентификатор запроса на использование
//    внешних ресурсов.
//
Процедура ДобавитьИдентификаторЗапроса(Знач ИдентификаторЗапроса) Экспорт
	
	ИдентификаторыЗапросов.Добавить(ИдентификаторЗапроса);
	
КонецПроцедуры

// Добавляет свойства запроса разрешений на использование внешних ресурсов в план применения запросов.
//
// Параметры:
//  ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//  ИдентификаторПрограммногоМодуля - УникальныйИдентификатор,
//  ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//  ИдентификаторВладельца - УникальныйИдентификатор,
//  РежимЗамещения - Булево,
//  ДобавляемыеРазрешения - Массив(ОбъектXDTO) или Неопределено,
//  УдаляемыеРазрешения - Массив(ОбъектXDTO) или Неопределено.
//
Процедура ДобавитьЗапросРазрешенийНаИспользованиеВнешнихРесурсов(
		Знач ТипПрограммногоМодуля, Знач ИдентификаторПрограммногоМодуля,
		Знач ТипВладельца, Знач ИдентификаторВладельца,
		Знач РежимЗамещения,
		Знач ДобавляемыеРазрешения = Неопределено,
		Знач УдаляемыеРазрешения = Неопределено) Экспорт
	
	Если РежимЗамещения Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("ТипВладельца", ТипВладельца);
		Отбор.Вставить("ИдентификаторВладельца", ИдентификаторВладельца);
		
		СтрокаЗамещения = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
			ПланПримененияЗапросов.Замещаемые, Отбор);
		
	КонецЕсли;
	
	Если ДобавляемыеРазрешения <> Неопределено Тогда
		
		Для Каждого ДобавляемоеРазрешение Из ДобавляемыеРазрешения Цикл
			
			Отбор = Новый Структура();
			Отбор.Вставить("ТипПрограммногоМодуля", ТипПрограммногоМодуля);
			Отбор.Вставить("ИдентификаторПрограммногоМодуля", ИдентификаторПрограммногоМодуля);
			Отбор.Вставить("ТипВладельца", ТипВладельца);
			Отбор.Вставить("ИдентификаторВладельца", ИдентификаторВладельца);
			Отбор.Вставить("Тип", ДобавляемоеРазрешение.Тип().Имя);
			
			Строка = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
				ПланПримененияЗапросов.Добавляемые, Отбор);
			
			КлючРазрешения = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.КлючРазрешения(ДобавляемоеРазрешение);
			Строка.Разрешения.Вставить(КлючРазрешения, ОбщегоНазначения.ОбъектXDTOВСтрокуXML(ДобавляемоеРазрешение));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если УдаляемыеРазрешения <> Неопределено Тогда
		
		Для Каждого УдаляемоеРазрешение Из УдаляемыеРазрешения Цикл
			
			Отбор = Новый Структура();
			Отбор.Вставить("ТипПрограммногоМодуля", ТипПрограммногоМодуля);
			Отбор.Вставить("ИдентификаторПрограммногоМодуля", ИдентификаторПрограммногоМодуля);
			Отбор.Вставить("ТипВладельца", ТипВладельца);
			Отбор.Вставить("ИдентификаторВладельца", ИдентификаторВладельца);
			Отбор.Вставить("Тип", ДобавляемоеРазрешение.Тип().Имя);
			
			Строка = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
				ПланПримененияЗапросов.Удаляемые, Отбор);
			
			КлючРазрешения = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.КлючРазрешения(УдаляемоеРазрешение);
			Строка.Разрешения.Добавить(КлючРазрешения, ОбщегоНазначения.ОбъектXDTOВСтрокуXML(УдаляемоеРазрешение));
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Рассчитывает результат применения запросов на использование внешних ресурсов.
//
Процедура РассчитатьПрименениеЗапросов() Экспорт
	
	ВнешняяТранзакция = ТранзакцияАктивна();
	
	Если Не ВнешняяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	
	Попытка
		
		РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.ЗаблокироватьРегистрыПредоставленныхРазрешений();
		
		ИсходныйСрезРазрешенийВРазрезеВладельцев = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СрезРазрешений();
		РассчитатьРезультатПримененияЗапросовВРазрезеВладельцев();
		РассчитатьДельтуВРазрезеВладельцев();
		
		ИсходныйСрезРазрешенийБезУчетаВладельцев = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СрезРазрешений(Ложь, Истина);
		РассчитатьРезультатПримененияЗапросовБезУчетаВладельцев();
		РассчитатьДельтуБезУчетаВладельцев();
		
		Если Не ВнешняяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
	Исключение
		
		Если Не ВнешняяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Рассчитывает результат применения запросов в разрезе владельцев.
//
Процедура РассчитатьРезультатПримененияЗапросовВРазрезеВладельцев()
	
	РезультатПримененияЗапросовВРазрезеВладельцев = Новый ТаблицаЗначений();
	
	Для Каждого ИсходнаяКолонка Из ИсходныйСрезРазрешенийВРазрезеВладельцев.Колонки Цикл
		РезультатПримененияЗапросовВРазрезеВладельцев.Колонки.Добавить(ИсходнаяКолонка.Имя, ИсходнаяКолонка.ТипЗначения);
	КонецЦикла;
	
	Для Каждого ИсходнаяСтрока Из ИсходныйСрезРазрешенийВРазрезеВладельцев Цикл
		НоваяСтрока = РезультатПримененияЗапросовВРазрезеВладельцев.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ИсходнаяСтрока);
	КонецЦикла;
	
	// Применяем план
	
	// Замещение
	Для Каждого СтрокаТаблицыЗамещения Из ПланПримененияЗапросов.Замещаемые Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", СтрокаТаблицыЗамещения.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", СтрокаТаблицыЗамещения.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("ТипВладельца", СтрокаТаблицыЗамещения.ТипВладельца);
		Отбор.Вставить("ИдентификаторВладельца", СтрокаТаблицыЗамещения.ИдентификаторВладельца);
		
		Строки = РезультатПримененияЗапросовВРазрезеВладельцев.НайтиСтроки(Отбор);
		
		Для Каждого Строка Из Строки Цикл
			РезультатПримененияЗапросовВРазрезеВладельцев.Удалить(Строка);
		КонецЦикла;
		
	КонецЦикла;
	
	// Добавление разрешений
	Для Каждого СтрокаДобавлемых Из ПланПримененияЗапросов.Добавляемые Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", СтрокаДобавлемых.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", СтрокаДобавлемых.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("ТипВладельца", СтрокаДобавлемых.ТипВладельца);
		Отбор.Вставить("ИдентификаторВладельца", СтрокаДобавлемых.ИдентификаторВладельца);
		Отбор.Вставить("Тип", СтрокаДобавлемых.Тип);
		
		Строка = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
			РезультатПримененияЗапросовВРазрезеВладельцев, Отбор);
		
		Для Каждого КлючИЗначение Из СтрокаДобавлемых.Разрешения Цикл
			Строка.Разрешения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
	КонецЦикла;
	
	// Удаление разрешений
	Для Каждого СтрокаУдаляемых Из ПланПримененияЗапросов.Удаляемые Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", СтрокаУдаляемых.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", СтрокаУдаляемых.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("ТипВладельца", СтрокаУдаляемых.ТипВладельца);
		Отбор.Вставить("ИдентификаторВладельца", СтрокаУдаляемых.ИдентификаторВладельца);
		Отбор.Вставить("Тип", СтрокаУдаляемых.Тип);
		
		Строка = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
			РезультатПримененияЗапросовВРазрезеВладельцев, Отбор);
		
		Для Каждого КлючИЗначение Из СтрокаУдаляемых.Разрешения Цикл
			Строка.Разрешения.Удалить(КлючИЗначение.Ключ);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Рассчитывает результат применения запросов без учета владельцев.
//
Процедура РассчитатьРезультатПримененияЗапросовБезУчетаВладельцев()
	
	РезультатПримененияЗапросовБезУчетаВладельцев = Новый ТаблицаЗначений();
	
	Для Каждого ИсходнаяКолонка Из ИсходныйСрезРазрешенийБезУчетаВладельцев.Колонки Цикл
		РезультатПримененияЗапросовБезУчетаВладельцев.Колонки.Добавить(ИсходнаяКолонка.Имя, ИсходнаяКолонка.ТипЗначения);
	КонецЦикла;
	
	Для Каждого СтрокаРезультата Из РезультатПримененияЗапросовВРазрезеВладельцев Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", СтрокаРезультата.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", СтрокаРезультата.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("Тип", СтрокаРезультата.Тип);
		
		Строка = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
			РезультатПримененияЗапросовБезУчетаВладельцев, Отбор);
		
		Для Каждого КлючИЗначение Из СтрокаРезультата.Разрешения Цикл
			
			ИсходноеРазрешение = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(КлючИЗначение.Значение);
			ИсходноеРазрешение.Description = ""; // Описания не должны влиять на хэщ-суммы для варианта без учета владельцев
			
			КлючРазрешения = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.КлючРазрешения(ИсходноеРазрешение);
			
			Разрешение = Строка.Разрешения.Получить(КлючРазрешения);
			
			Если Разрешение = Неопределено Тогда
				
				Если СтрокаРезультата.Тип = "FileSystemAccess" Тогда
					
					// Для разрешений на использование каталога файловой системы дополнительно ищем
					// вложенные или объемлющие разрешения
					
					Если ИсходноеРазрешение.AllowedRead Тогда
						
						Если ИсходноеРазрешение.AllowedWrite Тогда
							
							// Выполним поиск разрешения на использование того же каталога, но только для чтения
							
							КопияРазрешения = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ОбщегоНазначения.ОбъектXDTOВСтрокуXML(ИсходноеРазрешение));
							КопияРазрешения.AllowedWrite = Ложь;
							КлючКопии = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.КлючРазрешения(КопияРазрешения);
							
							ВложенноеРазрешение = Строка.Разрешения.Получить(КлючКопии);
							
							Если ВложенноеРазрешение <> Неопределено Тогда
								
								// Удалим вложенное разрешение, после добавления текущего оно будет не нужно
								Строка.Разрешения.Удалить(КлючКопии);
								
							КонецЕсли;
							
						Иначе
							
							// Выоплним поиск разрешения на использование того же каталога, но в т.ч. и для записи
							
							КопияРазрешения = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ОбщегоНазначения.ОбъектXDTOВСтрокуXML(ИсходноеРазрешение));
							КопияРазрешения.AllowedWrite = Истина;
							КлючКопии = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.КлючРазрешения(КопияРазрешения);
							
							ОбъемлющееРазрешение = Строка.Разрешения.Получить(КлючКопии);
							
							Если ОбъемлющееРазрешение <> Неопределено Тогда
								
								// Обрабатывать это разрешение не требуется, каталог будет разрешен за счет объемлющего
								Продолжить;
								
							КонецЕсли;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
				Строка.Разрешения.Вставить(КлючРазрешения, ОбщегоНазначения.ОбъектXDTOВСтрокуXML(ИсходноеРазрешение));
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Рассчитывает дельту двух срезов разрешений в разрезе владельцев разрешений.
//
Процедура РассчитатьДельтуВРазрезеВладельцев()
	
	ДельтаВРазрезеВладельцев = Новый Структура();
	
	ДельтаВРазрезеВладельцев.Вставить("Добавляемые", Новый ТаблицаЗначений);
	ДельтаВРазрезеВладельцев.Добавляемые.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ДельтаВРазрезеВладельцев.Добавляемые.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ДельтаВРазрезеВладельцев.Добавляемые.Колонки.Добавить("ТипВладельца", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ДельтаВРазрезеВладельцев.Добавляемые.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ДельтаВРазрезеВладельцев.Добавляемые.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	ДельтаВРазрезеВладельцев.Добавляемые.Колонки.Добавить("Разрешения", Новый ОписаниеТипов("Соответствие"));
	
	ДельтаВРазрезеВладельцев.Вставить("Удаляемые", Новый ТаблицаЗначений);
	ДельтаВРазрезеВладельцев.Удаляемые.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ДельтаВРазрезеВладельцев.Удаляемые.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ДельтаВРазрезеВладельцев.Удаляемые.Колонки.Добавить("ТипВладельца", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ДельтаВРазрезеВладельцев.Удаляемые.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ДельтаВРазрезеВладельцев.Удаляемые.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	ДельтаВРазрезеВладельцев.Удаляемые.Колонки.Добавить("Разрешения", Новый ОписаниеТипов("Соответствие"));
	
	// Сравниваем исходные разрешения с результирующими
	
	Для Каждого Строка Из ИсходныйСрезРазрешенийВРазрезеВладельцев Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", Строка.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", Строка.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("ТипВладельца", Строка.ТипВладельца);
		Отбор.Вставить("ИдентификаторВладельца", Строка.ИдентификаторВладельца);
		Отбор.Вставить("Тип", Строка.Тип);
		
		Строки = РезультатПримененияЗапросовВРазрезеВладельцев.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			СтрокаРезультата = Строки.Получить(0);
		Иначе
			СтрокаРезультата = Неопределено;
		КонецЕсли;
		
		Для Каждого КлючИЗначение Из Строка.Разрешения Цикл
			
			Если СтрокаРезультата = Неопределено Или СтрокаРезультата.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
				
				// Разрешение было в исходных, но отсутствует в результирующих - это удаляемое разрешение
				
				СтрокаУдаляемых = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
					ДельтаВРазрезеВладельцев.Удаляемые, Отбор);
				
				Если СтрокаУдаляемых.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
					СтрокаУдаляемых.Разрешения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Сравниваем результирующие разрешения с исходными
	
	Для Каждого Строка Из РезультатПримененияЗапросовВРазрезеВладельцев Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", Строка.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", Строка.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("ТипВладельца", Строка.ТипВладельца);
		Отбор.Вставить("ИдентификаторВладельца", Строка.ИдентификаторВладельца);
		Отбор.Вставить("Тип", Строка.Тип);
		
		Строки = ИсходныйСрезРазрешенийВРазрезеВладельцев.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			ИсходнаяСтрока = Строки.Получить(0);
		Иначе
			ИсходнаяСтрока = Неопределено;
		КонецЕсли;
		
		Для Каждого КлючИЗначение Из Строка.Разрешения Цикл
			
			Если ИсходнаяСтрока = Неопределено ИЛИ ИсходнаяСтрока.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
				
				// Разрешение есть в результирующих, но отсутствует в исходных - это добавляемое разрешение
				
				СтрокаДобавляемых = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
					ДельтаВРазрезеВладельцев.Добавляемые, Отбор);
				
				Если СтрокаДобавляемых.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
					СтрокаДобавляемых.Разрешения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Рассчитывает дельту двух срезов разрешений без учета владельцев разрешений.
//
Процедура РассчитатьДельтуБезУчетаВладельцев()
	
	ДельтаБезУчетаВладельцев = Новый Структура();
	
	ДельтаБезУчетаВладельцев.Вставить("Добавляемые", Новый ТаблицаЗначений);
	ДельтаБезУчетаВладельцев.Добавляемые.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ДельтаБезУчетаВладельцев.Добавляемые.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ДельтаБезУчетаВладельцев.Добавляемые.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	ДельтаБезУчетаВладельцев.Добавляемые.Колонки.Добавить("Разрешения", Новый ОписаниеТипов("Соответствие"));
	
	ДельтаБезУчетаВладельцев.Вставить("Удаляемые", Новый ТаблицаЗначений);
	ДельтаБезУчетаВладельцев.Удаляемые.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ДельтаБезУчетаВладельцев.Удаляемые.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ДельтаБезУчетаВладельцев.Удаляемые.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	ДельтаБезУчетаВладельцев.Удаляемые.Колонки.Добавить("Разрешения", Новый ОписаниеТипов("Соответствие"));
	
	// Сравниваем исходные разрешения с результирующими
	
	Для Каждого Строка Из ИсходныйСрезРазрешенийБезУчетаВладельцев Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", Строка.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", Строка.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("Тип", Строка.Тип);
		
		Строки = РезультатПримененияЗапросовБезУчетаВладельцев.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			СтрокаРезультата = Строки.Получить(0);
		Иначе
			СтрокаРезультата = Неопределено;
		КонецЕсли;
		
		Для Каждого КлючИЗначение Из Строка.Разрешения Цикл
			
			Если СтрокаРезультата = Неопределено ИЛИ СтрокаРезультата.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
				
				// Разрешение было в исходных, но отсутствует в результирующих - это удаляемое разрешение
				
				СтрокаУдаляемых = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
					ДельтаБезУчетаВладельцев.Удаляемые, Отбор);
				
				Если СтрокаУдаляемых.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
					СтрокаУдаляемых.Разрешения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Сравниваем результирующие разрешения с исходными
	
	Для Каждого Строка Из РезультатПримененияЗапросовБезУчетаВладельцев Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ТипПрограммногоМодуля", Строка.ТипПрограммногоМодуля);
		Отбор.Вставить("ИдентификаторПрограммногоМодуля", Строка.ИдентификаторПрограммногоМодуля);
		Отбор.Вставить("Тип", Строка.Тип);
		
		Строки = ИсходныйСрезРазрешенийБезУчетаВладельцев.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			ИсходнаяСтрока = Строки.Получить(0);
		Иначе
			ИсходнаяСтрока = Неопределено;
		КонецЕсли;
		
		Для Каждого КлючИЗначение Из Строка.Разрешения Цикл
			
			Если ИсходнаяСтрока = Неопределено ИЛИ ИсходнаяСтрока.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
				
				// Разрешение есть в результирующих, но отсутствует в исходных - это добавляемое разрешение
				
				СтрокаДобавляемых = РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.СтрокаТаблицыРазрешений(
					ДельтаБезУчетаВладельцев.Добавляемые, Отбор);
				
				Если СтрокаДобавляемых.Разрешения.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
					СтрокаДобавляемых.Разрешения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДельтаБезУчетаВладельцев() Экспорт
	
	Возврат ДельтаБезУчетаВладельцев;
	
КонецФункции

// Проверяет необходимость применения разрешений в кластере серверов.
//
// Возвращаемое значение: Булево.
//
Функция ТребуетсяПрименениеРазрешенийВКластереСерверов() Экспорт
	
	Возврат ДельтаБезУчетаВладельцев.Добавляемые.Количество() > 0 ИЛИ ДельтаБезУчетаВладельцев.Удаляемые.Количество() > 0;
	
КонецФункции

// Проверяет необходимости записи разрешений в регистры.
//
// Возвращаемое значение: Булево.
//
Функция ТребуетсяЗаписьРазрешенийВРегистр() Экспорт
	
	Возврат ДельтаВРазрезеВладельцев.Добавляемые.Количество() > 0 ИЛИ ДельтаВРазрезеВладельцев.Удаляемые.Количество() > 0;
	
КонецФункции

// Сериализует внутренее состояние объекта.
//
// Возвращаемое значение - Строка.
//
Функция ЗаписатьСостояниеВСтрокуXML() Экспорт
	
	Состояние = Новый Структура();
	
	Состояние.Вставить("ИсходныйСрезРазрешенийВРазрезеВладельцев", ИсходныйСрезРазрешенийВРазрезеВладельцев);
	Состояние.Вставить("РезультатПримененияЗапросовВРазрезеВладельцев", РезультатПримененияЗапросовВРазрезеВладельцев);
	Состояние.Вставить("ДельтаВРазрезеВладельцев", ДельтаВРазрезеВладельцев);
	Состояние.Вставить("ИсходныйСрезРазрешенийБезУчетаВладельцев", ИсходныйСрезРазрешенийБезУчетаВладельцев);
	Состояние.Вставить("РезультатПримененияЗапросовБезУчетаВладельцев", РезультатПримененияЗапросовБезУчетаВладельцев);
	Состояние.Вставить("ДельтаБезУчетаВладельцев", ДельтаБезУчетаВладельцев);
	Состояние.Вставить("ИдентификаторыЗапросов", ИдентификаторыЗапросов);
	
	Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(Состояние);
	
КонецФункции

// Десериализует внутреннее состояние объекта.
//
// Параметры:
//  СтрокаXML - Строка - результат, возвращенный функцией ЗаписатьСостояниеВСтрокуXML().
//
Процедура ПрочитатьСостояниеИзСтрокиXML(Знач СтрокаXML) Экспорт
	
	Состояние = ОбщегоНазначения.ЗначениеИзСтрокиXML(СтрокаXML);
	
	ИсходныйСрезРазрешенийВРазрезеВладельцев = Состояние.ИсходныйСрезРазрешенийВРазрезеВладельцев;
	РезультатПримененияЗапросовВРазрезеВладельцев = Состояние.РезультатПримененияЗапросовВРазрезеВладельцев;
	ДельтаВРазрезеВладельцев = Состояние.ДельтаВРазрезеВладельцев;
	ИсходныйСрезРазрешенийБезУчетаВладельцев = Состояние.ИсходныйСрезРазрешенийБезУчетаВладельцев;
	РезультатПримененияЗапросовБезУчетаВладельцев = Состояние.РезультатПримененияЗапросовБезУчетаВладельцев;
	ДельтаБезУчетаВладельцев = Состояние.ДельтаБезУчетаВладельцев;
	ИдентификаторыЗапросов = Состояние.ИдентификаторыЗапросов;
	
КонецПроцедуры

// Фиксирует в ИБ факт применения запросов на использование внешних ресурсов.
//
Процедура ЗавершитьПрименениеЗапросовНаИспользованиеВнешнихРесурсов() Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Если ТребуетсяЗаписьРазрешенийВРегистр() Тогда
			
			Для Каждого Удаляемые Из ДельтаВРазрезеВладельцев.Удаляемые Цикл
				
				Для Каждого КлючИЗначение Из Удаляемые.Разрешения Цикл
					
					РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.УдалитьРазрешение(
						Удаляемые.ТипПрограммногоМодуля,
						Удаляемые.ИдентификаторПрограммногоМодуля,
						Удаляемые.ТипВладельца,
						Удаляемые.ИдентификаторВладельца,
						КлючИЗначение.Ключ,
						ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(КлючИЗначение.Значение));
					
				КонецЦикла;
				
			КонецЦикла;
			
			Для Каждого Добавляемые Из ДельтаВРазрезеВладельцев.Добавляемые Цикл
				
				Для Каждого КлючИЗначение Из Добавляемые.Разрешения Цикл
					
					РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.ДобавитьРазрешение(
						Добавляемые.ТипПрограммногоМодуля,
						Добавляемые.ИдентификаторПрограммногоМодуля,
						Добавляемые.ТипВладельца,
						Добавляемые.ИдентификаторВладельца,
						КлючИЗначение.Ключ,
						ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(КлючИЗначение.Значение));
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
		РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.УдалитьЗапросы(ИдентификаторыЗапросов);
		РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.ОчиститьНеактуальныеЗапросы();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтменитьПримененияЗапросовНаИспользованиеВУнешнихРесурсов() Экспорт
	
	РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.УдалитьЗапросы(ИдентификаторыЗапросов);
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияОбъекта

ИдентификаторыЗапросов = Новый Массив();

ПланПримененияЗапросов = Новый Структура();

ПланПримененияЗапросов.Вставить("Замещаемые", Новый ТаблицаЗначений);
ПланПримененияЗапросов.Замещаемые.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
ПланПримененияЗапросов.Замещаемые.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
ПланПримененияЗапросов.Замещаемые.Колонки.Добавить("ТипВладельца", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
ПланПримененияЗапросов.Замещаемые.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("УникальныйИдентификатор"));

ПланПримененияЗапросов.Вставить("Добавляемые", Новый ТаблицаЗначений);
ПланПримененияЗапросов.Добавляемые.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
ПланПримененияЗапросов.Добавляемые.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
ПланПримененияЗапросов.Добавляемые.Колонки.Добавить("ТипВладельца", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
ПланПримененияЗапросов.Добавляемые.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("УникальныйИдентификатор"));
ПланПримененияЗапросов.Добавляемые.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
ПланПримененияЗапросов.Добавляемые.Колонки.Добавить("Разрешения", Новый ОписаниеТипов("Соответствие"));

ПланПримененияЗапросов.Вставить("Удаляемые", Новый ТаблицаЗначений);
ПланПримененияЗапросов.Удаляемые.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
ПланПримененияЗапросов.Удаляемые.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
ПланПримененияЗапросов.Удаляемые.Колонки.Добавить("ТипВладельца", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
ПланПримененияЗапросов.Удаляемые.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("УникальныйИдентификатор"));
ПланПримененияЗапросов.Удаляемые.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
ПланПримененияЗапросов.Удаляемые.Колонки.Добавить("Разрешения", Новый ОписаниеТипов("Соответствие"));

ОперацииАдминистрирования = Новый ТаблицаЗначений;
ОперацииАдминистрирования.Колонки.Добавить("ТипПрограммногоМодуля", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
ОперацииАдминистрирования.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
ОперацииАдминистрирования.Колонки.Добавить("Операция", Новый ОписаниеТипов("ПеречислениеСсылка.ОперацииАдминистрированияПрофилейБезопасности"));
ОперацииАдминистрирования.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));

#КонецОбласти

#КонецЕсли
