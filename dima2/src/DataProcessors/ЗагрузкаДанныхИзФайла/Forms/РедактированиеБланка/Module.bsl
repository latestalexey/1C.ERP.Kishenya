#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОформлениеДанных();
	
	ПараметрыЗагрузки = Параметры.ПараметрыЗагрузки;

	ИмяОбъектаСопоставления = Параметры.ИмяОбъектаСопоставления;
	Если Параметры.Свойство("ИнформацияПоКолонкам") Тогда
		СписокКолонок.Загрузить(Параметры.ИнформацияПоКолонкам.Выгрузить());
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ПозицияКолонки = 0;
	Для Каждого СтрокаТаблицы Из СписокКолонок Цикл
		Если СтрокаТаблицы.Видимость Тогда
			ПозицияКолонки = ПозицияКолонки + 1;
			СтрокаТаблицы.Позиция = ПозицияКолонки;
		Иначе
			СтрокаТаблицы.Позиция = -1;
		КонецЕсли;
	КонецЦикла;
	Закрыть(СписокКолонок);
КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройки(Команда)
	Оповещение = Новый ОписаниеОповещения("СброситьНастройкиЗавершение", ЭтотОбъект, ИмяОбъектаСопоставления);
	ПоказатьВопрос(Оповещение, НСтр("ru='Установить настройки колонок в первоначальное состояние?';uk='Встановити настройки колонок в первісний стан?'"), РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для каждого СтрокаТаблицы Из СписокКолонок Цикл 
		СтрокаТаблицы.Видимость = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для каждого СтрокаТаблицы Из СписокКолонок Цикл
		Если Не СтрокаТаблицы.ОбязательнаДляЗаполнения Тогда
			СтрокаТаблицы.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСписокКолонок

&НаКлиенте
Процедура СписокКолонокПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ОписаниеКолонки = Элемент.ТекущиеДанные.Примечание;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОформлениеДанных()

	УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СписокКолонокНаименование");
	ПолеОформления.Использование = Истина;
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКолонок.ОбязательнаДляЗаполнения"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.ПравоеЗначение =Истина;
	ЭлементОтбора.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СписокКолонокВидимость");
	ПолеОформления.Использование = Истина;
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКолонок.ОбязательнаДляЗаполнения"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.ПравоеЗначение =Истина;
	ЭлементОтбора.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СписокКолонокСиноним");
	ПолеОформления.Использование = Истина;
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКолонок.Синоним");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Стандартное наименование';uk='Стандартне найменування'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкиЗавершение(РезультатВопроса, ИмяОбъектаСопоставления) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СброситьНастройкиКолонок();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СброситьНастройкиКолонок()
	
	СписокКолонокТаблица = СписокКолонок.Выгрузить();
	СписокКолонокТаблица.Очистить();
	Обработки.ЗагрузкаДанныхИзФайла.ОпределитьИнформацияПоКолонкам(ПараметрыЗагрузки, СписокКолонокТаблица);
	ЗначениеВРеквизитФормы(СписокКолонокТаблица, "СписокКолонок");
	
КонецПроцедуры


#КонецОбласти
