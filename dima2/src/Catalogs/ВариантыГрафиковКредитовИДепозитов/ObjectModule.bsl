#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Владелец.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Закрыт Тогда
		Отказ = Истина;
		Текст = НСтр("ru='Изменения графика по закрытому договору запрещены!';uk='Зміни графіка по закритому договору заборонені!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли