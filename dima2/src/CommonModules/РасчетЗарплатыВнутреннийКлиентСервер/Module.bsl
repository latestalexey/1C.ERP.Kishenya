#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обслуживание полей аванса

Функция РазмерностьАванса(СпособРасчетаАванса) Экспорт
	
	Возврат РасчетЗарплатыРасширенныйКлиентСервер.РазмерностьАванса(СпособРасчетаАванса);
	
КонецФункции

Функция ПредставлениеСпособаРасчетаАванса(СпособРасчетаАванса, СжатыйФормат) Экспорт
	
	Возврат РасчетЗарплатыРасширенныйКлиентСервер.ПредставлениеСпособаРасчетаАванса(СпособРасчетаАванса, СжатыйФормат);
	
КонецФункции

Функция ИменаСпособовРасчетаАванса() Экспорт
	
	Возврат РасчетЗарплатыРасширенныйКлиентСервер.ИменаСпособовРасчетаАванса();
	
КонецФункции

Процедура ОбработкаПолученияДанныхВыбораВидовОграниченияПособия(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	// В этой конфигурации ничего не делается.
	
КонецПроцедуры

#КонецОбласти
