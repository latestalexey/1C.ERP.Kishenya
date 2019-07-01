
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УправлениеЭлементамиФормы();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	                              ЭтотОбъект, "ДанныеКонтрагентаСуммаДолгПартнера", НСтр("ru='Долг контрагента';uk='Борг контрагента'"));

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеЭлементамиФормы();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовПоСтатусу();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		Если ТекущийЭлемент <> Неопределено Тогда
			Если ТекущийЭлемент.Имя = "КонтактноеЛицо" Тогда
				Объект.КонтактноеЛицо = ВыбранноеЗначение;
			ИначеЕсли ТекущийЭлемент.Имя = "ФИОРуководителяКонтрагента" Тогда
				Объект.ФИОРуководителяКонтрагента = Строка(ВыбранноеЗначение);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ФИОРуководителяКонтактноеЛицоНачалоВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовПоСтатусу();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияВзаиморасчетовНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Партнер", Объект.Партнер);
	СтруктураПараметров.Вставить("Договор", Объект.Договор);
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("Контрагент", Объект.Контрагент);
	СтруктураПараметров.Вставить("РасшифровкаПоЗаказам", Объект.РасшифровкаПоЗаказам);
	СтруктураПараметров.Вставить("РасшифровкаПоПартнерам", Объект.РасшифровкаПоПартнерам);
	СтруктураПараметров.Вставить("РасшифровкаПоДоговорам", Объект.РасшифровкаПоДоговорам);
	
	ОткрытьФорму("Документ.СверкаВзаиморасчетов.Форма.ФормаНастройкиДетализации", СтруктураПараметров,,,,, 
		Новый ОписаниеОповещения("ДетализацияВзаиморасчетовНажатиеПослеНастройки", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияВзаиморасчетовНажатиеПослеНастройки(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Структура") Тогда
        
        ПрименитьНастройкиДетализации = Истина;
        
        Если Объект.ДанныеКонтрагента.Количество() > 0
            И ((Объект.РасшифровкаПоЗаказам И НЕ Результат.РасшифровкаПоЗаказам)
            ИЛИ (Объект.РасшифровкаПоПартнерам И НЕ Результат.РасшифровкаПоПартнерам)
            ИЛИ (Объект.РасшифровкаПоДоговорам И НЕ Результат.РасшифровкаПоДоговорам)) Тогда
            
            ТекстВопроса = НСтр("ru='Свернуть строки табличной части в соответствии
            |с настройками детализации взаиморасчетов?'
            |;uk='Згорнути рядки табличної частини відповідно
            |з настройками деталізації взаєморозрахунків?'");
            
            КнопкиДиалогаВопрос = Новый СписокЗначений;
            КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Да, 	НСтр("ru='Свернуть';uk='Згорнути'"));
            КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отменить';uk='Скасувати'"));
            
            КодОтвета = Неопределено;
            
            
            ПоказатьВопрос(Новый ОписаниеОповещения("ДетализацияВзаиморасчетовНажатиеЗавершение", ЭтотОбъект, Новый Структура("ПрименитьНастройкиДетализации, Результат", ПрименитьНастройкиДетализации, Результат)), ТекстВопроса, КнопкиДиалогаВопрос);
            Возврат;
            
        КонецЕсли;
        
        ДетализацияВзаиморасчетовНажатиеФрагмент(ПрименитьНастройкиДетализации, Результат);
        
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДетализацияВзаиморасчетовНажатиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ПрименитьНастройкиДетализации = ДополнительныеПараметры.ПрименитьНастройкиДетализации;
    Результат = ДополнительныеПараметры.Результат;
    
    
    КодОтвета = РезультатВопроса;
    
    Если КодОтвета = КодВозвратаДиалога.Да Тогда
        СвернутьТабличнуюЧастьПоДетализацииВзаиморасчетов(Результат);
    Иначе
        ПрименитьНастройкиДетализации = Ложь;
    КонецЕсли;
    
    
    ДетализацияВзаиморасчетовНажатиеФрагмент(ПрименитьНастройкиДетализации, Результат);

КонецПроцедуры

&НаКлиенте
Процедура ДетализацияВзаиморасчетовНажатиеФрагмент(Знач ПрименитьНастройкиДетализации, Знач Результат)
    
    Если ПрименитьНастройкиДетализации Тогда
        
        Объект.Партнер = Результат.Партнер;
        Объект.Договор = Результат.Договор;
        Объект.РасшифровкаПоЗаказам = Результат.РасшифровкаПоЗаказам;
        Объект.РасшифровкаПоПартнерам = Результат.РасшифровкаПоПартнерам;
        Объект.РасшифровкаПоДоговорам = Результат.РасшифровкаПоДоговорам;
        
        ЭтаФорма.Модифицированность = Истина;
        
        УправлениеЭлементамиФормы();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ФИОРуководителяКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ФИОРуководителяКонтактноеЛицоНачалоВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеконтрагента

&НаКлиенте
Процедура ДанныеКонтрагентаРасчетныйДокументПриИзменении(Элемент)

	ТекущиеДанные = Элементы.ДанныеКонтрагента.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.РасчетныйДокумент) Тогда
		
		ЗаполнитьСтрокуПоРасчетномуДокументуСервер(ТекущиеДанные.РасчетныйДокумент,
												   ТекущиеДанные.ОписаниеДокумента,
												   ТекущиеДанные.ВалютаВзаиморасчетов);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Контрагент");
	СтруктураРеквизитов.Вставить("КонецПериода");
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоОстаткамЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма,
		Объект.ДанныеКонтрагента,
		СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткамЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьПоОстаткамСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "НачалоПериода", "КонецПериода"));
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура КонтрагентПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		
		ДанныеДокумента = Документы.СверкаВзаиморасчетов.РеквизитыПоследнегоДокумента(Объект.Контрагент);
		ЗаполнитьЗначенияСвойств(Объект, ДанныеДокумента, , "ФИОРуководителяКонтрагента, ДолжностьРуководителяКонтрагента,КонтактноеЛицо");
		Если НЕ ЗначениеЗаполнено(Объект.ФИОРуководителяКонтрагента)
		 И НЕ ЗначениеЗаполнено(Объект.ДолжностьРуководителяКонтрагента) Тогда
		 	ЗаполнитьЗначенияСвойств(Объект, ДанныеДокумента, "ФИОРуководителяКонтрагента, ДолжностьРуководителяКонтрагента");
		КонецЕсли;
		
		ПартнерКонтрагента = ПартнерКонтрагента(Объект.Контрагент);
		
		Если НЕ ЗначениеЗаполнено(Объект.КонтактноеЛицо) ИЛИ
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.КонтактноеЛицо,"Владелец") <> ПартнерКонтрагента Тогда
			
			Если ЗначениеЗаполнено(ДанныеДокумента.КонтактноеЛицо) Тогда
				Объект.КонтактноеЛицо = ДанныеДокумента.КонтактноеЛицо;
			Иначе
				Объект.КонтактноеЛицо = ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(ПартнерКонтрагента);
			КонецЕсли;
		КонецЕсли;
		
		УправлениеЭлементамиФормы();
		
	Иначе
		
		Объект.КонтактноеЛицо = Справочники.КонтактныеЛицаПартнеров.ПустаяСсылка();
		
	КонецЕсли;
	
	Если Строка(Объект.КонтактноеЛицо) <> Объект.ФИОРуководителяКонтрагента Тогда
		Объект.ФИОРуководителяКонтрагента = Неопределено;
		Объект.ДолжностьРуководителяКонтрагента = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьДоступностьЭлементовПоСтатусу()
	
	ТолькоПросмотрЭлементов = (Объект.Статус = Перечисления.СтатусыСверокВзаиморасчетов.Сверена);
	
	МассивЭлементов = Новый Массив();
	
	// Элементы управления шапки
	МассивЭлементов.Добавить("Дата");
	МассивЭлементов.Добавить("Организация");
	МассивЭлементов.Добавить("НачалоПериода");
	МассивЭлементов.Добавить("КонецПериода");
	МассивЭлементов.Добавить("Контрагент");
		
	// Группы элементов управления
	МассивЭлементов.Добавить("ГруппаСтраницы");

	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", ТолькоПросмотрЭлементов);
	
	МассивЭлементов = Новый Массив();             
	
	// Элементы управления шапки
	МассивЭлементов.Добавить("ДетализацияВзаиморасчетов");
	МассивЭлементов.Добавить("УстановитьИнтервал");
	МассивЭлементов.Добавить("ДанныеКонтрагентаКомандаЗаполнитьПоОстаткам");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", НЕ ТолькоПросмотрЭлементов);

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	СтруктураПараметров = Новый Структура("РасшифровкаПоЗаказам, РасшифровкаПоПартнерам, РасшифровкаПоДоговорам, Партнер, Договор",
										  Объект.РасшифровкаПоЗаказам,
										  Объект.РасшифровкаПоПартнерам,
										  Объект.РасшифровкаПоДоговорам,
										  Объект.Партнер,
										  Объект.Договор);
	
	Документы.СверкаВзаиморасчетов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		СтруктураПараметров, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
    ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	УстановитьВидимость();
	УстановитьДоступностьЭлементовПоСтатусу();
	
	ДетализацияВзаиморасчетов = Документы.СверкаВзаиморасчетов.ПредставлениеДетализацииВзаиморасчетов(
		Объект.Партнер,
		Объект.Договор,
		Объект.РасшифровкаПоПартнерам,
		Объект.РасшифровкаПоДоговорам,
		Объект.РасшифровкаПоЗаказам);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамСервер()
	                                                 
	ДанныеДокумента = Новый Структура;
	ДанныеДокумента.Вставить("Дата",			   	   Объект.Дата);
	ДанныеДокумента.Вставить("Организация",		   	   Объект.Организация);
	ДанныеДокумента.Вставить("Контрагент",		   	   Объект.Контрагент);
	ДанныеДокумента.Вставить("Партнер",		 		   Объект.Партнер);
	ДанныеДокумента.Вставить("Договор",		 		   Объект.Договор);
	ДанныеДокумента.Вставить("КонецПериода", 	   	   Объект.КонецПериода);
	ДанныеДокумента.Вставить("РасшифровкаПоЗаказам",   Объект.РасшифровкаПоЗаказам);
	ДанныеДокумента.Вставить("РасшифровкаПоПартнерам", Объект.РасшифровкаПоПартнерам);
	ДанныеДокумента.Вставить("РасшифровкаПоДоговорам", Объект.РасшифровкаПоДоговорам);
	
	Документы.СверкаВзаиморасчетов.ЗаполнитьДанныеКонтрагента(ДанныеДокумента, Объект.ДанныеКонтрагента);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуПоРасчетномуДокументуСервер(ДокументСсылка, ОписаниеДокумента, ВалютаВзаиморасчетов)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Объект.Организация, Объект.Дата);
	ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, 
								"ПолноеНаименование");
	СведенияОКонтрагенте  = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Объект.Контрагент,  Объект.Дата);
	КонтрагентНаименование = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОКонтрагенте, 
							  "ПолноеНаименование");
	
	СтруктураПредставленийУчастников = Новый Структура;
	СтруктураПредставленийУчастников.Вставить("ПредставлениеОрганизации", ПредставлениеОрганизации);
	СтруктураПредставленийУчастников.Вставить("КонтрагентНаименование", КонтрагентНаименование);
	
	ЭтоВходящийДокумент = ДокументСсылка.Метаданные().Реквизиты.Найти("НомерВходящегоДокумента") <> Неопределено;
	ЭтоДокументИнтеркампани = ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
		Или ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями");
	
	СтрокаРеквизитов = "Номер, Дата, Валюта";
	
	Если ЭтоВходящийДокумент Тогда
		
		СтрокаРеквизитов = СтрокаРеквизитов + ", НомерВходящегоДокумента, ДатаВходящегоДокумента";
		Если ЭтоДокументИнтеркампани Тогда
			СтрокаРеквизитов = СтрокаРеквизитов + "Организация";
		КонецЕсли;
		
	КонецЕсли;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, СтрокаРеквизитов);
	
	Если ЗначениеЗаполнено(ЗначенияРеквизитов.Номер) Тогда
		
		Если ЭтоВходящийДокумент Тогда
			
			Если Не ЭтоДокументИнтеркампани
				Или (ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями")
					И ЗначенияРеквизитов.Организация = Объект.Организация)
				Или (ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
					И ЗначенияРеквизитов.Организация <> Объект.Организация)
				Тогда
				
				ЗначенияРеквизитов.Номер = ЗначенияРеквизитов.НомерВходящегоДокумента;
				ЗначенияРеквизитов.Дата  = ЗначенияРеквизитов.ДатаВходящегоДокумента;
			КонецЕсли;
			
		КонецЕсли;
		
		ОписаниеДокумента = Документы.СверкаВзаиморасчетов.ОписаниеРасчетногоДокумента(ДокументСсылка,
			ЗначенияРеквизитов.Номер, ЗначенияРеквизитов.Дата, СтруктураПредставленийУчастников);
		ВалютаВзаиморасчетов = ЗначенияРеквизитов.Валюта;
		
	КонецЕсли;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПартнерКонтрагента(Контрагент)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "Партнер");
	
КонецФункции

&НаСервере
Процедура СвернутьТабличнуюЧастьПоДетализацииВзаиморасчетов(ПараметрыДетализации)
	
	Документы.СверкаВзаиморасчетов.СвернутьТабличнуюЧастьПоДетализацииВзаиморасчетов(ПараметрыДетализации, Объект.ДанныеКонтрагента);
	
КонецПроцедуры

&НаКлиенте
Функция ФИОРуководителяКонтактноеЛицоНачалоВыбора()
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Отбор = Новый Структура("Владелец", ПартнерКонтрагента(Объект.Контрагент));
		ОткрытьФорму("Справочник.КонтактныеЛицаПартнеров.ФормаВыбора",
			Новый Структура("Отбор", Отбор),
			ЭтаФорма);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Контрагент"" не заполнено';uk='Поле ""Контрагент"" не заповнено'"),
			,
			"Контрагент",
			"Объект");
	КонецЕсли; 
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти
