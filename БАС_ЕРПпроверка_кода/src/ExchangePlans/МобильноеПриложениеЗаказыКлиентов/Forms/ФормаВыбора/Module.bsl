#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Ссылка") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Параметры.Ссылка);
	КонецЕсли;
	
	Заголовок = НСтр("ru='Выберите устройство с индивидуальными настройками для синхронизации';uk='Виберіть пристрій з індивідуальними настройками для синхронізації'");
КонецПроцедуры

#КонецОбласти
