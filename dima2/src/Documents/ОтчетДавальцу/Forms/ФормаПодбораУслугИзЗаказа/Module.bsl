
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента    = Параметры.ВалютаДокумента;
	СтавкаНДС          = Параметры.СтавкаНДС;
	ЦенаВключаетНДС    = Параметры.ЦенаВключаетНДС;
	
	ЗаполнитьТаблицуУслуг(Параметры.ЗаказДавальца, Параметры.Документ, Параметры.ВалютаДокумента);
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Документ);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ТекстВопроса = НСтр("ru='Данные были изменены. Перенести изменения в документ?';uk='Дані були змінені. Перенести зміни в документ?'");
	Оповещение = Новый ОписаниеОповещения("ПеренестиТоварыВДокументИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ТекстВопроса);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУслуги

&НаКлиенте
Процедура ТаблицаУслугВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаУслуг.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаУслугЗаказДавальца" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаУслуг.ТекущиеДанные.ЗаказДавальца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПеренестиТоварыВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()

	ВыбратьВсеТоварыНаСервере(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ИсключитьТоварыВыполнить()

	ВыбратьВсеТоварыНаСервере(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслуг.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУслуг.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаУслугЗаказДавальца.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаУслуг.ЗаказДавальца");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);

КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()
	
	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;
	
	АдресТоваровВХранилище = ПоместитьТоварыВХранилище();
	
	Закрыть();
	
	ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаУслуг.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище()
	
	// Формирование таблицы для возврата в документ.
	СтруктураОтбора = Новый Структура("СтрокаВыбрана", Истина);
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаУслуг.Выгрузить(СтруктураОтбора));
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуУслуг(ЗаказДавальца, Документ, ВалютаДокумента)
	
	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Партнер",               Параметры.Партнер);
	ДанныеОтбора.Вставить("Контрагент",            Параметры.Контрагент);
	ДанныеОтбора.Вставить("Договор",               Параметры.Договор);
	ДанныеОтбора.Вставить("Организация",           Параметры.Организация);
	ДанныеОтбора.Вставить("Валюта",                Параметры.ВалютаДокумента);
	ДанныеОтбора.Вставить("ВалютаВзаиморасчетов",  Параметры.ВалютаВзаиморасчетов);
	ДанныеОтбора.Вставить("СтавкаНДС",             Параметры.СтавкаНДС);
	ДанныеОтбора.Вставить("ЦенаВключаетНДС",       Параметры.ЦенаВключаетНДС);
	ДанныеОтбора.Вставить("ПорядокРасчетов",       Параметры.ПорядокРасчетов);
	ДанныеОтбора.Вставить("Ссылка",                Параметры.Документ);
	ДанныеОтбора.Вставить("Дата",                  Параметры.Дата);
	ДанныеОтбора.Вставить("НаправлениеДеятельности", Параметры.НаправлениеДеятельности);
	
	Если НЕ ЗначениеЗаполнено(Параметры.ЗаказДавальца) 
		 ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьОтчетДавальцуПоНесколькимЗаказам") Тогда
		МассивЗаказов = Неопределено;
	Иначе
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(ЗаказДавальца);
	КонецЕсли;
	
	Документы.ОтчетДавальцу.ЗаполнитьПоОстаткамУслугДавальцаКОформлению(
		ДанныеОтбора,
		ТаблицаУслуг,
		МассивЗаказов,
		Ложь,
		Параметры.ПодборПоОстаткам);
	
	ЗаказыСервер.УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаУслуг, "ЗаказДавальца", Параметры.МассивКодовСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиТоварыВДокументИЗакрыть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеренестиТоварыВДокумент();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
