
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Физлицо") Тогда
		Физлицо = Параметры.Отбор.Физлицо;
		
		Если ТипЗнч(ФизЛицо) = Тип("СправочникСсылка.Партнеры") Тогда
			Физлицо = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Физлицо);
			СтандартнаяОбработка = Ложь;
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ФизЛицо", ФизЛицо);
		КонецЕсли;
		
		УдостоверениеЛичности = РегистрыСведений.ДокументыФизическихЛиц.ДокументУдостоверяющийЛичностьФизлица(Физлицо);
		
		ЕстьУдостоверение = Не ПустаяСтрока(УдостоверениеЛичности);
		
		Элементы.УдостоверениеЛичности.Высота		= ?(ЕстьУдостоверение, 2, 0);
		УдостоверениеЛичности = ?(ЕстьУдостоверение, НСтр("ru='Удостоверение личности';uk='Посвідчення особи'") + ": ", "") + УдостоверениеЛичности;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Физлицо",	Физлицо);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДокументыФизическихЛиц.Представление
		|ИЗ
		|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
		|ГДЕ
		|	ДокументыФизическихЛиц.Физлицо = &Физлицо";
		ЕстьДокументы = Не Запрос.Выполнить().Пустой();
		
		Если Не ЕстьУдостоверение И ЕстьДокументы Тогда
			Элементы.НетУдостоверения.Видимость		= Истина;
			ТекстСообщения = НСтр("ru='Для физлица %1 не задан документ, удостоверяющий личность.';uk='Для фізособи %1 не заданий документ, що засвідчує особистість.'");
			УдостоверениеЛичности = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Физлицо);
		КонецЕсли;
		
		Элементы.УдостоверениеЛичности.Видимость	= Не ПустаяСтрока(УдостоверениеЛичности);
	КонецЕсли;
	
	//++ НЕ УТ
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	//++ НЕ УТ
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Истина);
	//-- НЕ УТ
	Возврат; // в УТ11 не используется
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	//++ НЕ УТ
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект);
	//-- НЕ УТ
	Возврат; // в УТ11 не используется
КонецПроцедуры

#КонецОбласти
