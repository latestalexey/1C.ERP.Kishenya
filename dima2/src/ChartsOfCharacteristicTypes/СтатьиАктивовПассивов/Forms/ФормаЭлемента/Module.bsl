
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.Свойство("ЗначенияЗаполнения") И Параметры.ЗначенияЗаполнения.Свойство("АктивПассив") Тогда
			Объект.АктивПассив = Параметры.ЗначенияЗаполнения.АктивПассив;
		Иначе
			Объект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьСписокВыбораТиповЗначенийАналитики();
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ПустаяСтрока(ТипЗначения) Тогда
		ТекущийОбъект.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);
	КонецЕсли;
	Если АктивПассив = "Актив" Тогда
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
	Иначе
		ТекущийОбъект.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Пассив;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьПризнакАктивПассив();
	УстановитьТипЗначения(Объект.ТипЗначения);
	УправлениеВидимостью();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивПассивПриИзменении(Элемент)
	ЗаполнитьСписокВыбораТиповЗначенийАналитики()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивов(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Данные еще не записаны.
        |Переход к значениям прочих активов и пассивов возможен только после записи данных.
        |Данные будут записаны.'
        |;uk='Дані ще не записані.
        |Перехід до значень інших активів і пасивів можливий тільки після запису даних.
        |Дані будуть записані.'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗначенияПрочихАктивовПассивовЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
        Возврат;
		
	КонецЕсли;
	
	ЗначенияПрочихАктивовПассивовФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
        Возврат;
    КонецЕсли;
    
    Попытка
        ЭлементЗаписан = Записать();
    Исключение
        Возврат;
    КонецПопытки;
    
    Если Не ЭлементЗаписан Тогда
        Возврат;
    КонецЕсли;
    
    
    ЗначенияПрочихАктивовПассивовФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПрочихАктивовПассивовФрагмент()
    
    СтруктураОтбора = Новый Структура("Владелец", Объект.Ссылка);
    ПараметрыФормы = Новый структура("Отбор", СтруктураОтбора);
    ОткрытьФорму("Справочник.ПрочиеАктивыПассивы.ФормаСписка", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаКлиенте
Процедура УправлениеВидимостью()
	
	Если ТипЗначения = "СправочникСсылка.ПрочиеАктивыПассивы" Тогда
		Элементы.СтраницыПрочиеАктивыПассивы.ТекущаяСтраница = Элементы.СтраницаЗначенияПрочихАктивовПассивов;
	Иначе
		Элементы.СтраницыПрочиеАктивыПассивы.ТекущаяСтраница = Элементы.СтраницаПрочиеАктивыПассивыПустая;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораТиповЗначенийАналитики()
	
	СписокТиповЗначенийАналитик = Новый СписокЗначений;
	Элементы.ТипЗначения.СписокВыбора.Очистить();
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.СтруктураПредприятия", НСтр("ru='Подразделение';uk='Підрозділ'"));
	КонецЕсли;
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.ФизическиеЛица", НСтр("ru='Физическое лицо';uk='Фізична особа'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.Партнеры", НСтр("ru='Партнер';uk='Партнер'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.Контрагенты", НСтр("ru='Контрагент';uk='Контрагент'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.Номенклатура", НСтр("ru='Позиция номенклатуры';uk='Позиція номенклатури'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.БанковскиеСчетаОрганизаций", НСтр("ru='Банковский счет организации';uk='Банківський рахунок організації'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.СтатьиДвиженияДенежныхСредств", НСтр("ru='Статья движения денежных средств';uk='Стаття руху грошових коштів'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.Организации", НСтр("ru='Организация';uk='Організація'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.Склады", НСтр("ru='Склад (складская территория)';uk='Склад (складська територія)'"));
	СписокТиповЗначенийАналитик.Добавить("ПеречислениеСсылка.ТипыНалогов", НСтр("ru='Типы налогов';uk='Типи податків'"));
//++ НЕ УТ
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.НематериальныеАктивы", НСтр("ru='Нематериальный актив';uk='Нематеріальний актив'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.ОбъектыЭксплуатации", НСтр("ru='Основное средство';uk='Основний засіб'"));
	СписокТиповЗначенийАналитик.Добавить("ПеречислениеСсылка.ВидыПлатежейВГосБюджет", НСтр("ru='Вид платежа в бюджет';uk='Вид платежу до бюджету'"));
	СписокТиповЗначенийАналитик.Добавить("ПеречислениеСсылка.ВидыОперацийПоЗарплате", НСтр("ru='Вид операции по зарплате';uk='Вид операції з зарплати'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.Резервы", НСтр("ru='Резерв';uk='Резерв'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.НаправленияИспользованияПрибыли", НСтр("ru='Направление использования прибыли';uk='Напрямок використання прибутку'"));
	СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.ДоговорыЛизинга", НСтр("ru='Договор лизинга';uk='Договір лізингу'"));
//-- НЕ УТ
	Если ПустаяСтрока(АктивПассив) Тогда
		АктивПассив = Строка(Перечисления.ВидыСтатейУправленческогоБаланса.Пассив);
	КонецЕсли;
	Если АктивПассив = "Пассив" Тогда
		СписокТиповЗначенийАналитик.Добавить("СправочникСсылка.НаправленияДеятельности", НСтр("ru='Направление деятельности';uk='Напрям діяльності'"));
	КонецЕсли;

	Для Каждого ДобавляемыйЭлемент Из СписокТиповЗначенийАналитик Цикл
		Элементы.ТипЗначения.СписокВыбора.Добавить(ДобавляемыйЭлемент.Значение, ДобавляемыйЭлемент.Представление);
	КонецЦикла;
	
	Элементы.ТипЗначения.СписокВыбора.СортироватьПоПредставлению();
	Элементы.ТипЗначения.СписокВыбора.Добавить("СправочникСсылка.ПрочиеАктивыПассивы", "Прочий актив или пассив");
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановитьТипЗначения(ВыбранныйТипЗначения)
	
	СписокТиповЗначений = Новый СписокЗначений;
	СписокТиповЗначений.Добавить("СправочникСсылка.СтруктураПредприятия");
	СписокТиповЗначений.Добавить("СправочникСсылка.Партнеры");
	СписокТиповЗначений.Добавить("СправочникСсылка.Контрагенты");
	СписокТиповЗначений.Добавить("СправочникСсылка.Организации");
	СписокТиповЗначений.Добавить("СправочникСсылка.Склады");
	СписокТиповЗначений.Добавить("СправочникСсылка.Номенклатура");
	СписокТиповЗначений.Добавить("СправочникСсылка.ФизическиеЛица");
	СписокТиповЗначений.Добавить("СправочникСсылка.БанковскиеСчетаОрганизаций");
	СписокТиповЗначений.Добавить("СправочникСсылка.СтатьиДвиженияДенежныхСредств");
	СписокТиповЗначений.Добавить("СправочникСсылка.ПрочиеАктивыПассивы");
	СписокТиповЗначений.Добавить("ПеречислениеСсылка.ТипыНалогов");
	//++ НЕ УТ
	СписокТиповЗначений.Добавить("СправочникСсылка.НематериальныеАктивы");
	СписокТиповЗначений.Добавить("СправочникСсылка.ОбъектыЭксплуатации");
	СписокТиповЗначений.Добавить("СправочникСсылка.НаправленияИспользованияПрибыли");
	СписокТиповЗначений.Добавить("ПеречислениеСсылка.ВидыПлатежейВГосБюджет");
	СписокТиповЗначений.Добавить("ПеречислениеСсылка.ВидыОперацийПоЗарплате");
	СписокТиповЗначений.Добавить("СправочникСсылка.Резервы");
	СписокТиповЗначений.Добавить("СправочникСсылка.ДоговорыЛизинга");
	СписокТиповЗначений.Добавить("СправочникСсылка.НаправленияДеятельности");
	//-- НЕ УТ
	
	Для Каждого ЭлементСписка Из СписокТиповЗначений Цикл
		Если ВыбранныйТипЗначения.СодержитТип(Тип(ЭлементСписка.Значение)) Тогда
			ТипЗначения = ЭлементСписка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПризнакАктивПассив()
	
	Если Объект.АктивПассив = ПредопределенноеЗначение("Перечисление.ВидыСтатейУправленческогоБаланса.Актив") Тогда
		АктивПассив = "Актив";
	Иначе
		АктивПассив = "Пассив";
	КонецЕсли;
	
Конецпроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЭтоПредопределенныйЭлемент", Объект.Предопределенный);
		Результат = Неопределено;

		ОткрытьФорму("ПланВидовХарактеристик.СтатьиАктивовПассивов.Форма.РазблокированиеРеквизитов", ПараметрыФормы,,,,, Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
    ИначеЕсли ТипЗнч(Результат) = Тип("Строка") Тогда
        ПоказатьПредупреждение(Неопределено, Результат);
    КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
