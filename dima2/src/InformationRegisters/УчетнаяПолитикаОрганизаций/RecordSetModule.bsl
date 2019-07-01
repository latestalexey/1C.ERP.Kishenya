#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	//++ НЕ УТ
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	//-- НЕ УТ
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	//++ НЕ УТ
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	//-- НЕ УТ
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли