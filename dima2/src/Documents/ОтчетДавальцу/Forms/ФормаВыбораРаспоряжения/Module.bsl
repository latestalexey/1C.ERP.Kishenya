
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ЗначениеОтбора;
	
	МассивОтборов = Новый Массив;
	МассивОтборов.Добавить("Организация");
	МассивОтборов.Добавить("Валюта");
	МассивОтборов.Добавить("Контрагент");
	МассивОтборов.Добавить("СтавкаНДС");
	МассивОтборов.Добавить("Партнер");
	МассивОтборов.Добавить("ЦенаВключаетНДС");
	МассивОтборов.Добавить("ПорядокРасчетов");
	
	Для каждого ИмяОтбора из МассивОтборов Цикл
		Если Параметры.Отбор.Свойство(ИмяОтбора, ЗначениеОтбора) Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Список,
				ИмяОтбора,
				ЗначениеОтбора);
				
			Параметры.Отбор.Удалить(ИмяОтбора);
				
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"Регистратор",
		Параметры.Регистратор);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Закрыть(Элементы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если РаботаСДиалогамиКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.Список) Тогда
		Закрыть(Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
