#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработкиВМоделиСервиса.СинхронизацияЗначенийРегулирующихКонстант(Метаданные.Имя, Значение);
	
КонецПроцедуры

#КонецЕсли