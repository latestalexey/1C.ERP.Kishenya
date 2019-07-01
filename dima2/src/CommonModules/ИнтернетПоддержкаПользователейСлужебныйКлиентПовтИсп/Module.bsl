
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейСлужебныйКлиентПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ОпределенияСервиса(МестоположениеWSDL, ОписательОшибки, ТаймаутПодключения = -1) Экспорт
	
	Определения = ИнтернетПоддержкаПользователейКлиентСервер.НовыйОпределенияСервиса(
		МестоположениеWSDL,
		,
		ТаймаутПодключения);
	
	Если НЕ ПустаяСтрока(Определения.КодОшибки) Тогда
		ОписательОшибки = Определения;
		ВызватьИсключение Определения.СообщениеОбОшибке;
	КонецЕсли;
	
	Возврат Определения;
	
КонецФункции

#КонецОбласти