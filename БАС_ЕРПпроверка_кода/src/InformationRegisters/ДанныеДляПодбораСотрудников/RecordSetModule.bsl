#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Не Запись.ПоДоговоруГПХ Тогда
			Запись.КоличествоСтавокПредставление = КадровыйУчетРасширенныйКлиентСервер.ПредставлениеКоличестваСтавок(Запись.КоличествоСтавок);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
