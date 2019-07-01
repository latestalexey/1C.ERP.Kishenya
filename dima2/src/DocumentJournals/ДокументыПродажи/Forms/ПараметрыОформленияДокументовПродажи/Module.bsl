
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СтруктураПараметров = ПолучитьПараметры(Параметры);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураПараметров);
	
	УстановитьДоступностьДокументаПродажи(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не СохранитьПараметры Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru='Закрыть';uk='Закрити'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru='Не закрывать';uk='Не закривати'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru='Параметры были изменены. Закрыть форму без сохранения параметров?';uk='Параметри були змінені. Закрити форму без збереження параметрів?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "НеЗакрывать" Тогда
		
		СохранитьПараметры = Ложь;
		
	ИначеЕсли ОтветНаВопрос = "Закрыть" Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		СохранитьПараметры = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьПараметры = Истина;
	Закрыть(ПолучитьПараметры(ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПараметры(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ПечататьАктВыполненныхРабот",    Источник.ПечататьАктВыполненныхРабот);
	СтруктураПараметров.Вставить("ПечататьРеализациюТоваровУслуг", Источник.ПечататьРеализациюТоваровУслуг);
	СтруктураПараметров.Вставить("СоздаватьДокументПродажи",       Источник.СоздаватьДокументПродажи);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзменениеФлага(Реквизит, ЗависимыйЭлемент, ЗависимыйРеквизит  = Неопределено)
	
	ЗависимыйЭлемент.Доступность = Реквизит;
	Если Не Реквизит И ЗависимыйЭлемент <> Неопределено Тогда
		 ЗависимыйРеквизит = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьДокументаПродажи(Форма)
	
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		Форма.Элементы.ПечататьРеализацию,
		Форма.ПечататьРеализациюТоваровУслуг);
	ОбработатьИзменениеФлага(
		Форма.СоздаватьДокументПродажи,
		Форма.Элементы.ПечататьАкт,
		Форма.ПечататьАктВыполненныхРабот);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьДокументПродажиПриИзменении(Элемент)
	
	УстановитьДоступностьДокументаПродажи(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
