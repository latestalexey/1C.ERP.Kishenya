
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Роль = Параметры.Роль;
	РольТип = Параметры.РольТип;
	РольID = Параметры.РольID;
	
	ДанныеРоли = ПолучитьДанныеВыбраннойРоли(
		Параметры.РольТип, 
		Параметры.РольID);
	
	Если ДанныеРоли.ИспользуетсяБезОбъектовАдресации = Истина
		И ДанныеРоли.ИспользуетсяСОбъектамиАдресации = Ложь Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОсновнойОбъектАдресацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОбъектАдресации("ОсновнойОбъектАдресации", "ТипОсновногоОбъектаАдресации");
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныйОбъектАдресацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьОбъектАдресации("ДополнительныйОбъектАдресации", "ТипДополнительногоОбъектаАдресации");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	Если ДанныеРоли.ИспользуетсяСОбъектамиАдресации = Истина
		И ДанныеРоли.ИспользуетсяБезОбъектовАдресации = Ложь Тогда
		Если Элементы.ОсновнойОбъектАдресации.Видимость
			И НЕ ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда
			Текст = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, Элементы.ОсновнойОбъектАдресации.Заголовок);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,,"ОсновнойОбъектАдресации");
			Отказ = Истина;
		КонецЕсли;
		Если Элементы.ДополнительныйОбъектАдресации.Видимость
			И НЕ ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда
			Текст = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, Элементы.ДополнительныйОбъектАдресации.Заголовок);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,,"ДополнительныйОбъектАдресации");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВозврата = Новый Структура;
	
	ДанныеВозврата.Вставить("Результат", "ОК");
	
	ДанныеВозврата.Вставить("Исполнитель", Роль);
	ДанныеВозврата.Вставить("ИсполнительID", РольID);
	ДанныеВозврата.Вставить("ИсполнительТип", РольТип);
	
	ДанныеВозврата.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	ДанныеВозврата.Вставить("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииID);
	ДанныеВозврата.Вставить("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииТип);
	
	ДанныеВозврата.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	ДанныеВозврата.Вставить("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииID);
	ДанныеВозврата.Вставить("ДополнительныйОбъектАдресацииТип", ДополнительныйОбъектАдресацииТип);
	
	Закрыть(ДанныеВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ДанныеВозврата = Новый Структура;
	ДанныеВозврата.Вставить("Результат", "Отмена");
	Закрыть(ДанныеВозврата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьДанныеВыбраннойРоли(Тип, ID)
	
	ДанныеВозврата = Новый Структура;
	
	Элементы.ОсновнойОбъектАдресации.Видимость = Ложь;
	Элементы.ДополнительныйОбъектАдресации.Видимость = Ложь;
	Элементы.ОсновнойОбъектАдресации.Заголовок = "";
	Элементы.ДополнительныйОбъектАдресации.Заголовок = "";
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ДанныеОбъекта = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси, Тип, ID);

	ПолученнаяРоль = ДанныеОбъекта.objects[0];
	
	ДанныеВозврата.Вставить("ИспользуетсяСОбъектамиАдресации", ПолученнаяРоль.withAddressingObjects);
	ДанныеВозврата.Вставить("ИспользуетсяБезОбъектовАдресации", ПолученнаяРоль.withoutAddressingObjects);
	Если ПолученнаяРоль.withAddressingObjects Тогда
		Элементы.ОсновнойОбъектАдресации.Заголовок = ПолученнаяРоль.mainAddressingObjectName;
		Элементы.ДополнительныйОбъектАдресации.Заголовок = ПолученнаяРоль.secondaryAddressingObjectName;
		
		ДанныеВозврата.Вставить("ИмяОсновногоОбъектаАдресации", ПолученнаяРоль.mainAddressingObjectName);
		ДанныеВозврата.Вставить("ИмяДополнительногоОбъектаАдресации", ПолученнаяРоль.secondaryAddressingObjectName);

		ТипОсновногоОбъектаАдресации = Новый СписокЗначений;
		Для Каждого ТипЭлемента Из ПолученнаяРоль.mainAddressingObjectType Цикл
			ДанныеТипа = Новый Структура;
			ДанныеТипа.Вставить("XDTOClassName", ТипЭлемента.xdtoClassName);
			ДанныеТипа.Вставить("Presentation", ТипЭлемента.presentation);
			ТипОсновногоОбъектаАдресации.Добавить(ДанныеТипа);
		КонецЦикла;
		
		ТипДополнительногоОбъектаАдресации = Новый СписокЗначений;
		Для Каждого ТипЭлемента Из ПолученнаяРоль.secondaryAddressingObjectType Цикл
			ДанныеТипа = Новый Структура;
			ДанныеТипа.Вставить("XDTOClassName", ТипЭлемента.xdtoClassName);
			ДанныеТипа.Вставить("Presentation", ТипЭлемента.presentation);
			ТипДополнительногоОбъектаАдресации.Добавить(ДанныеТипа);
		КонецЦикла;
		
		ДанныеВозврата.Вставить("ТипОсновногоОбъектаАдресации", ТипОсновногоОбъектаАдресации);
		ДанныеВозврата.Вставить("ТипДополнительногоОбъектаАдресации", ТипДополнительногоОбъектаАдресации);
		
		Элементы.ОсновнойОбъектАдресации.Видимость = ЗначениеЗаполнено(Элементы.ОсновнойОбъектАдресации.Заголовок);
		Элементы.ДополнительныйОбъектАдресации.Видимость = ЗначениеЗаполнено(Элементы.ДополнительныйОбъектАдресации.Заголовок);
		
		Элементы.ОсновнойОбъектАдресации.ОтметкаНезаполненного = Ложь;
		Элементы.ДополнительныйОбъектАдресации.ОтметкаНезаполненного = Ложь;
		
		Элементы.ОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ДополнительныйОбъектАдресации.АвтоОтметкаНезаполненного = Ложь;
		
		Если ДанныеВозврата.ИспользуетсяСОбъектамиАдресации = Истина
			И ДанныеВозврата.ИспользуетсяБезОбъектовАдресации = Ложь Тогда
			Элементы.ОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = Элементы.ОсновнойОбъектАдресации.Видимость;
			Элементы.ДополнительныйОбъектАдресации.АвтоОтметкаНезаполненного = Элементы.ДополнительныйОбъектАдресации.Видимость;
		КонецЕсли;

	КонецЕсли;
	
	Возврат ДанныеВозврата;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьОбъектАдресации(ИмяПеременной, ИмяПоля)
	
	ИмяТипа = "";
	Если ДанныеРоли[ИмяПоля].Количество() > 1 Тогда
		ЗаголовокФормы = НСтр("ru='Тип объекта адресации';uk='Тип об''єкту адресації'");
		ПараметрыФормы = Новый Структура("СписокДоступныхТипов, ЗаголовокФормы", ДанныеРоли[ИмяПоля], ЗаголовокФормы);
		Оповещение = Новый ОписаниеОповещения("ВыбратьОбъектАдресацииВыборТипаЗавершение", ЭтаФорма, ИмяПеременной);
		 
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборОдногоТипаИзСоставногоТипа", 
			ПараметрыФормы, ЭтаФорма,,,, Оповещение);
		
	ИначеЕсли ДанныеРоли[ИмяПоля].Количество() = 1 Тогда
		ИмяТипа = ДанныеРоли[ИмяПоля][0].Значение.XDTOClassName;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТипОбъектаВыбора", ИмяТипа);
		
		Оповещение = Новый ОписаниеОповещения("ВыбратьОбъектАдресацииЗавершение", ЭтаФорма, ИмяПеременной);
		 
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИзСписка", ПараметрыФормы, ЭтаФорма,,,, Оповещение);
	Иначе
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОбъектАдресацииВыборТипаЗавершение(РезультатВыбораТипа, ИмяПеременной) Экспорт
	
	Если РезультатВыбораТипа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИмяТипа = РезультатВыбораТипа;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", ИмяТипа);
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьОбъектАдресацииЗавершение", ЭтаФорма, ИмяПеременной);
	 
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИзСписка", ПараметрыФормы, ЭтаФорма,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОбъектАдресацииЗавершение(РезультатВыбора, ИмяПеременной) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		ЭтаФорма[ИмяПеременной] = РезультатВыбора.РеквизитПредставление;
		ЭтаФорма[ИмяПеременной + "ID"] = РезультатВыбора.РеквизитID;
		ЭтаФорма[ИмяПеременной + "Тип"] = РезультатВыбора.РеквизитТип;
	Конецесли;
	
КонецПроцедуры

#КонецОбласти
