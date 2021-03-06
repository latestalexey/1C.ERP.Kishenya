&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если Параметры.Свойство("ЗаголовокКоманды") Тогда
		Элементы.Готово.Заголовок = Параметры.ЗаголовокКоманды;
	КонецЕсли;
	
	НоваяСтрока = ТипыОбъектов.Добавить();
	НоваяСтрока.Тип = "DMInternalDocument";
	НоваяСтрока.Представление = НСтр("ru='Внутренний документ';uk='Внутрішній документ'");
	
	НоваяСтрока = ТипыОбъектов.Добавить();
	НоваяСтрока.Тип = "DMIncomingDocument";
	НоваяСтрока.Представление = НСтр("ru='Входящий документ';uk='Вхідний документ'");
	
	НоваяСтрока = ТипыОбъектов.Добавить();
	НоваяСтрока.Тип = "DMOutgoingDocument";
	НоваяСтрока.Представление = НСтр("ru='Исходящий документ';uk='Вихідний документ'");
	
	НоваяСтрока = ТипыОбъектов.Добавить();
	НоваяСтрока.Тип = "DMCorrespondent";
	НоваяСтрока.Представление = НСтр("ru='Корреспондента';uk='Кореспондента'");
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	
	ТекущиеДанные = Элементы.ТипыОбъектов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ТекущиеДанные.Тип);
	
КонецПроцедуры
