#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиенТсервер.УстановитьПараметрДинамическогоСписка(
		Список, "Номенклатура", Параметры.Номенклатура);
	ОбщегоНазначенияКлиенТсервер.УстановитьПараметрДинамическогоСписка(
		Список, "НаименованиеНоменклатураСклад", Параметры.НаименованиеНоменклатураСклад);
	ОбщегоНазначенияКлиенТсервер.УстановитьПараметрДинамическогоСписка(
		Список, "ОтображатьНоменклатуру", Параметры.ОтображатьНоменклатуру);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти