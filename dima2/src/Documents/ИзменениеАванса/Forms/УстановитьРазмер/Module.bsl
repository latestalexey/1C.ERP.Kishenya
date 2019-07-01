
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	Элементы.РазмерАвансаВПроцентах.Видимость = Ложь;
	Элементы.РазмерАвансаВГривнах.Видимость = Ложь;
	
	Если Параметры.СпособРасчета = Перечисления.СпособыРасчетаАванса.ПроцентомОтТарифа Тогда
		Элементы.РазмерАвансаВПроцентах.Видимость = Истина;
		РазмерАвансаВПроцентах = Параметры.РазмерАванса;
	ИначеЕсли Параметры.СпособРасчета = Перечисления.СпособыРасчетаАванса.ФиксированнойСуммой Тогда
		Элементы.РазмерАвансаВГривнах.Видимость = Истина;
		РазмерАвансаВГривнах = Параметры.РазмерАванса;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверитьЗаполнение() Тогда
		
		Если Элементы.РазмерАвансаВПроцентах.Видимость Тогда
			РазмерАванса = ЭтаФорма.РазмерАвансаВПроцентах;
		ИначеЕсли Элементы.РазмерАвансаВГривнах.Видимость Тогда
			РазмерАванса = ЭтаФорма.РазмерАвансаВГривнах;
		Иначе
			РазмерАванса = 0;
		КонецЕсли;
		
		Модифицированность = Ложь;
		Закрыть(РазмерАванса);
		
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти
