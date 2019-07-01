#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ТекстТранслируется", НСтр("ru='транслируется';uk='транслюється'"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ТекстПрочие", НСтр("ru='Прочие';uk='Інші'"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "Приход", НСтр("ru='Приход';uk='Надходження'"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "Расход", НСтр("ru='Расход';uk='Видаток'"));
	
КонецПроцедуры

#КонецОбласти