////////////////////////////////////////////////////////////////////////////////
// Подсистема "Резервное копирование областей данных".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыФормыНастроек(Знач ОбластьДанных) Экспорт
	
	Параметры = Реализация().ПолучитьПараметрыФормыНастроек(ОбластьДанных);
	Параметры.Вставить("ОбластьДанных", ОбластьДанных);
	
	Возврат Параметры;
	
КонецФункции

Функция ПолучитьНастройкиОбласти(Знач ОбластьДанных) Экспорт
	
	Возврат Реализация().ПолучитьНастройкиОбласти(ОбластьДанных);
	
КонецФункции

Процедура УстановитьНастройкиОбласти(Знач ОбластьДанных, Знач НовыеНастройки, Знач ИсходныеНастройки) Экспорт
	
	Реализация().УстановитьНастройкиОбласти(ОбластьДанных, НовыеНастройки, ИсходныеНастройки);
	
КонецПроцедуры

Функция ПолучитьСтандартныеНастройки() Экспорт
	
	Возврат Реализация().ПолучитьСтандартныеНастройки();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция Реализация()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеОбластейДанныхМС") Тогда
		Возврат ОбщегоНазначения.ОбщийМодуль("РезервноеКопированиеОбластейДанныхДанныеФормРеализацияИБ");
	Иначе
		Возврат ОбщегоНазначения.ОбщийМодуль("РезервноеКопированиеОбластейДанныхДанныеФормРеализацияWebСервис");
	КонецЕсли;
	
КонецФункции

#КонецОбласти
