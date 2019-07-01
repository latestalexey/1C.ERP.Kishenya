//////////////////////////////////////////////////////////////////////////////////////////////
// Проверка документов: методы, работающие на  стороне сервера, вызываемые со стороны клиента.
//  
//////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет команду "Проверки" документа. В случае если прав на изменение статуса проверки нет - ничего не делает,
// в противном случае изменяет значение статуса проверки документа.
// (см. метод регистра сведений "РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов")
//
// Параметры:
//  ДокументСсылка - Документ, для которого требуется изменить статус проверки
//
//	ВозвращаемоеЗначение:
//		Булево - истина, если есть право на изменение документа, ложь - в противном случае.
//
Процедура ВыполнитьКомандуИзмененияСтатусаПроверкиДокумента(ДокументСсылка, ДанныеОбОшибке = Неопределено) Экспорт
	
	РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов(ДокументСсылка, ДанныеОбОшибке);
	
КонецПроцедуры

#КонецОбласти