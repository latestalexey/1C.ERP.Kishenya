#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ИспользуетсяСборкаРазборкаИСерииНоменклатуры.Установить(
			(Константы.ИспользоватьСборкуРазборку.Получить() 
			//++ НЕ УТ
				ИЛИ Константы.ИспользоватьПроизводство.Получить()
			//-- НЕ УТ
			)
			И Константы.ИспользоватьСерииНоменклатуры.Получить());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли