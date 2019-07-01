////////////////////////////////////////////////////////////////////////////////
// Подсистема "Версионирование объектов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается для получения версионируемых табличных документов во время записи версии объекта.
// 
// Параметры:
//  Ссылка - Ссылка на версионируемый объект конфигурации.
//  ТабличныеДокументы - Структура - содержит данные:
//   * Ключ     - Строка    - Имя табличного документа;
//   * Значение - Структура - содержит поля:
//                 * Наименование - Строка - Наименование табличного документа;
//                 * Данные       - ТабличныйДокумент - версионируемый табличный документ.
//
// Возвращаемое значение:
//
Процедура ПриПолученииТабличныхДокументовОбъекта(Ссылка, ТабличныеДокументы) Экспорт
	
	//++ НЕ УТКА
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЭкземплярБюджета") Тогда
		
		ТабличныйДокумент = Документы.ЭкземплярБюджета.СформироватьТабличныйДокументЭкземпляраБюджета(Ссылка);
		
		Для НомерСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
			Для НомерСтолбца = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
				ТабличныйДокумент.Область(НомерСтроки, НомерСтолбца, НомерСтроки, НомерСтолбца).Расшифровка = Неопределено;
			КонецЦикла;			
		КонецЦикла;
		
		ТабличныйДокумент.ФиксацияСлева = 0;
		ТабличныйДокумент.ФиксацияСверху = 0;
		
		ТабличныеДокументы.Вставить("Бюджет", Новый Структура("Наименование, Данные", "Бюджет", ТабличныйДокумент));
		
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

// Вызывается после разбора прочитанной из регистра версии объекта,
//  может использоваться для дополнительной обработки результата разбора версии.
// 
// Параметры:
//  Ссылка    - Ссылка на версионируемый объект конфигурации.
//  Результат - Структура - Результат разбора версии подсистемой версионирования.
//
Процедура ПослеРазбораВерсииОбъекта(Ссылка, Результат) Экспорт
	
	//++ НЕ УТКА
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЭкземплярБюджета") Тогда
		
		Если Результат.Свойство("ТабличныеЧасти") Тогда
			Результат.ТабличныеЧасти.Очистить();
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

// Вызывается после определения реквизитов объекта из формы 
// РегистрСведений.ВерсииОбъектов.ВыборРеквизитовОбъекта.
// 
// Параметры:
//  Ссылка    - Ссылка на версионируемый объект конфигурации.
//  ДеревоРеквизитов - ДанныеФормыДерево - Дерево реквизитов объектов.
//
Процедура ПриВыбореРеквизитовОбъекта(Ссылка, ДеревоРеквизитов) Экспорт
	
	//++ НЕ УТКА
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЭкземплярБюджета") Тогда
		
		КоллекцияРеквизитовОбъекта = ДеревоРеквизитов.ПолучитьЭлементы();
		
		ВидыАналитикВидаБюджета = ФинансоваяОтчетностьПовтИсп.ВидыАналитикЭкземпляраБюджета(Ссылка);
		
		КУдалению = Новый Массив;
		Для Каждого ЭлементКоллекции из КоллекцияРеквизитовОбъекта Цикл
			Если ЭлементКоллекции.Имя = "АналитикаСтатейБюджетов"
				ИЛИ ЭлементКоллекции.Имя = "ОборотыПоСтатьямБюджетов"
				ИЛИ ЭлементКоллекции.Имя = "АналитикаЗначений" Тогда
				КУдалению.Добавить(ЭлементКоллекции);
			ИначеЕсли Найти(ЭлементКоллекции.Имя, "Аналитика") Тогда
				НомерАналитики = Число(СтрЗаменить(ЭлементКоллекции.Имя, "Аналитика", ""));
				Если НомерАналитики > ВидыАналитикВидаБюджета.Количество() Тогда
					КУдалению.Добавить(ЭлементКоллекции);
				Иначе
					ЭлементКоллекции.Синоним = ВидыАналитикВидаБюджета[НомерАналитики - 1].Наименование;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементКоллекции ИЗ КУдалению Цикл
			КоллекцияРеквизитовОбъекта.Удалить(ЭлементКоллекции);
		КонецЦикла;
		
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

// Вызывается при получении представления реквизита объекта.
// 
// Параметры:
//  Ссылка    - Ссылка на версионируемый объект конфигурации.
//  ИмяРеквизита - Строка - ИмяРеквизита как задано в конфигураторе.
//  НаименованиеРеквизита - Строка - выходной параметр, можно переопределить полученный синоним.
//  Видимость - Булево - выводить реквизит в отчетах по версиям.
//
Процедура ПриОпределенииНаименованияРеквизитаОбъекта(Ссылка, ИмяРеквизита, НаименованиеРеквизита, Видимость) Экспорт
	
	//++ НЕ УТКА
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЭкземплярБюджета") Тогда
		ЭтоАналитика = Найти(ИмяРеквизита, "Аналитика") И СтрДлина(ИмяРеквизита) = СтрДлина("Аналитика") + 1;
		Если Не ЭтоАналитика Тогда
			Возврат;
		КонецЕсли;
		
		ВидыАналитикВидаБюджета = ФинансоваяОтчетностьПовтИсп.ВидыАналитикЭкземпляраБюджета(Ссылка);
		
		НомерАналитики = Число(СтрЗаменить(ИмяРеквизита, "Аналитика", ""));
		Если НомерАналитики > ВидыАналитикВидаБюджета.Количество() Тогда
			НаименованиеРеквизита = "";
			Видимость = Истина;
		Иначе
			НаименованиеРеквизита = ВидыАналитикВидаБюджета[НомерАналитики - 1].Наименование
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТКА
	
КонецПроцедуры

// Дополняет объект реквизитами, хранящимися отдельно от объекта, либо в служебной части самого объекта,
// не предназначенной для вывода в отчетах.
Процедура ПриПодготовкеДанныхОбъекта(Объект, ДополнительныеРеквизиты) Экспорт 
	
КонецПроцедуры

// Восстанавливает значения реквизитов объекта, хранящихся отдельно от объекта.
Процедура ПриВосстановленииВерсииОбъекта(Объект, ДополнительныеРеквизиты) Экспорт
	
КонецПроцедуры

#КонецОбласти