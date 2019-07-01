
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	МассивИсключаемыхЗначений = Новый Массив;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		МассивИсключаемыхЗначений.Добавить(Перечисления.ВидыБригадныхНарядов.Производство);
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами") Тогда
		МассивИсключаемыхЗначений.Добавить(Перечисления.ВидыБригадныхНарядов.Ремонт);
	КонецЕсли;
	
	ОбщегоНазначенияУТВызовСервера.ПолучитьСписокВыбораПеречисления(
		"ВидыБригадныхНарядов",
		ДанныеВыбора,
		Параметры,
		МассивИсключаемыхЗначений);
	
КонецПроцедуры

#КонецОбласти