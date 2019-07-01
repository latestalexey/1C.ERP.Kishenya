
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("ОбъектЭксплуатации", ОбъектЭксплуатации);
		СтруктураБыстрогоОтбора.Свойство("Тип", Тип);
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(
		Список,
		"Организация",
		Организация,
		СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(
		Список,
		"Тип",
		Тип,
		СтруктураБыстрогоОтбора,
		Тип.Количество()>0,
		ВидСравненияКомпоновкиДанных.ВСписке);
	
	ОтборОбъектЭксплуатацииПриИзмененииНаСервере(ОбъектЭксплуатации);
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");

	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(
		Список, 
		"Организация", 
		Организация, 
		СтруктураБыстрогоОтбора, 
		Настройки);
		
	Если Настройки["Тип"] <> Неопределено Тогда
		ИспользованиеЭлементаОтбора = Настройки["Тип"].Количество() > 0;
	КонецЕсли;
		
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(
		Список, 
		"Тип", 
		Тип, 
		СтруктураБыстрогоОтбора, 
		Настройки,
		ИспользованиеЭлементаОтбора,
		ВидСравненияКомпоновкиДанных.ВСписке);
		
	Если Настройки["ОбъектЭксплуатации"] <> Неопределено Тогда
		ОтборОбъектЭксплуатацииПриИзмененииНаСервере(Настройки["ОбъектЭксплуатации"]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаОтметкиЭлементов" Тогда
		ВыполнитьПослеЗакрытияСпискаВыбора(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		Организация = ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры 

&НаКлиенте
Процедура ОтборОбъектЭксплуатацииПриИзменении(Элемент)
	
	ОтборОбъектЭксплуатацииПриИзмененииНаСервере(ОбъектЭксплуатации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВыбора = ПолучитьЗначенияСписка();
	
	Для каждого Элемент Из Тип Цикл
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка <> Неопределено Тогда
			ЭлементСписка.Пометка = Элемент.Пометка;
		КонецЕсли;
	КонецЦикла;
	
	СписокВыбора.СортироватьПоПредставлению();
	
	ОткрытьФорму("ОбщаяФорма.ФормаОтметкиЭлементов",Новый Структура("СписокЗначений", СписокВыбора),ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипДокументаОчистка(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Тип",
		Тип,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьВнутреннееПотребление(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию"));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ВнутреннееПотреблениеТоваров.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеУслугПрочихАктивов(Команда)
	
	ОткрытьФорму("Документ.ПоступлениеУслугПрочихАктивов.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПринятиеКУчету(Команда)
	
	ОткрытьФорму("Документ.ПринятиеКУчетуОС.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеремещение(Команда)
	ОткрытьФорму("Документ.ПеремещениеОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИзменениеПараметров(Команда)
	ОткрытьФорму("Документ.ИзменениеПараметровОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИзменениеСостояния(Команда)
	ОткрытьФорму("Документ.ИзменениеСостоянияОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРегистрациюНаработок(Команда)
	ОткрытьФорму("Документ.РегистрацияНаработок.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнвентаризацию(Команда)
	ОткрытьФорму("Документ.ИнвентаризацияОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьМодернизацию(Команда)
	ОткрытьФорму("Документ.МодернизацияОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СодатьПередачуАрендатору(Команда)
	ОткрытьФорму("Документ.ПередачаОСАрендатору.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратОтАрендатора(Команда)
	ОткрытьФорму("Документ.ВозвратОСОтАрендатора.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПодготовкуКПередаче(Команда)
	ОткрытьФорму("Документ.ПодготовкаКПередачеОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписание(Команда)
	ОткрытьФорму("Документ.СписаниеОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеализациюУслугПрочихАктивов(Команда)
	ОткрытьФорму("Документ.РеализацияУслугПрочихАктивов.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеАрендованныхОС(Команда)
	ОткрытьФорму("Документ.ПоступлениеАрендованныхОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыбытиеАрендованныхОС(Команда)
	ОткрытьФорму("Документ.ВыбытиеАрендованныхОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеПредметовЛизинга(Команда)
	ОткрытьФорму("Документ.ПоступлениеПредметовЛизинга.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПереоценку(Команда)
	ОткрытьФорму("Документ.ПереоценкаОС.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректировку(Команда)
	ОткрытьФорму("Документ.КорректировкаНалоговогоНазначенияОС.ФормаОбъекта");
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтборОбъектЭксплуатацииПриИзмененииНаСервере(ЗначениеПоиска)

	МассивДокументов = КритерииОтбора.ДокументыПоОС.Найти(ЗначениеПоиска);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка",
		МассивДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		ЗначениеЗаполнено(ЗначениеПоиска));

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияСпискаВыбора(СписокВыбора) 

	Если СписокВыбора <> Неопределено Тогда
		
		Для каждого ЭлементСписка Из СписокВыбора Цикл
			
			НайденноеЗначение = Тип.НайтиПоЗначению(ЭлементСписка.Значение);
			
			Если ЭлементСписка.Пометка и НайденноеЗначение = Неопределено Тогда
				НайденноеЗначение = Тип.Добавить();
				ЗаполнитьЗначенияСвойств(НайденноеЗначение,ЭлементСписка);
			КонецЕсли;
			
			Если Не ЭлементСписка.Пометка и НайденноеЗначение <> Неопределено Тогда
				Тип.Удалить(НайденноеЗначение);
			КонецЕсли;
			
		КонецЦикла; 
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Тип",
		Тип,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Тип.Количество() > 0);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначенияСписка()
	
	СписокВыбора = Новый СписокЗначений();
	
	Для Каждого ОписаниеМетаданныхДокумента Из Метаданные.ЖурналыДокументов.ДокументыПоОС.РегистрируемыеДокументы Цикл
		СписокВыбора.Добавить(Тип("ДокументСсылка." + ОписаниеМетаданныхДокумента.Имя), ОписаниеМетаданныхДокумента.Синоним);
	КонецЦикла;
	
	Возврат СписокВыбора;
	
КонецФункции

&НаКлиенте
Процедура СоздатьРемонт(Команда)
	ОткрытьФорму("Документ.РемонтОС.ФормаОбъекта");
КонецПроцедуры

#КонецОбласти
