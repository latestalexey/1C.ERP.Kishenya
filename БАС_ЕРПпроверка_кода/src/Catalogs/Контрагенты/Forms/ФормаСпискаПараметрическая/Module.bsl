
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ПредставлениеОбособленногоПодразделения",
		НСтр("ru='Обособленное подразделение';uk='Відокремлений підрозділ'"));
	
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	ДоступноДобавлениеПартнеров = ПравоДоступа("Добавление", Метаданные.Справочники.Партнеры);
	
	Если Параметры.Свойство("ОтборКонтрагентов") Тогда
		
		КлючНастроек = "ФормаСпискаПараметрическая" + Параметры.ОтборКонтрагентов.УникальныйИдентификатор();
		ЗагрузитьНастройки();
		
		Если ТипЗнч(Параметры.ОтборКонтрагентов) = Тип("СправочникСсылка.Партнеры") Тогда
			
			//учесть возможность просмотра по группе партнеров
			Партнер = Параметры.ОтборКонтрагентов;
			УстановитьОтборСпискаПоПараметруПартнерСервер();
			
		КонецЕсли;
		
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты);
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокСправочника" Тогда
		Если Параметр.Свойство("ОтборКонтрагентов")
			И ТипЗнч(Параметр.ОтборКонтрагентов) = Тип("СправочникСсылка.Партнеры") Тогда
			
			Если Параметр.ОтборКонтрагентов = Партнер Тогда
				Возврат;
			КонецЕсли;
			Партнер = Параметр.ОтборКонтрагентов;
			УстановитьОтборСпискаПоПараметруПартнерСервер()
			
		Иначе
			Элементы.Список.Обновить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьГрупповыеПриИзменении(Элемент)

	УстановитьОтборПартнеров(ПоказыватьГрупповые);
	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ГоловнойКонтрагент Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные.ОбособленноеПодразделение И Не ЗначениеЗаполнено(ТекущиеДанные.ГоловнойКонтрагент) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПараметрыЗаполнения = Новый Структура;
			ПараметрыЗаполнения.Вставить("Контрагент", ТекущиеДанные.Ссылка);
			ПараметрыЗаполнения.Вставить("ИННПлательщикаНДС", ТекущиеДанные.ИННПлательщикаНДС);
			ПараметрыЗаполнения.Вставить("Партнер",    ТекущиеДанные.Партнер);
			ПараметрыЗаполнения.Вставить("ИспользоватьПартнеровКакКонтрагентов", ИспользоватьПартнеровКакКонтрагентов);
			
			Оповещение = Новый ОписаниеОповещения("ЗаполнитьГоловногоКонтрагентаЗавершение", ЭтотОбъект);
			ПартнерыИКонтрагентыКлиент.ЗаполнитьГоловногоКонтрагента(ЭтотОбъект, ПараметрыЗаполнения, Истина, Оповещение);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Если ПоказыватьГрупповые И (НЕ Копирование) Тогда
		Отказ = Истина;
		ОткрытьФорму(
			"Справочник.Контрагенты.ФормаОбъекта",
			Новый Структура("Основание", Новый Структура("Партнер", Партнер)));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПартнера(Команда)
	
	ТипГруппировка = Тип("СтрокаГруппировкиДинамическогоСписка");
		
	Если Элементы.Список.ТекущаяСтрока = ТипГруппировка ИЛИ Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтрагентОснование = Новый Структура;
	КонтрагентОснование.Вставить("Ссылка", Элементы.Список.ТекущиеДанные.Ссылка);
	
	ПараметрыОткрытия = Новый Структура("КонтрагентОснование", КонтрагентОснование);
	
	ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового", ПараметрыОткрытия, ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	ПартнерыИКонтрагенты.УстановитьОформлениеГоловногоКонтрагентаВСписке(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПартнеров(УстановитьДляГруппы = Истина)
	
	ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список).Элементы.Очистить();
	
	Если УстановитьДляГруппы Тогда
		
		//создать элемент группы - отбор по партнеру
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Партнер",
			СписокПартнеров,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Партнер",
			Партнер,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПартнеровСервер(УстановитьДляГруппы = Истина)
	
	ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список).Элементы.Очистить();
	
	Если УстановитьДляГруппы Тогда
		
		//создать элемент группы - отбор по партнеру
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", СписокПартнеров, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", Партнер, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСпискаПоПараметруПартнерСервер()
	
	ВидимостьКомандыСозданияПартнеров = Ложь;
	
	 Если Партнер = Справочники.Партнеры.НеизвестныйПартнер Или Партнер = Справочники.Партнеры.РозничныйПокупатель Тогда
		ВидимостьКомандыСозданияПартнеров = Истина;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Партнер,СписокПартнеров);
	Элементы.ПоказыватьГрупповые.Видимость = СписокПартнеров.Количество() > 1 ;
	УстановитьОтборПартнеровСервер(ПоказыватьГрупповые);

	Если ВидимостьКомандыСозданияПартнеров Тогда
		Элементы.ФормаСоздатьПартнера.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	Перем Настройки;
	
	Настройки = Новый Соответствие;
	Настройки.Вставить("ПоказыватьГрупповые",ПоказыватьГрупповые);
	Настройки.Вставить("ПоПартнеру", ПоПартнеру);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Справочники.Контрагенты", КлючНастроек, Настройки);

КонецПроцедуры 

&НаСервере
Процедура ЗагрузитьНастройки()

	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Справочники.Контрагенты", КлючНастроек);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда
		ПоказыватьГрупповые = ЗначениеНастроек.Получить("ПоказыватьГрупповые");
		ПоПартнеру          = ЗначениеНастроек.Получить("ПоПартнеру");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГоловногоКонтрагентаЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти